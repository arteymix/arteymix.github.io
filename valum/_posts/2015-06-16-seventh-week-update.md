---
layout: post
title: Seventh week update 1/06/15 to 12/06/15
---

Since the `0.1.0-alpha` release, I have been releasing a bugfix release every
week and the APIs are continuously stabilizing.

I have released `0.1.2-alpha` with a couple of bugfixes, status code handlers
and support for `null` as a rule.

I have also released a [0.1.3-alpha](https://github.com/valum-framework/valum/releases/tag/v0.1.3-alpha)
that brought bugfixes and the possibility to pass a state in `next`.

Along with the work on the current releases, I have been working on finishing
the asynchronous processing model and developed prototypes for both CGI and
SCGI protocols.


### Passing a state!

It is now possible to transmit a state when invoking the `next` continuation so
that the next handler can take it into consideration for producing its
response.

The `HandlerCallback` and `NextCallback` were modified in a backward-compatible
way so that they would propagate the state represented by a `Value?`.

The main advantage of using `Value?` is that it can transparently hold any type
from the GObject type system and primitives.

This feature becomes handy for various use cases:

 - pass a filtered stream over the response body for the next handler
 - compute and transmit in separate handlers
    - the computation handler is defined once and pass the result in `next`
    - different handlers for transmitting different formats (JSON, XML, HTML, plain text, ...)
 - fetch data common to a set of routes
 - build a component like a session or a model from the request and pass it to
   the next route

This example shows how a state can be passed to conveniently split the
processing in multiple middlewares and obtain a more modular application.

```csharp
app.scope ("user/<int:id>", (user) => {
    // fetch the user in a generic manner
    app.all (null, (req, res, next) => {
        var user = new User.from_id (req.params["id"]);

        if (user.loaded())
            throw new ClientError.NOT_FOUND ("User with id %s does not exist.".printf (req.params["id"]));

        next (user);
    });

    // GET /user/{id}/
    app.get ("", (req, res, next, state) => {
        User user = state;
        next (user.username);
    });

    // render an arbitrary JSON object
    app.all (null, (req, res, next, state) => {
        var generator = new Json.Generator ();

        // generate compacted JSON
        generator.pretty = false;

        generator.set_root (state);

        generator.to_stream (res.body);
    });
})
```

It can also be used to build a component like a `Session` from the request
cookies and pass it.

```csharp
app.all (null, (req, res, next) => {
    for (var cookie in  req.cookies)
        if (cookie.name == "session")
            { next (new Session.from_id (cookie.value)); return; }
    var session = new Session ();
    // create a session cookie
    res.cookies.append (new Cookie ("session", session.id));
});
```

This feature will integrate very nicely with content negociation middlewares
that will be incorporated in a near future. It will help solving typical case
where a handler produce a data and other handlers worry about its transmission
in a desired format.

```csharp
app.get ("some_data", (req, res, next) => {
    next ("I am a state!");
});

app.matcher (accept ("application/json"), (req, res, next, state) => {
    // produce a json response
    res.write ("{\"message\": \"%s\"}".printf (state.get_string ()));
});

app.matcher (accept ("application/xml"), (req, res, next, state) => {
    // produce a xml response
    res.write ("<message>%s</message>".printf (state.get_string ()))
});
```

This new feature made it into the `0.1.3-alpha` release.


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

Some design changes have pushed the development a bit forward as I think that
the request teardown can be better implemented with reference counting.

Two major changes improved the processing:

 - the state of a request is not wrapped in a connection, which is typically
   implemented by an `IOStream`
 - the request and response hold the connection, so whenever both are out of
   scope, the connection is freed and the resources are released

Not all implementation provide an `IOStream`, but it can easily be implemented
and used to free any resources in its destructor.

I hope this can make it in the trunk by friday, just in time for the lab
meeting.


### New implementation prototypes

I have been working on CGI and SCGI prototypes as these are two very important
protocols for the future of VSGI.

CGI implements the basic [CGI specification](https://www.ietf.org/rfc/rfc3875)
which is reused in protocols like FastCGI and SCGI. The great thing is that
they can use inheritence to reuse behiaviours from CGI like the environment
extraction to avoid code duplication.

