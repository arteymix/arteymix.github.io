---
layout: post
title: Third week update! 10/05/15 to 22/05/15
tag: gcc
---

In the past two weeks, I've been working on the roadmap for the `0.1.0-alpha`
release.

### gcov

`gcov` has been fully integrated to measure code coverage with
[cpp-coveralls](https://github.com/eddyxu/cpp-coveralls). `gcov` works by
injecting code during the compilation with `gcc`.

You can see the coverage on [coveralls.io](https://coveralls.io/r/valum-framework/valum),
it's updated automatically during the CI build.

Current master branch coverage: [![Coverage Status](https://coveralls.io/repos/valum-framework/valum/badge.svg?branch=master)](https://coveralls.io/r/valum-framework/valum?branch=master)

The inconvenient is that since coveralls measures coverage from C sources using
`valac` generated C code, it is not possible to identify which regions are
covered in Vala. However, it is still possible to identify these regions in the
generated code.

### Asynchronous handling of requests

I changed the request handling model to be fully asynchronous.
`VSGI.Application` handler have become an async function, which means that
every user request will be processed concurrently as the server can immediatly
accept a new request.

### Merged glib-application-integration in the trunk

The branch was sufficiently mature to be [merged in the trunk](https://github.com/valum-framework/valum/pull/65).
I will only work on coverage and minor improvements until I reach the second
alpha release.

It brings many improvements:

 - VSGI.Server inherit from GLib.Application, providing enhancements described in
   the [Roadmap for 0.1.0-alpha](roadmap)
 - setup and teardown in the Router for pre and post processing of requests
 - user documentation improvments (Sphinx + general rewrites)
 - optional features based on gio-2.0 and libsoup-2.4 versions

### 0.1.0-alpha released!

I have released a `0.1.0-alpha` version. For more information, you can read the
[release notes on GitHub](https://github.com/valum-framework/valum/releases/tag/v0.1.0-alpha),
download it and try it out!

