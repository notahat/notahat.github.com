---
title: Ruby, λ-Calculus, and the Y&nbsp;Combinator
layout: post
published: false
---

<style>
/* All the λ characters get flagged as errors by pygment. This makes them at
   least show up in a nice style. */
.highlight .err { color: #0086B3; background-color: transparent; }
</style>

To kick off the new blog, I thought I'd start with the nerdiest bit of Ruby
I've ever written. The following calculates and prints the factorial of 6:

{% highlight ruby %}
# encoding: utf-8
alias λ lambda
p λ {|f| λ {|x| f[λ {|y| x[x][y] } ] }[λ {|x| f[λ {|y| x[x][y] }] }] } [λ {|f| λ {|n| n == 0 ? 1 : n * f[n-1] } }][6]}
{% endhighlight %}

(You'll need Ruby 1.9, and yes, you'll need to scroll to the right to see the whole crazy thing.)

What on earth is going on here? Why the hell would anyone want to calculate a
factorial in this ridiculous fashion? What's this λ-calculus malarky?

## λ-Calculus

Ever wondered why Ruby's `lambda` is called lambda? What do Greek letters have to
do with anonymous functions?

It gets its name from
[λ-calculus](http://en.wikipedia.org/wiki/Lambda_calculus), which is a way of
expressing programs mathematically, so that they can be reasoned about, and
proofs can be performed on them. It forms the theoretical basis for functional
programming.

Lambdas in λ-calculus are a lot like lambdas in Ruby, but they're even more
restrictive. For example, in λ-calculus, a lambda can take only one argument.
This is not allowed:

{% highlight ruby %}
add = lambda {|a, b| a + b }
add[2, 2] # => 4
{% endhighlight %}

The good news is that you can cheat and do what's known as
[currying](http://en.wikipedia.org/wiki/Currying):

{% highlight ruby %}
add = lambda {|a| lambda {|b| a + b } }
add[2][2] # => 4
{% endhighlight %}

This also lets you do [partial
application](http://en.wikipedia.org/wiki/Partial_application). You can call
the lambda with one argument, and it'll return a new lambda. For example:

{% highlight ruby %}
add = lambda {|a| lambda {|b| a + b } }
add10 = add[10] # Now I've got a new lambda that adds 10 to whatever is passed in.
add10[5] # => 15
{% endhighlight %}

This trick will come in handy later.


## Factorial in λ-Calculus

The easy way to write a factorial function in Ruby is with recursion:

{% highlight ruby %}
def factorial(n)
  n == 0 ? 1 : n * factorial(n-1)
end
{% endhighlight %}

In λ-calculus, however, there aren't any named functions. All we have
to work with are anonymous lambdas, so we'd have to write something
like this:

{% highlight ruby %}
lambda {|n| n == 0 ? 1 : n * factorial(n-1) }
{% endhighlight %}

Uh oh...see the problem? We're calling `factorial` recursively, but now we're
not defining factorial. We need to call our anonymous lambda recursively, but
we can't refer to it, because it's anonymous. What are we to do!?


## Enter the Y&nbsp;Combinator

No, Y&nbsp;Combinator is not just <a href="http://ycombinator.com">Paul
Graham's investment company</a>. Paul is a really big LISP nerd, so it
shouldn't come as a surprise that he took the name of his company from a key
bit of the mathematics behind functional programming.

Going back to our factorial function, wouldn't it be great if we could somehow
pass the function into itself as an argument? Then we could just call that
argument when we want to recurse. Our factorial lambda would look something like:

{% highlight ruby %}
lambda {|f| lambda {|n| n == 0 ? 1 : n * f[n-1] } }
{% endhighlight %}

(Note that to call a `lambda` with an argument in Ruby you use `f[n]`, not `f(n)`.)

But how do we pass this lambda into itself? Is such a thing even possible?
This is where the [Y
Combinator](http://en.wikipedia.org/wiki/Fixed-point_combinator#Y_combinator)
comes in. It does exactly that, and looks something like this:

{% highlight ruby %}
# encoding: utf-8
alias λ lambda
λ {|f| λ {|x| f[λ {|y| x[x][y] } ] }[λ {|x| f[λ {|y| x[x][y] }] }] }
{% endhighlight %}

(In order to make it more concise, I'm using Ruby 1.9's trick of allowing
unicode characters as identifiers. A little aliasing makes the code shorter,
more mathematical looking, and a lot more Greek, which is cool.)




## Sticking It All Together

I'm going to cheat for a minute and use some named variable assignment (which
isn't allowed in λ-calculus) to show what's going on:

{% highlight ruby %}
# encoding: utf-8
alias λ lambda

y_combinator = λ {|f| λ {|x| f[λ {|y| x[x][y] } ] }[λ {|x| f[λ {|y| x[x][y] }] }] }

factorial_step = λ {|f| λ {|n| n == 0 ? 1 : n * f[n-1] } }
factorial = y_combinator[factorial_step]

p factorial[6] # => 720
{% endhighlight %}

Finally, if we get rid of all those named variables, we're left with:

{% highlight ruby %}
# encoding: utf-8
alias λ lambda
p λ {|f| λ {|x| f[λ {|y| x[x][y] } ] }[λ {|x| f[λ {|y| x[x][y] }] }] } [λ {|f| λ {|n| n == 0 ? 1 : n * f[n-1] } }][6]
{% endhighlight %}

Clever, huh? Recursion implemented entirely with anonymous functions.


## Cheating

As verbose and arcane as this seems, we're still cheating wildly. In pure
λ-calculus, we don't have things like multiplication, or ternary operators. We
don't even have numbers!

I'm not going to dive into how you implement maths using just lambdas and no
numbers, but you'd be surprised at what you can pull off in even the simplest
of theoretical computation frameworks.


## And We're Done

Now you can safely forget all this theoretical nonsense, and go back to writing
nice, neat code in lovely high level languages, knowing that the computer
scientists have the theoretical underpinnings of what you do well in hand.

Move along. Nothing to see here.

