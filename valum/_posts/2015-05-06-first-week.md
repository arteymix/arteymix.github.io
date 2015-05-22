---
layout: post
title: First week update! 04/05/15 to 08/05/15
tags: Vala
---

As part of the first week, I have to produce an initial document describing what
I will be working on during the semester. Once it's written down, I will post it
on this blog.

I have already a good idea of what I would like to work on:

 - finish VSGI specification
 - second alpha release & feedback from communities
 - SCGI implementation
 - mustache implementation for GLib
 - more tests and awesomeness

The first alpha release is already 4 years old and this one bring such radical
changes that we're almost starting over. Therefore, a second alpha release will
permit us to tease the targeted audience and obtain recommendations to build the
very best framework.

[SCGI](https://en.wikipedia.org/wiki/Simple_Common_Gateway_Interface) is a very
simple protocol to communicate HTTP messages over streams. It will take a real
advantage of the [GIO stream API](https://developer.gnome.org/gio/stable/) and
I am sure this could become an efficient way to serve web application in
production.

[Mustache](http://mustache.github.io/) (or any templating engine) is essential
if we want to bring Valum outside the web service development. I plan to
provide a GLib implementation so that it can be used anywhere. CTPL will remain
the default templating engine for its simplicity and convenience as it covers
quite well simple UI requirements.

Testing is part of any sane software development process. I will focus on
providing quality software that does not break easily.

Subsequent weeks will contain more sustained posts that will describe what have
been done, so stay put!

