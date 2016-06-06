---
layout: post
title: Merged GModule branch!
---

Valum now support dynamically loadable server implementation with [GModule][1]!

[1]: https://developer.gnome.org/glib/stable/glib-Dynamic-Loading-of-Modules.html

Server are typically looked up in `/usr/lib64/vsgi/servers` with the
`libvsgi-<name>.so` pattern (although this is highly system-dependent).

This works by setting the `RPATH` to `$ORIGIN/vsgi/servers` of the VSGI shared
library so that it looks into that folder first.

The `VSGI_SERVER_PATH` environment variable can be set as well to explicitly
provide a directory containing implementations.

To implement a compliant VSGI server, all you need is a `server_init` symbol
which complies with `ServerInitFunc` delegate like the following:

```csharp
[ModuleInit]
public Type server_init (TypeModule type_module) {
    return typeof (VSGI.Custom.Server);
}

public class VSGI.Custom.Server : VSGI.Server {
    // ...
}
```

It has to return a type that is derived from `VSGI.Server` and instantiable
with `GLib.Object.new`. The Vala compiler will automatically generate the code
to register class and interfaces into the `type_module` parameter.

Some code from CGI has been moved into VSGI to provide uniform handling of its
environment variables. If the protocol you want complies with that, just
subclass (or directly use) `VSGI.CGI.Request` and it will perform all the
required initialization.

```csharp
public class VSGI.Custom.Request : VSGI.CGI.Request {
    public Request (IOStream connection, string[] environment) {
        base (connection, environment);
    }
}
```

For more flexibility, servers can be loaded with `ServerModule` directly,
allowing one to specify an explicit lookup directory and control when the
module should be loaded or unloaded.

```csharp
var cgi_module = new ServerModule (null, "cgi");

if (!cgi_module.load ()) {
    assert_not_reached ();
}

var server = Object.new (cgi_module.server_type);
```

I received very useful support from [Nirbheek Chauhan][2] and [Tim-Philipp
Müller][3] for setting the [necessary build configuration][4] for that feature.

[2]: https://github.com/nirbheek
[3]: https://github.com/tp-m
[4]: https://github.com/mesonbuild/meson/issues/580
