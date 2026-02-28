---
date: "2025-02-28T14:30:00Z"
title: "Nixie tube native web component"
description: "Vanilla ES6 web component displaying a nixie tube with digits 0-9.:"
images:
- "/images/2025/nixie.jpg"
tags:
- javascript
- www
---

# Nixie tube native web component

As I was interested in how far standards-based frontend web development has come, I decided to create a simple web
component that displays a nice little nixie tube. A nixie tube is a display device that was used in the 1950s and
1960s to display information using gas-filled tubes, before new-fangled LEDs was developed.

![Nixie tubes](/images/2025/nixie.jpg)

In my role as architect, I have been working with large SPA applications with huge stacks of npm
dependencies that cause sluggish build times and bloated maintenance. I'm looking at you Angular, React and Vue and
webpack.

Modern browsers support web components natively, which allows for creating reusable components that can
be used across different frameworks and libraries.

My requirements were zero dependencies and no build step. I wanted to write the component in vanilla ES6, let the
browser simply load the original module directly and use the shadow DOM to encapsulate the component's internals.

The result can be seen in this [sample page](https://klinkby.github.io/nixie-digit/src/) that includes the custom
element `<nixie-digit>` to display a clock.

My conclusion is that native web component is a viable alternative to the traditional SPA frameworks for building
custom elements.

Check out my MIT licensed [Github repo](https://github.com/klinkby/nixie-digit).

The beautiful image sprites are
[The real Nixie tube indicator a set of decimal digits](https://depositphotos.com/photo/the-real-nixie-tube-indicator-a-set-of-decimal-digits-45965467.html)
by LLEPOD. [Licensed](https://depositphotos.com/license.html) royalty-free for personal and commercial purposes.
