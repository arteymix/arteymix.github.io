---
layout: post
title: Work on Memcached-GLib
---

The past few days, I've been working on a really nice [libmemcached](http://libmemcached.org/libMemcached.html)
GLib wrapper.

 - main loop integration
 - fully asynchronous API
 - error handling

The whole code is available under the LGPLv3 from [arteymix/libmemcached-glib](https://github.com/arteymix/libmemcached-glib/tree/master/benchmarks).

It should reach 1.0 very quickly, only a few features are missing:

 - a couple of function wrappers
 - integration for libmemcachedutil
 - async I/O improvements

Once released, it might be interesting to build a GTK UI for Memcached upon
that work. Meanwhile, it will be a very useful tool to build fast web
applications with [Valum](valum).

