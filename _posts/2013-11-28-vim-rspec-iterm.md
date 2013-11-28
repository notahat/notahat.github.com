---
title: Vim, RSpec, and iTerm
layout: post
published: false
excerpt: Run your RSpec files in iTerm from Vim.
---

I use the [rspec.vim](https://github.com/thoughtbot/vim-rspec) plugin, but
configure it to use a custom script for running spec files:

{% highlight vim %}
let g:rspec_command = "silent !~/bin/run_in_iterm 'bundle exec rspec {spec}'"
{% endhighlight %}

The `run_in_iterm` script looks like this:

{% highlight applescript %}
#!/usr/bin/osascript

on run argv
  tell application "iTerm"
    set myCommand to item 1 of argv
    try
      set mySession to the current session of the current terminal
    on error
      set myTerminal to (make new terminal)
      tell myTerminal
        launch session "Default"
        set mySession to the current session
      end tell
    end try
    tell mySession to write text myCommand
  end tell
end run
{% endhighlight %}

Finally I have some helpful key bindings:

{% highlight vim %}
noremap <Leader>sa :call RunAllSpecs()<CR>
noremap <Leader>sc :call RunCurrentSpecFile()<CR>
noremap <Leader>sl :call RunLastSpec()<CR>
noremap <Leader>sn :call RunNearestSpec()<CR>
{% endhighlight %}
