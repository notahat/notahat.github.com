#!/usr/bin/env ruby
# frozen_string_literal: true

# Converts a Claude Code exported chat (plain text) to Markdown suitable for
# publishing. Strips the welcome banner, tool output details, and thinking
# indicators, and formats user/assistant turns clearly.
#
# Usage: ruby chat_to_post.rb chat.txt > post.md

WELCOME_CHARS = %w[╭ │ ╰].freeze

# Returns true if the line is part of the welcome banner.
def welcome_line?(line)
  WELCOME_CHARS.any? { |char| line.start_with?(char) }
end

# Returns true if the line is a tool call (action taken by Claude).
def tool_call?(line)
  line.match?(/\A⏺ \w+[(\[]/)
end

# Returns true if the line is a tool output or summary.
def tool_output?(line)
  line.start_with?('  ⎿ ') ||
    line.match?(/\A\s+(Read|Searched|Wrote|Found|Updated|Ran|Done)\b/)
end

# Returns true if the line is a thinking/cogitation indicator.
def thinking?(line)
  line.start_with?('✻')
end

# Returns true if the line is a slash command entered by the user.
def slash_command?(line)
  line.match?(%r{\A❯ /\S+\s*\z})
end

# Returns true if the line is a non-content UI element that should be skipped
# without consuming any indented continuation lines.
def non_content_line?(line, output)
  welcome_line?(line) || slash_command?(line) || (line.strip.empty? && output.empty?)
end

# Returns true if the line is a Claude Code process indicator (thinking or tool
# output) that should be skipped along with any indented continuation lines.
def process_indicator?(line)
  thinking?(line) || tool_output?(line)
end

# Formats a tool call line as a brief italicised annotation.
def format_tool_call(line)
  "_#{line.sub(/\A⏺ /, '').rstrip}_"
end

# Returns true if the user message continues on the next line.
def user_message_continues?(lines, index)
  !lines[index].strip.empty? && !tool_output?(lines[index]) &&
    !lines[index].start_with?('⏺') && !lines[index].start_with?('❯')
end

# Collects a user message starting from the ❯ line at +start+. Continuation
# lines end at the first blank line. Returns [text, next_index].
def collect_user_message(lines, start)
  words = [lines[start].sub(/\A❯ /, '').strip]
  index = start + 1
  while index < lines.size && user_message_continues?(lines, index)
    words << lines[index].strip
    index += 1
  end
  [words.reject(&:empty?).join(' '), index]
end

# Formats the first line of a Claude response, converting drafted content
# (lines starting with ▎) to markdown blockquotes.
def format_first_line(line)
  line.start_with?('▎') ? "> #{line.sub(/\A▎ ?/, '')}" : line
end

# Appends a bold em-dash section break to +block+, with surrounding blank
# lines to ensure it renders as a standalone paragraph.
def append_section_divider(block)
  block << '' unless block.last && block.last.empty?
  block << '**—**'
  block << ''
end

# Appends one stripped continuation line to +block+, handling section
# dividers, drafted content, list items, and word-wrap joins.
def append_continuation_line(stripped, block)
  if stripped == '---'
    append_section_divider(block)
  elsif stripped.start_with?('▎')
    block << "> #{stripped.sub(/\A▎ ?/, '')}"
  elsif stripped.match?(/\A(\d+\.|-|\*|•)/) || block[-1].empty?
    block << stripped
  else
    block[-1] = "#{block[-1]} #{stripped}"
  end
end

# Collects indented continuation lines into +block+. Returns the new index.
def collect_paragraph(lines, index, block)
  while index < lines.size && lines[index].match?(/\A {2,}/)
    append_continuation_line(lines[index].strip, block) unless tool_output?(lines[index])
    index += 1
  end
  index
end

# Ensures blank lines separating blockquote lines carry a > marker to maintain
# markdown blockquote continuity.
def fix_blockquote_continuity(block)
  block.each_with_index.map do |line, i|
    line.empty? && block[i - 1]&.start_with?('>') && block[i + 1]&.start_with?('>') ? '>' : line
  end
end

# Returns the index of the start of the next indented paragraph after a blank
# line at +index+, or nil if none exists.
def find_next_paragraph(lines, index)
  lookahead = index + 1
  lookahead += 1 while lookahead < lines.size && lines[lookahead].empty?
  lookahead if lookahead < lines.size && lines[lookahead].match?(/\A {2,}/)
end

# Collects lines belonging to a Claude text response, including multiple
# paragraphs separated by blank lines (as long as each paragraph is indented).
# Returns [lines, next_index].
def collect_claude_response(lines, start)
  block = [format_first_line(lines[start].sub(/\A⏺ /, '').strip)]
  index = start + 1

  loop do
    index = collect_paragraph(lines, index, block)
    break unless index < lines.size && lines[index].empty?

    next_para = find_next_paragraph(lines, index)
    break unless next_para

    block << ''
    index = next_para
  end

  [fix_blockquote_continuity(block), index]
end

# Advances index past any indented continuation lines.
def skip_indented_lines(lines, index)
  index += 1 while index < lines.size && lines[index].match?(/\A {2,}/)
  index
end

# Appends a blank separator to output before starting a new turn, if needed.
def ensure_separator(output)
  output << '' if output.any? && !output.last.empty?
end

# Appends a formatted user message to output and returns the next index.
def handle_user_message(lines, index, output)
  ensure_separator(output)
  text, index = collect_user_message(lines, index)
  output << "**User:** #{text}"
  index
end

# Appends a formatted tool call annotation to output and returns the index
# after the tool output block.
def handle_tool_call(lines, index, output)
  ensure_separator(output)
  output << format_tool_call(lines[index])
  skip_indented_lines(lines, index + 1)
end

# Appends a formatted Claude response to output and returns the next index.
def handle_claude_response(lines, index, output)
  ensure_separator(output)
  block, index = collect_claude_response(lines, index)
  output << block.join("\n")
  index
end

# Handles one turn line, appending to output and returning the new index.
def dispatch_turn(lines, index, line, output)
  return handle_user_message(lines, index, output) if line.start_with?('❯ ')
  return handle_tool_call(lines, index, output) if tool_call?(line)
  return handle_claude_response(lines, index, output) if line.start_with?('⏺ ')

  output << (line.strip.empty? ? '' : line)
  index + 1
end

# Processes one line from the input, appending to output and returning the new
# index. Skips non-content lines and delegates turn handling to dispatch_turn.
def process_line(lines, index, output)
  line = lines[index]
  return index + 1 if non_content_line?(line, output)
  return skip_indented_lines(lines, index + 1) if process_indicator?(line)

  dispatch_turn(lines, index, line, output)
end

def convert(input)
  lines = input.lines.map(&:chomp)
  output = []
  index = 0
  index = process_line(lines, index, output) while index < lines.size

  # Collapse consecutive blank lines to a single blank line.
  output
    .each_with_object([]) { |line, result| result << line unless line.empty? && result.last&.empty? }
    .join("\n")
end

puts convert(ARGF.read) if __FILE__ == $PROGRAM_NAME
