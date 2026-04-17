# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'chat_to_post'

# Tests for the convert function in format.rb.
class FormatTest < Minitest::Test
  # Calls convert and strips surrounding whitespace for easier assertions.
  def fmt(input)
    convert(input).strip
  end

  def test_simple_user_message
    input = "❯ Hello there\n"
    assert_equal '**User:** Hello there', fmt(input)
  end

  def test_simple_claude_response
    input = "⏺ Here is my answer.\n"
    assert_equal 'Here is my answer.', fmt(input)
  end

  def test_user_then_claude
    input = <<~TEXT
      ❯ What is 2 + 2?

      ⏺ It's 4.
    TEXT
    assert_equal "**User:** What is 2 + 2?\n\nIt's 4.", fmt(input)
  end

  def test_welcome_banner_is_stripped
    input = <<~TEXT
      ╭─── Claude Code ───╮
      │  Welcome back!    │
      ╰───────────────────╯

      ❯ Hello
    TEXT
    assert_equal '**User:** Hello', fmt(input)
  end

  def test_slash_command_is_skipped
    input = <<~TEXT
      ❯ /login
      ❯ Hello
    TEXT
    assert_equal '**User:** Hello', fmt(input)
  end

  def test_thinking_line_is_skipped
    input = <<~TEXT
      ✻ Cogitated for 32s

      ❯ Hello
    TEXT
    assert_equal '**User:** Hello', fmt(input)
  end

  def test_tool_call_is_shown_as_italic
    input = "⏺ Bash(ls -la)\n"
    assert_equal '_Bash(ls -la)_', fmt(input)
  end

  def test_tool_output_is_skipped
    input = <<~TEXT
      ⏺ Bash(ls)
        ⎿  file.txt

      ⏺ Done.
    TEXT
    assert_equal "_Bash(ls)_\n\nDone.", fmt(input)
  end

  def test_tool_summary_line_is_skipped
    input = <<~TEXT
      ❯ Can you check?

        Read 1 file (ctrl+o to expand)

      ⏺ Yes, it looks fine.
    TEXT
    assert_equal "**User:** Can you check?\n\nYes, it looks fine.", fmt(input)
  end

  def test_multiline_user_message
    input = "❯ First line of\nthe message.\n"
    assert_equal '**User:** First line of the message.', fmt(input)
  end

  def test_user_message_with_wrap_artifact
    input = "❯ Please make it\n the way I want.\n"
    assert_equal '**User:** Please make it the way I want.', fmt(input)
  end

  def test_claude_response_continuation_is_joined
    input = "⏺ Line one\n  line two.\n"
    assert_equal 'Line one line two.', fmt(input)
  end

  def test_claude_response_with_wrap_artifact
    input = "⏺ It works by doing the thing and then\n   continuing on the next line.\n"
    assert_equal 'It works by doing the thing and then continuing on the next line.', fmt(input)
  end

  def test_claude_response_list_items_are_preserved
    input = <<~TEXT
      ⏺ Two options:

        1. First option which is quite
        long and wraps.
        2. Second option.
    TEXT
    assert_equal "Two options:\n\n1. First option which is quite long and wraps.\n2. Second option.", fmt(input)
  end

  def test_claude_multi_paragraph_response
    input = <<~TEXT
      ⏺ First paragraph here.
        More of first paragraph.

        Second paragraph here.
        More of second paragraph.

      ❯ Thanks.
    TEXT
    expected = "First paragraph here. More of first paragraph.\n\n" \
               "Second paragraph here. More of second paragraph.\n\n**User:** Thanks."
    assert_equal expected, fmt(input)
  end

  def test_user_message_stops_at_claude_response
    input = <<~TEXT
      ❯ A question
      that wraps.
      ⏺ An answer.
    TEXT
    assert_equal "**User:** A question that wraps.\n\nAn answer.", fmt(input)
  end

  def test_error_in_tool_output_is_skipped
    input = <<~TEXT
      ❯ Can you do it?
        ⎿  Please run /login · API Error: 401

      ❯ Hello
    TEXT
    assert_equal "**User:** Can you do it?\n\n**User:** Hello", fmt(input)
  end

  def test_drafted_content_becomes_blockquote
    input = <<~TEXT
      ⏺ Here's a suggestion:

        ▎ Group code by what it does together,
        not by type.

      ❯ Perfect.
    TEXT
    assert_equal "Here's a suggestion:\n\n> Group code by what it does together, not by type.\n\n**User:** Perfect.",
                 fmt(input)
  end

  def test_drafted_content_on_claude_line
    input = "⏺ ▎ Prefer functional cohesion.\n"
    assert_equal '> Prefer functional cohesion.', fmt(input)
  end

  def test_drafted_content_with_trailing_whitespace_wrap
    input = "⏺ Draft:\n\n  ▎ Boolean names should use prefixes like is, has, or  \n  should to make their type clear.\n"
    assert_equal "Draft:\n\n> Boolean names should use prefixes like is, has, or should to make their type clear.",
                 fmt(input)
  end

  def test_blank_line_within_blockquote_uses_gt
    input = <<~TEXT
      ⏺ Here's a draft:

        ▎ Heading

        ▎ - Item one.
        ▎ - Item two.
    TEXT
    assert_equal "Here's a draft:\n\n> Heading\n>\n> - Item one.\n> - Item two.", fmt(input)
  end

  def test_section_divider_becomes_bold_em_dash
    input = <<~TEXT
      ⏺ Here's a draft:

        ---
        ▎ Good code is easy to understand.
    TEXT
    assert_equal "Here's a draft:\n\n**—**\n\n> Good code is easy to understand.", fmt(input)
  end

  def test_drafted_list_becomes_blockquote_lines
    input = <<~TEXT
      ⏺ Here's the list:

        ▎ - Item one.
        ▎ - Item two.
    TEXT
    assert_equal "Here's the list:\n\n> - Item one.\n> - Item two.", fmt(input)
  end
end
