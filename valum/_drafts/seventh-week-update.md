---
title: Seventh week update
---

Since the `0.1.0-alpha` release, I have been releasing a bugfix release every
week and the APIs are stabilizing very well.

I have released `0.1.2-alpha` with a couple of bugfixes, status code handlers
and `null` rules.

I am working on a `0.1.3-alpha` that would focus on bugfixing again and support
more status codes.

### Toward a minor release!

I have been delayed by a bug when I introduced the `end` continuation to
perform request teardown and I hope I can solve it by friday. To avoid blocking
the development, I have been introducing changes in the master branch and
rebased the `0.2/*` upon them.

The `0.2.0-alpha` will introduce very important changes that will define the
asynchronous processing model we want for Valum:

 - write the response status line and headers asynchronously
 - end continuation invoked in synchronous or asynchronous contexts
 - assign the bodies to filter or redirect them
 - lower-level libsoup-2.4 implementation that takes advantage of non-blocking
   stream operations
 - polling for FastCGI to perform non-blocking operations

Most of these changes have been implemented and will require tests to ensure
their correctness.

I have been working on CGI and SCGI prototypes as these are two very important
protocols for the future of VSGI.

CGI implements the basic CGI specification which is reused in protocols like
FastCGI and SCGI. The great thing is that they can use inheritence to reuse
behiaviours from CGI like the environment extraction to avoid code duplication.
