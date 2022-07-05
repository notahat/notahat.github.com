---
title: Writing HTML
description: A list of techniques for writing good HTML and CSS.
layout: article
published: true
---

This is a list of techniques I used to build this little site, based on my experience working on much bigger sites like [Envato Elements](https://elements.envato.com/).

This was my first time in a while writing HTML and CSS from scratch.
I was rusty, and had to look up many things.
I'm writing this to help future-me next time he has the same problem.
Hopefully it'll help someone else too.

If you're curious, you can find [the source to this site on GitHub](https://github.com/notahat/notahat.github.com).
It's built with [Jekyll](https://jekyllrb.com) and hosted on [GitHub Pages](https://pages.github.com).

## What's Not On The List

I'm sticking to things that I think are applicable to just about all websites.
I'm ignoring tools, frameworks, and hosting.

## The Techniques

Here they are in alphabetical order (for want of a more meaningful organisational scheme.)

### Accessibility

Learn to use a screen reader.
It's hard to know how your site will work with one unless you can try it out.
There's a [good intro to VoiceOver](https://youtu.be/5R-6WvAihms) on YouTube.

Use [HTML Sections](https://html.spec.whatwg.org/multipage/sections.html) to mark the important parts of your page.
Look at the accessibility tree in the Chrome dev tools, and ensure it makes sense.

Understand [<abbr title="Accessible Rich Internet Applications">ARIA</abbr>](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA) and when you need to apply roles and labels.
Follow the [five rules of ARIA use](https://www.w3.org/TR/using-aria/#notes2).
[Use native elements](https://www.w3.org/TR/using-aria/#rule1) rather than ARIA attributes whenever you can.

In Chrome, run Lighthouse in the dev tools, and look at the Accessibility results.
In Safari, run an accessiblity audit in the Audit tab of the dev tools.

### BEM &mdash; Block Element Modifier

[BEM](http://getbem.com//) is a straightforward approach to the problem of keeping your CSS well organised.
It's simple enough for small sites, and I've seen it scale well to much larger ones too.

### Favicons

Your site should have favicons in resolutions to suit different devices.
[Favicon.io](https://favicon.io) is an easy way to generate the necessary images, and the tags needed in your `head` section.

### Flexbox and Grid

Thankfully, laying out pages doesn't require all the hackery it used to.
Get to know flexbox and grid, and life will be easier.
[The Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) and [The Complete Guide to Grid](https://css-tricks.com/snippets/css/complete-guide-grid/) are excellent.

### Fonts

We don't all have design skills, so don't get fancy.
You'll just make a mess if you try.
The best number of fonts for your site is one, maybe two.

[Google Fonts](https://fonts.google.com) is your friend.
Only add the styles and weights you need.
Make sure you don't miss any, because browser generated bold and italics are awful.
Use the `<link>` method of embedding.

### HTML Living Standard

We've moved past HTML version numbers, and it's now a [living standard](https://html.spec.whatwg.org/multipage/).
To tell browsers that you're adhering to that standard, always start your document with:

{% highlight HTML %}

<!DOCTYPE html>
<html lang="en">
{% endhighlight %}

Use UTF-8:

{% highlight HTML %}

<meta charset="utf-8">
{% endhighlight %}

### MDN

### Performance

Lighthouse

Core Web Vitals

TO DO: Export the Lighthouse report for this page and link to it.

### Prettier

[Prettier](https://prettier.io/) formats your HTML and CSS for you.
Your favourite editor probably has support for it, and you can set it up to format automatically whenever you save.
Just use it.
Save your brain for more important things than deciding how to format your source code.

### Reader View

Try your page in Safari's Reader View, either on a Mac, iPhone, or iPad.
If your page looks better in Reader View, improve your design.

### Responsive Design

People will read your site on phones and tablets, as well as laptops and desktops.
It should work well at all sizes.

Design for mobile first.
If you make your site work well on a phone, it's relatively easy to make it work well on bigger screens from there.
Going the other way is harder.

You'll want one of these in your page's `head` section to tell mobile browsers that you've thought of them:

{% highlight HTML %}

<meta
  name="viewport"
  content="width=device-width, initial-scale=1.0"
/>
{% endhighlight %}

Chrome, Firefox, and Safari all have built-in ways of previewing your site at phone and tablet sizes.

### SASS and SCSS

[SASS](https://sass-lang.com)

### SEO

- Good descriptive title
- Description meta tag
- Write meaningful, concise pages, and don't try to game Google
- Good performance

[Google SEO Starter Guide](https://developers.google.com/search/docs/beginner/seo-starter-guide)

To do:

- Add a README
- Get better syntax highlighting CSS
