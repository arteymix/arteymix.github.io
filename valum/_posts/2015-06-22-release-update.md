---
layout: post
title: 0.1.4-alpha released!
---

I am happy to announce the release of a [0.1.4-alpha]() version of Valum web
micro-framework that bring minor improvments and complete CLI options for
`VSGI.Soup`.


Cookies
-------

The cookies were moved from VSGI to Valum since it's only an abstraction over
request and response headers. VSGI aims to be a minimal protocol and should
provide just enough abstraction for the HTTP stack.


CLI options for VSGI.Soup
-------------------------

This is quite of a change and brings a wide range of new possibilities with the
libsoup-2.4 implementation. It pretty much exposes [Soup.Server](http://valadoc.org/#!api=libsoup-2.4/Soup.Server)
capabilities through CLI arguments.

In short, it is now possible to:

 - listen to IPv4 or IPv6 only
 - listen from a file descriptor
 - liste from all network interfaces (instead of locally) with `--all`
 - enable HTTPS and specify a certificate and a key
 - set the `Server` header with `--server-header`
 - prevent `Request-URI` from being url-decoded with `--raw-paths`

The implementation used to listen from all interfaces, but this is not
a desired behiaviour. The `--all` flag will let the server listen on all
interfaces.

The behiaviour for `--timeout` has been fixed and now relies on the presence of
the flag to _enable_ a timeout instead of a non-zero value. This brings the
possibility to set a timeout of value of `0`.

There is some potential work for supporting arbitrary socket, but it would
require a new dependency `gio-unix` that would only support UNIX-like systems.

