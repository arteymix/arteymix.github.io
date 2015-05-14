---
layout: post
title: Third week update!
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

