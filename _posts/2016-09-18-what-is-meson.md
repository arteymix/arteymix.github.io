---
layout: post
title: What is Meson?
tags: Meson Vala
---

I have discovered [Meson][1] a couple of years back and since then use it for most
of my projects written in Vala. This post is an attempt at describing the good,
bad and ugly of the build system.

So, what is Meson?

 - a build system
 - portable (see Python portability)
 - a Ninja generator
 - use case oriented
 - fast
 - opiniated

What it's not?

 - a general purpose build system
 - a Turing-complete language
 - extensible (only in Python)

It handle 80% of the cases nicely and elegantly.

Since it is use case oriented, features are introduced on need. It keeps
a tight balance between conciseness, generality and features.

It mixes configure and build step so that the build essentially become one big
tree. Then, the build system determine what goes into the configuration and what
goes into the build.

The cognitive load is very low, which means it's very easy to learn the basics
and make actual usage of it. This is critical, because all the time spent on
setting the build hardly contribute to the project goal.

The following is a basic build that check for dependencies (using
[pkg-config][2]) and build an executable:


```python
project('Meson Example', 'c', 'vala')

glib = dependency('glib-2.0')
gobject = dependency('gobject-2.0')

executable('app', 'app.vala', dependencies: [glib, gobject])
```

Building becomes a piece of cake:

```bash
mkdir build && cd build
meson ..
ninja
```

Only a few keywords are sufficient for most builds:

 - `executable`
 - `library` with `shared_library` and `static_library`
 - `dependency`
 - `declare_dependency`

Built-in benchmarks and tests, just pass the executable to either `benchmark`
or `test`.

The main downside is that if what you want to do is not *supported*, you either
have to hack things or wait until the feature gets into the build system.

The system is very opiniated. It's both a good and bad thing. Good since you
don't need to write a lot to get most jobs done. Bad because you might hit
a wall eventually.

There's also the Python question. It requires at least 3.4. This is becoming
less an problematic as old distributions progressively die out, but still can
prevent you now. Here's a few ideas to remedy this problem:

 - build a dependency-free zipball (see [issue #588][3])
 - backport Meson to older Python version

Meson is getting better over time and so far has managed to become the best
build system for Vala. This is why I highly recommend it.

[1]: http://mesonbuild.com/
[2]: https://www.freedesktop.org/wiki/Software/pkg-config/
[3]: https://github.com/mesonbuild/meson/issues/588
