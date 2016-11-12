---
layout: post
title: Announcing Valum 0.3
tags: Vala
---

The first release candidate for Valum 0.3 has been launched today!

[Get][1] it, test it and be the first to find a bug! The final release will
come shortly after along with various Linux distributions packages.

This post review the changes and features that have been introduced since the
`0.2`. There's been a lot of work, so take a comfortable seat and brew yourself
a strong coffee.

The most significant change has probably been the introduction of Meson as
a build system and all the new deployment strategy it now makes possible.

If you prefer avoiding a full install, it's not possible to use it as
a subproject. These are defined as subdirectories of `subprojects`, which you
can conveniently track using [git submodules][2].

```python
project('', 'c', 'vala')

glib = dependency('glib-2.0')
gobject = dependency('gobject-2.0')
gio = dependency('gio-2.0')
soup = dependency('libsoup-2.4')
vsgi = subproject('valum').get_variable('vsgi')
valum = subproject('valum').get_variable('valum')

executable('app', 'app.vala',
           dependencies: [glib, gobject, gio, soup, vsgi, valum])
```

Once installed, however, all that is needed is to pass `--pkg=valum-0.3` to the
Vala compiler.

```bash
vala --pkg=valum-0.3 app.vala
```

In `app.vala`,

```csharp
using Valum;
using VSGI;

public int main (string[] args) {
    var app = new Router ();

    app.get ("/", (req, res) => {
        return res.expand_utf8 ("Hello world!");
    });

    return Server.@new ("http", handler: app)
                 .run (args);
}
```

There's been a lot of new features and I hope I won't miss any!

There's a new `url_for` utility in `Router` that comes with named route. It
basically allow one to reverse URLs patterns defined with rules and raw paths.

All that is needed is to pass a name to `rule`, `path` or any method helper.

I discovered the `:` notation for named varidic arguments if they alternate
between strings and values. This is typically used to initialize `GLib.Object`.

```csharp
using Valum;
using VSGI;

var app = new Router ();

app.get ("/", (req, res) => {
    return "<a href=\"%s\">View profile of %s</a>".printf (
        app.url_for ("user", id: "5"), "John Doe");
});

app.get ("/users/<int:id>", (req, res, next, ctx) => {
    var id = ctx["id"].get_string ();
    return res.expand_utf8 ("Hello %s!".printf (id));
}, "user");
```

In `Router`, we also have:

 - `asterisk` to handle `*` URI
 - `once` for performing initialization
 - `path` for a path-based route
 - `rule` to replace `method`
 - `register_type` rather than a `GLib.HashTable<string, Regex>`

Another significant change is that the previous state stack has been replaced
by a context tree with recursive key resolution. It pretty much maps `string`
to `GLib.Value` in a non-destructive way.

In terms of new middlewares, you'll be glad to see all the built-in
functionnalities we now support:

 - authentication with support for the `Basic` scheme via `authenticate`
 - content negotiation via `negotiate`, `accept` and more!
 - static resource delivery from `GLib.File` and `GLib.Resource` bundles
 - `basic` to strip the `Router` responsibilities
 - `subdomain`
 - `basepath` to prefix URLs
 - `cache_control` to set the `Cache-Control` header
 - branch on raised `status` codes
 - perform work `safely` and don't let any error leak!
 - stream events with `stream_events`

Now, which one to cover?

The `basepath` is my personal favourite, because it allow one to create
prefix-agnostic routers.

```csharp
var app = new Router ();
var api = new Router ();

// matches '/api/v1/'
api.get ("/", (req, res) => {
    return res.expand_utf8 ("Hello world!");
});

app.use (basepath ("/api/v1", api.handle));
```

The only missing feature is to retranslate URLs directly from the body. I think
we could use some `GLib.Converter` here.

The `negotiate` middleware and it's derivatives are really handy for declaring
the available representations of a resource.

