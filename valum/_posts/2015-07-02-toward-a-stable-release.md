---
layout: post
title: Toward a first release
---

I'm working on the beta release that should bring minor improvements and more
definitive APIs.

 - JSON example and documentation with [json-glib](https://wiki.gnome.org/Projects/JsonGlib)
 - final renaming to ensure a quality and elegant API
 - CGI and SCGI implementations

The next step is a stable `0.2.0` release which should happen in the coming
weeks.

 - RPM packaging and distribution ([see Valum on COPR](https://copr.fedoraproject.org/coprs/arteymix/valum/))
 - Docker container example using the RPM package


Invocation in the Router context
--------------------------------

This feature was missing from the last release and solves the issue of calling
`next` when performing asynchronous operations.

When an async function is called, the callback that will process its result
does not execute in the routing context and, consequently, does not benefit
from any form of status handling.

```csharp
app.get ("", (req, res, next) => {
    res.body.write_async ("Hello world!".data, () => {
        next (); // if next throws anything, it's lost
    });
});
```

What `invoke` brings is the possibility to invoke a `NextCallback` in the
context of any `Router`, typically the current one.

```csharp
app.get ("", (req, res, next) => {
    res.body.write_async ("Hello world!".data, () => {
        app.invoke (req, res, next);
    });
});
```

It respects the `HandlerCallback` delegate and can thus be used as a handling
middleware with the interesting property of providing an execution context for
any pair of `Request` and `Response`.

The following example will redirect the client as if the redirection was thrown
from the API router, which might possibly handle redirection in a particular
manner.

```csharp
app.get ("api", (req, res) => {
    // redirect old api calls
    api.invoke (req, res, () => { throw new Redirection ("http://api.example.com"); })
});
```

As we can see, it offers the possibility of executing any `NextCallback` in any
routing context that we might need and reuse behiaviours instead of
reimplementing them.

RPM packaging
-------------

I wrote a specfile for RPM packaging so that we can distribute the framework on
RPM-based distributions like Fedora and openSUSE. The idea is to eventually
offer the possibility to install Valum in a [Docker](https://www.docker.com/)
container to facilitate the deployment of web services and applications.

I have literally no knowledge about Debian packaging, so if you would like to
give me some help on that, I would appreciate.

