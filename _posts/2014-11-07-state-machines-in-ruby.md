---
title: State Machines in Ruby
layout: post
published: true
---

I'm not a fan of the currently popular Ruby state machine gems ([state_machine](https://github.com/pluginaweek/state_machine), [AASM](https://github.com/aasm/aasm)). State machines are simple, and these are complicated gems with large APIs.

I had a tinker with implementing the simplest state machine I could in Ruby, with just the features I needed. What follows is what fell out of that tinkering. It's all in roughly hand-tested form, so it comes with no warranty of any kind. I might expand this into a gem at some point.


## Transition Tables

First up, it seems like a transition table would be the easiest way to specify a state machine in Ruby. We don't need a DSL for this:

{% highlight ruby %}
transition_table = TransitionTable.new(
  # State         Input     Next state      Output
  [:awaiting_foo, :foo] => [:awaiting_bar,  :do_stuff],
  [:awaiting_foo, :bar] => [:awaiting_foo,  :do_nothing],
  [:awaiting_bar, :bar] => [:all_done,      :do_other_stuff]
)
{% endhighlight %}

You'll see why I use this hash structure below. (It might be nicer to turn this into simple nested arrays, and have the `TransitionTable` convert to a hash.)

What we want for actually running the state machine is a transition function: a function that takes the current state and some input, and returns the next state and some output.

We can make the transition table behave like that pretty easily:

{% highlight ruby %}
class TransitionTable
  def initialize(transitions)
    @transitions = transitions
  end

  def call(state, input)
    @transitions[[state, input]]
  end
end
{% endhighlight %}


## The State Machine

Now we've got a way of specifying states and transitions, we need something to run the state machine.

{% highlight ruby %}
class StateMachine
  def initialize(transition_function, initial_state)
    @transition_function = transition_function
    @state = initial_state
  end

  attr_reader :state

  def send_input(input)
    @state, output = @transition_function.call(@state, input)
    output
  end
end
{% endhighlight %}

We can fire up a state machine like this:

{% highlight ruby %}
state_machine = StateMachine.new(transition_table, :awaiting_foo)

state_machine.state             # => :awaiting_foo
state_machine.send_input(:foo)  # => :do_stuff
state_machine.state             # => :awaiting_bar
{% endhighlight %}


## Calling Methods on Transitions

I want to include a state machine in my model, and have methods on the model called when transitions happen. I can do something like this:

{% highlight ruby %}
class MyModel
  STATE_TRANSITIONS = TransitionTable.new(
    # State         Input     Next state      Output
    [:awaiting_foo, :foo] => [:awaiting_bar,  :do_stuff],
    [:awaiting_foo, :bar] => [:awaiting_foo,  nil],
    [:awaiting_bar, :bar] => [:all_done,      :do_other_stuff]
  )

  def initialize
    @state_machine = StateMachine.new(STATE_TRANSITIONS, :awaiting_foo)
  end

  def handle_event(event)
    action = @state_machine.send_input(event)
    send(action) unless action.nil?
  end

  def do_stuff
    # ...
  end

  def do_other_stuff
    # ...
  end
end
{% endhighlight %}


## Drawing a Picture

It'd be great if we could get a state diagram out of this, so:

{% highlight ruby %}
class GraphvizFormatter
  HEADER = "digraph G {"
  FOOTER = "}"

  def format(transition_table)
    edges = transition_table.map do |current_state, input, next_state, output|
      %{  "#{escape(current_state)}" -> "#{escape(next_state)}" [ label=" #{escape(input)}/#{escape(output)}" ]}
    end

    [HEADER, *edges, FOOTER].join("\n")
  end

private

  def escape(string)
    string.to_s.gsub('"', '\\"')
  end
end
{% endhighlight %}

That requires being able to iterate over the `TransitionTable`, so we'll need:

{% highlight ruby %}
class TransitionTable
  include Enumerable

  def each
    @transitions.each_pair do |key, value|
      current_state, input  = *key
      next_state,    output = *value
      yield current_state, input, next_state, output
    end
  end
end
{% endhighlight %}

Throwing this and [Graphviz](http://www.graphviz.org) at the above transition table gives:
<img src="/images/state-machine.png" width="305" height="288" alt="State diagram">


## Further Tinkering

There are a bunch more things I'd like to tinker with:

- Raising exceptions for unhandled inputs
- Nested state machines
- Triggering output on entering or leaving states