```csharp
app.get ("/", accept ("text/html; text/plain", (req, res, next, ctx, ct) => {
    switch (ct) {
        case "text/html":
            return res.expand_utf8 ("");
        case "text/plain":
            return "Hello world!";
        default:
            assert_not_reached ();
    }
}))
```

There's a lot of stuff happening in each of them so refer to the docs!

Quick review into `Request` and `Response`, we now have the following helpers:

 - `lookup_query` to fetch a query item and deal with its `null` case
 - `lookup_cookie` and `lookup_signed_cookie` to fetch a cookie
 - `cookies` to get cookies from a request and response
 - `convert` to apply a `GLib.Converter`
 - `append` to append a chunk into the response body
 - `expand` to write a buffer into the response body
 - `expand_stream` to pipe a stream
 - `expand_file` to pipe a file
 - `end` to end a response properly
 - `tee` to tee the response body into an additional stream

All the utilities to write the body come in `_bytes` and `_utf8` variants. The
latter properly set the content charset when appliable.

Back into `Server`, implementation have been modularized with `GLib.Module` and
are now dynamically loaded. What used to be a `VSGI.<server>` namespace now has
become simply `Server.new ("<name>")`. Implementations are installed in
`${prefix}/${libdir}/vsgi-0.3/servers`, which can be overwritten by the
`VSGI_SERVER_PATH` environment variable.

The VSGI specification is not yet `1.0`, so please, don't write a custom server
for now or if you do so, please submit it for inclusion. There's some
work-in-progress for [Lwan][3] and [AJP][4] as I speak if you have some time to spend.

Options have been moved into `GLib.Object` properties and a new `listen` API
based on `GLib.SocketAddress` makes it more convenient than ever.

```csharp
using VSGI;

var tls_cert = new TlsCertificate.from_files ("localhost.cert",
                                              "localhost.key");
var http_server = Server.new ("http", https: true,
                                      tls_certificate: tls_cert);

http_server.set_application_callback ((req, res) => {
    return res.expand_utf8 ("Hello world!");
});

http_server.listen (new InetSocketAddress (new InetAddress.loopback (SocketFamily.IPV4), 3003));

new MainLoop ().run ();
```

The `GLib.Application` code has been extracted into the new `VSGI.Application`
cushion used when calling `run`. It parses the CLI, set the logger and handle
`SIGTERM` into a graceful shutdown.

Server can also `fork` to scale on multicore architectures. I've backtracked on
the `Worker` class to deal with IPC communication, but if anyone is interested
into building a nice clustering system, I would be glad to look into it.

That wraps it up, the rest can be discovered in the [updated docs][5]. The API
docs should be available shortly via [valadoc.org][6].

I manage to cover this exhaustively with [abidiff][7], a really nice tool to
diff two ELF files.

## Long-term notes

Here's some long-term notes for things I couldn't put into this release or that
I plan at a much longer term.

 - multipart streams
 - digest authentication
 - async delegates
 - epoll and kqueue with [wip/pollcore][8]
 - schedule future release with the GNOME project
 - GIR introspection and typelibs for [PyGObject][9] and [Gjs][10]

The GIR and typelibs stuff might not be suitable for Valum, but VSGI could have
a bright future with Python or JavaScript bindings.

Coming releases will be much less time-consuming as there's been a big step to
make to have something actually usable. Maybe every 6 months or so.

[1]: https://github.com/valum-framework/valum/releases/tag/v0.3.0-rc
[2]: https://git-scm.com/docs/git-submodule
[3]: https://lwan.ws/
[4]: http://tomcat.apache.org/tomcat-3.3-doc/AJPv13.html
[5]: http://docs.valum-framework.org/en/latest/
[6]: http://valadoc.org/valum-0.3/index.htm
[7]: https://sourceware.org/libabigail/manual/abidiff.html
[8]: https://mail.gnome.org/archives/commits-list/2014-February/msg06024.html
[9]: https://wiki.gnome.org/Projects/PyGObject
[10]: https://wiki.gnome.org/Projects/Gjs
