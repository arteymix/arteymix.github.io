---
layout: post
title: Ninth week update (from 15/06/15 to 26/06/15)
---

The past week were higly productive and I managed to release the `0.2.0-alpha`
with a very nice set of features.

There are 38 commits separating `v0.1.4-alpha` and `v0.2.0-alpha` tags and they
contain a lot of work.

<details>

  <summary>Click the arrow to see the 38 commits descriptions.</summary>

    1f9f7da Version bump to 0.2.0-alpha.
    0ecbf22 Fixes 9 warnings for the VSGI implementations.
    64df1f5 Test for the ChunkedConverter.
    cc9f320 Fixes libsoup-2.4 (<2.50) output stream operations.
    de27c7b Renames Server.application for Server.handle.
    f302255 Improvments for the documentation.
    c6587a0 Removes reference to connection in Response.
    5232c48 Write the head when a status is handled to avoid an empty message.
    61961ee Fixes the code formatting for the handling process.
    05aca66 Improves the documentation about asynchronous processing.
    41ce7a7 Removes timeout as it is not usable with the processing model.
    42bbfc7 Updates waf to 1.8.11 and uses the valac threading fix.
    7588cf2 Exposes head_written as a property in Response.
    4754131 Merge branch '0.2/redesign-async-model'
    409e920 Updates the documentation with 0.2/* changes.
    acf6200 Explicitly closes with async operations.
    22d8c54 Provides SimpleIOStream for gio-2.0 (<2.44).
    eeaeee1 Considers 0-sized chunk as ending chunk in ChunkedConverter.
    86b0752 Provides write_head and write_head_async to write status line and headers.
    11e3a34 Uses reference counting to free a request resources.
    19dc0e2 Replaces VSGI.Application with a delegate.
    53e6f24 Ignores the HTTP query in 'REQUEST_URI' environment variable.
    5596323 Improves testability of FastCGI implementation and provide basic tests.
    fb6b0c4 FastCGI streams uses polling to perform read and write operations.
    3ec5a22 Tests for the libsoup-2.4 implementation of VSGI.
    869fe00 Fixes 2 compilation warnings.
    dfc98e4 Adds a transparent gzip compression example using ZLibCompressor.
    79f9b18 Write request http_version in response status line.
    937ceb2 Avoid relying on states to write status line and headers.
    e73ebd6 Properly close the request and response body in end default handler.
    fc57bf0 Documentation for converters.
    384fd97 Reimplements chunked streams with a Converter.
    c7c718c Renames raw_body of base_stream in Response.
    0479739 steal_connection is available with libsoup-2.4 (>=2.50)
    2a25d8d Set Transfer-Encoding for chunked in Router setup with HTTP/1.1.
    c8ebad7 Writes status line and headers in end if it's not already done.
    1678cb1 Uses ChunkedOutputStream by default in Response base implementation.
    bb10337 Uses real stream by VSGI implementations.

</details>

Some of these commits were introduced prior to the seventh week update, the
exact date can be checked from GitHub.

In summary,

 - asynchronous processing with [RAII](https://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization)
 - steal the connection for libsoup-2.4 implementation
 - `write_head` and `write_head_async`
 - `head_written` property to check if the status line and headers has been
   written in the response

I am working toward a stable release with that serie, the following releases
will bring features around a solid core in a backward-compatible manner.

Three key points for what's coming next:

 - middlewares
 - components
 - documentation
 - distribution (RPM, Debian, ...)
 - deployment (Docker, Heroku, ...)

Finishing the APIs
------------------

All the features are there, but I really want to take some time to clean the
APIs, especially ensuring that naming is correct to make a nice stable release.

I have also seeked feedback on Vala mailing list, so that I can get some
reviews on the current code.

Asserting backward compatibility
--------------------------------

Eventually, the `0.2.0` will be released and marked stable. At this point, we
will have a considerable testsuite that can be used against following releases.

According to [semantic versionning](semver.org) (the releasing model we
follow), any hoftix or minor releases has to guarantee backward-compatibility
and it can easily be verified by running the testsuite from the preceeding
release against the new one.

Once we will have an initial stable release, it would be great to setup a hook
to run the older suites in the CI.

What's next?
------------

There is a lot of work in order to make Valum complete and I might not be done
by the summer. However, I can get it production-grade and usable for sure.

CGI and SCGI implementations are already working and I will integrate them in
the `0.3.0` along with some middlewares.

Middlewares are these little piece of processing that makes routing fun and
they were thouroughly described in the past posts. The following features will
make a really good start:

 - content negociation
 - internationalization (extract the domain from a request)
 - authentication (basic, digest, OAuth)
 - cache (`E-Tag`, `Last-Modified`, ...)
 - static resource serving from `File` or `Resource`
 - jsonify GObject

They will be gradually implemented in minor releases, but first they must be
thought out as there won't be no going-backs.

I plan to work a lot on optimizing the current code a step further by passing
it in Valgrind and identify the CPU, memory and I/O bottlenecks. The
improvments can be released in hotfixes.

Valum will be distributed on two popular Linux distributions at first: Ubuntu
and Fedora. I personally use Fedora and it would be a really great platform for
that purpose as it ships very innovative open source software.

Once distributed, it will be possible to install the software package in
a container like Docker or a hosting service like Heroku and make development
a pleasing process and large-scale deployment possible.

