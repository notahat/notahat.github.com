---
title: Vim Script for Programmers
layout: post
---

The rules and grammar of Vim script can be a little confusing for programmers used to other languages. This post will help you get your head around them.


## Expressions

[Expressions](http://vimdoc.sourceforge.net/htmldoc/usr_41.html#41.3) are what you're used to writing if you program in a language like Ruby, or Java, or C.

To try out some expressions in Vim, you can use `echo`:

{% highlight vim %}
:echo 6 * 7
" => 42

:echo "foo" . "bar"
" => foobar

:echo toupper("foobar")
" => FOOBAR
{% endhighlight %}

Just like regular programming, right? The catch is that most of the time in Vim script you're not writing expressions.


## Commands

When you type `:echo something` into vim, you're running the [echo command](http://vimdoc.sourceforge.net/htmldoc/eval.html#:echo).

Vim scripts consist entirely of commands. Commands take various arguments, and the format of those arguments varies from command to command.

The help for the echo command (type `:help :echo` in Vim to check it out) describes the command format as:

    :ec[ho] {expr1} ..

So echo expects a series of expressions as arguments, and evaluates each one.

Most commands, however, have arguments that aren't expressions. Take the [edit command](http://vimdoc.sourceforge.net/htmldoc/editing.html#:edit) for example:

    :e[dit] [++opt] [+cmd] {file}

No expression in site. The command `edit "foo" . "bar"` will not open the file `foobar`.


## Interlude

Before we go on, a short note about colons.

When you type a command in Vim, you always precede it with a colon. This is what tells Vim that the following thing is a command.

In the Vim documentation, commands are always preceded by colons, to distinguish them from functions, variables, etc.

In Vim scripts, however, the colons are entirely optional. Don't be confused though: each line of the script file is still a command, even without the colon.


## Bridging Two Worlds

So what happens if you want to use an expression as an argument a command that doesn't normally take expressions as arguments?

Vim provides a command called [execute](http://vimdoc.sourceforge.net/htmldoc/eval.html#:execute) to do just that.  It evaluates an expression, and then executes the result of that expression as though it were another command.

For example, if you give Vim this command:

{% highlight vim %}
execute "edit " . "foo" . "bar"
{% endhighlight %}

it will evaluate the expression `"edit " . "foo" . "bar"`, then run the result:

{% highlight vim %}
edit foobar
{% endhighlight %}

Now that you're generating commands as strings, you've got to watch out for escaping. Vim provides helpful functions for this. For example, for filenames you can do:

{% highlight vim %}
execute "edit ". fnameescape("foo" . "bar")
{% endhighlight %}


## Functions

Vim lets you define your own functions:

{% highlight vim %}
function! TheMeaning()
  return 6 * 7
endfunction
{% endhighlight %}


## An Example Script

Here's a Vim script I'm writing to let me rename a file I have open.

{% highlight vim %}
function! s:Rename(new_name)
  let existing_name = bufname("%")

  " Change the name of the current buffer.
  execute "keepalt file " . fnameescape(a:new_name)
  write

  " Delete the old file.
  call delete(l:existing_name)
endfunction

command! -nargs=1 -complete=file Rename call s:Rename(<f-args>)
{% endhighlight %}




