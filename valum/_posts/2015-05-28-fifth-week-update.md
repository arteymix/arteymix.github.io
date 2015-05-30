---
layout: post
title: Fifth week update 15/05/15 to 29/05/15
---

These past two weeks, I have bee working on a new release `0.2.0-alpha` and
fixed a couple of bugs in the last release.

To make thing simple, this report will cover what have been introduced in
`0.1.1-alpha` and `0.2.0-alpha` releases separately.

The `0.2.0-alpha` should be released by the fifth of june (05/05/15) and will
introduce the *so awaited* asynchronous processing model.

As of right now
---------------

I have fixed a couple of bugs, backported minor changes from the `0.2.0-alpha`
and introduced minor features for the `0.1.1-alpha` release.

Here's the changelog:

    e66277c Route must own a reference to the handler.
    ec89bef Merge pull request #85 from valum-framework/0.1/methods
    b867548 Documents all and methods for the Router.
    42ecd2f Binding a callback to multiple HTTP methods.
    e81d4d3 Documents how errors are handled with the next continuation.
    5dd296e Example using the next continuation.
    ec16ea7 Throws a ClientError.NOT_FOUND in process_routing.
    fb04688 Introduces Next in Router.
    79d6ef5 Support HTTPS URI scheme for FastCGI.
    29ce894 Uses a synchronous request processing model for now.
    e105d00 Configure option to enable threading.
    5f8bf4f Request provide HTTPVersion information.
    0b78178 Exposes more GObject properties for VSGI.
    33e0864 Renames View splice function for stream.
    3c0599c Fixes a potential async bug with Soup implementation.
    91bba60 Server documentation.

It is not possible to access the HTTP version in the `Request`, providing useful
information about available features.

I fixed the `--threading` option and [submitted a patch to waf development](https://github.com/waf-project/waf/pull/1577)
that got merged in their trunk.

FastCGI implementation honors the URI scheme if it sets the `HTTPS` environment
variable. This way, it is possible to determine if the request was secured with
SSL.

I enforced a synchronous processing model for the `0.1.*` branch since it's not
ready yet.

It is now possible to _keep routing_ if we decide that a handler does not
complete the user request processing. The `next` continuation is crafted to
continue routing from any point in the route queue. It will also propagate
`Redirection`, `ClientError` and `ServerError` up the stack.

{% highlight vala %}
app.get ("", (req, res, next) => {
    next ();
});

app.get ("", (req, res) => {
    res.write ("Hello world!".data);
});
{% endhighlight %}

It is now possible to connect a handler to multiple HTTP methods at once using
`all` and `methods` functions in the router.

The `Route` is safer and keep a strong reference to the handler callback. This
avoid a potentially undesired deallocation.

Changes for the next release
----------------------------

The next release `0.2.0-alpha` will focus on the asynchronous processing model
and VSGI specification.

In short,

 1. the server receives a user request
 2. the request is transmitted to the application with a continuation that
    release the request resources
 3. the application handles the pair of request and response:
     - it may invoke asynchronous processings
     - it returns as fast as possible the control to the server and avoid any
       synchronous blocking on I/O
     - it must invoke the `end` continuation when all processing have completed
       so that the server can release the resources
 4. the server is ready to receive a new request

The handler is purely synchronous, this is why it is not recommended to perform
blocking operations in it.

{% highlight vala %}
app.get ("", (req, res, end) => {
    res.write ("Hello world!".data);
    res.close ();
    end ();
});
{% endhighlight %}

This code should be rewritten with `write_async` and `close_async` to return
the control to the server as soon as possible.

{% highlight vala %}
app.get ("", (req, res, end) => {
    res.write_async ("Hello world".data, Priority.DEFAULT, null,
                 () => {
        res.close_async (Priority.DEFAULT, null, () => {
            end ();
        })
    });
});
{% endhighlight %}

Processing asynchronously has a cost, because it delegates the work in an event
loop that awaits events from I/O.

The synchronous version will execute faster, but it will not scale well with
multiple requests and significant blocking. The asynchronous model will
outperform this easily due to a pipeline effect.

VSGI improvments
----------------

Request and Response now have a `base_stream` and expose a `body` that may
filter what's being written in the `base_stream`. The libsoup-2.4
implementation uses that capability to perform chunked transfer encoding.

There is no more inheritence from `InputStream` or `OutputStream`, but this can
be reimplemented using `FilterInputStream` and `FilterOutputStream`.

I have implemented a `ChunkedConverter` to convert data into chunks of data
according to RFC2126 section 3.6.1.

It can also be used to do transparent gzip compression using the
`ZlibCompressor`.

{% highlight vala %}

{% endhighlight %}

Soup reimplementation
---------------------

The initial implementation was pretty much a prototype wrapping a MessageBody
with an OutputStream interface. It is however possible to steal the connection
and obtain an IOStream that can be exposed.

MessageBody would usually worry about transfer encoding, but since we are
working with the raw streams, some work will have to be done in order to
provide that encoding capability.

In HTTP, transfer encoding determines how the message body will be
transmitted to its recipient. It provides information to the client about
what amount of data will be transfeered.

Two possible transfeer encoding exist:

 - use the `Content-Length` header, the recipient expects to receive that number of bytes
 - use `chunked` in `Transfer-Encoding` header, the recipient expects to receive a chunk size followed by the content of the chunk

TCP guarantees the order of packets and thus, the order of the received chunks.

I implemented an `OutputStream` capable of encoding written data according to
the header of the response. It can be composed with other streams from the GIO
api, which is more flexible than a `MessageBody`.

The response exposes two streams:

 - output_stream, the raw and protected stream
 - body, the public and safe for transporting the message body

Some implementations (CGI, FastCGI, etc...) delegate the transfer encoding
responsbiility to the HTTP server.

Status handling
---------------

The `setup` and `teardown` approach have been deprecated in favour of `next`
continuation and status handling.

Handler can be connected to status thrown during the processing of a request.

If a status handler throws a status, it will be captured by the `Router`. This
can be used to cancel the effect of a redirection for instance.

Likewise, status handling can invoke `end` to end the request processing and
`next` to delegate the work to the next status handler in the queue.

{% highlight vala %}
app.status (404, (req, res, end) => {
    end ();
});

app.status (302, (req, res, next) => {
:
});
{% endhighlight %}

Roadmap (long-term stuff)
-------------------------

More to come, but I have already a few ideas

 - handling of `multipart/*` messages [issue #81](https://github.com/valum-framework/valum/issues/81)
 - polling for FastCGI [issue #77](https://github.com/valum-framework/valum/issues/77)
 - implementation for SCGI [issue #60](https://github.com/valum-framework/valum/issues/60)
 - middlewares [issue #51](https://github.com/valum-framework/valum/issues/51)
 - reverse rule-based routes [issue #45](https://github.com/valum-framework/valum/issues/45<F37>)
 - get CTPL Vala bindings right with GI (GObject Introspection)
 - more converters for more common web encoding (base64, urlencoded, etc...)

FastCGI streams can benefit from polling and reimplementing them is planned.
APIs would remain the same as all would happen under the hood.

Reversing rules and possibly regular expression would make URLs in web
application much easier to maintain.

CTPL has a hand-written binding and it would be great to just generate them
with GI.
