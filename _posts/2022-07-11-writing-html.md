---
title: Writing HTML
description: A list of techniques for writing good HTML and CSS.
layout: article
published: true
---

These are my recommendations for techniques you should use when writing HTML, based on my experience working on sites like [Envato Elements](https://elements.envato.com/).

I used these techniques to build the site you're reading now.
You can read [the source to this site on GitHub](https://github.com/notahat/notahat.github.com).

## What's Not On The List

I'm sticking to things that are applicable to just about all websites.
I'm ignoring tools, frameworks, and hosting.

## The Techniques

Here they are in alphabetical order (for want of a more meaningful organisational scheme.)

### Accessibility

In Chrome, run Lighthouse in the dev tools, and look at the accessibility results.
In Safari, run an accessibility audit in the Audit tab of the dev tools.
Fix the things they point out.

Make sure you can navigate your site with the keyboard.
You'll need to [turn on tab-key navigation](https://www.warpwire.com/support/playback/enable-tab-key-navigation/).

Try your site in a screen reader.
There's a learning curve, but you can't really tell if your accessibility is up to scratch unless you try it.
Google has a good [video intro to VoiceOver, the built-in screen reader on MacOS](https://youtu.be/5R-6WvAihms).

Use [HTML Sections](https://html.spec.whatwg.org/multipage/sections.html) to mark the important parts of your page.
Look at [the accessibility tree in Chrome dev tools](https://developer.chrome.com/blog/full-accessibility-tree/), and ensure it makes sense.

Know about [Accessible Rich Internet Applications](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA).
Follow the [five rules of ARIA use](https://www.w3.org/TR/using-aria/#notes2).

Know about the [Web Content Accessibility Guidelines](https://www.w3.org/WAI/standards-guidelines/wcag/).
Compare your site to the [WCAG Quick Reference](https://www.w3.org/WAI/WCAG21/quickref/).

### BEM &mdash; Block Element Modifier

[BEM](http://getbem.com//) is a straightforward approach to the problem of keeping your CSS well organised.
It's simple enough for small sites, and I've seen it scale well to much larger ones too.

### Favicons

Your site should have favicons in resolutions to suit different devices.
[Favicon.io](https://favicon.io) is an easy way to generate the necessary images, and the tags needed in your `head` section.

### Flexbox and Grid

Flexbox and Grid eliminate much of the hackery in laying out pages.
[The Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) and [The Complete Guide to Grid](https://css-tricks.com/snippets/css/complete-guide-grid/) are excellent.

### Fonts

We don't all have design skills, so don't get fancy.
The best number of fonts for your site is one, maybe two.

[Google Fonts](https://fonts.google.com) is your friend.
Only add the styles and weights you need.
Make sure you don't miss any, because browser generated bold and italics are awful.
Use the `<link>` method of embedding.

### HTML Living Standard

We've moved past HTML version numbers, and it's now a [living standard](https://html.spec.whatwg.org/multipage/).
[Can I Use](https://caniuse.com) helps figure out which HTML features are supported by which browser versions.

To tell browsers that you're adhering to the living standard, always start your document with:

{% highlight HTML %}
<!DOCTYPE html>
<html lang="en">
{% endhighlight %}

Be sure to specify your character set in the `head` section:

{% highlight HTML %}
<meta charset="utf-8">
{% endhighlight %}


### MDN

[MDN](https://developer.mozilla.org/en-US/) is an excellent source for HTML and CSS documentation.
[W3Schools](https://www.w3schools.com) shows up at the top of searches more often, but tends to be less detailed and less up to date than MDN.

### Performance

Understand [Core Web Vitals](https://web.dev/vitals/#core-web-vitals).

Run Lighthouse in the Chrome dev tools, and looks at its performance report.
It'll suggest things you can improve.

### Prettier

Use [Prettier](https://prettier.io/) to format your HTML and CSS.
Save your brain for more important things than deciding how to format your source code.
Your favourite editor probably has support for it.
Set it up to format automatically whenever you save.

### Reader View

Try your page in Safari's Reader View, either on a Mac, iPhone, or iPad.
If your page looks better in Reader View, improve your design.

### Responsive Design

People will read your site on phones, tablets, laptops, and desktops.
It should work well at all sizes.

Design for phones first.
If you make your site work well on a phone, it's relatively easy to make it work well on bigger screens from there.
Going the other way is harder.

Put this in your page's `head` section to tell mobile browsers that you've thought of them:

{% highlight HTML %}
<meta
  name="viewport"
  content="width=device-width, initial-scale=1.0"
/>
{% endhighlight %}

Chrome, Firefox, and Safari all have built-in ways of previewing your site at phone and tablet sizes.

### SASS and SCSS

Just about every site generator and framework supports [SASS](https://sass-lang.com) these days.
You should use it.
Use [SCSS syntax](https://sass-lang.com/documentation/syntax#scss).

### SEO

Stick to the basics, and don't try to game Google.
Make sure all your pages have:

- A descriptive title
- A description meta tag
- Good headings
- Meaningful, concise content
- Good performance

The [Google SEO Starter Guide](https://developers.google.com/search/docs/beginner/seo-starter-guide#understand_your_content) is helpful.
