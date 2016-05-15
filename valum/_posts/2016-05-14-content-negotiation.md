---
layout: post
---

I recently finished and merged [support for content negotiation][1].

[1]: https://github.com/valum-framework/valum/pull/150

The implementation is really simple: one provide a header, a string describing
expecations and a callback invoked with the negotiated representation. If no
expectation is met, a `406 Not Acceptable` is raised.

```csharp
app.get ("/", negotiate ("Accept", "text/xml; application/json",
                         (req, res, next, ctx, content_type) => {
    // produce according to 'content_type'
}));
```

Content negotiation is a nice feature of the HTTP protocol allowing a client
and a server to negotiate the representation (eg. content type, language,
encoding) of a resource.

One very nice part allows the user agent to state a preference and the server
to express quality for a given representation. This is done by specifying the
`q` parameter and the negotiation process attempt to maximize the product of
both values.

The following example express that the XML version is poor quality, which is
typically the case when it's not the source document. JSON would be favoured --
implicitly `q=1` -- if the client does not state any particular preference.

```csharp
accept ("text/xml; q=0.1, application/json", () => {

});
```

Mounted as a top-level middleware, it provide a nice way of setting
a ``Content-Type: text/html; charset=UTF-8`` header and filter out
non-compliant clients.

```csharp
using Tmpl;
using Valum;

var app = new Router ();

app.use (accept ("text/html", () => {
    return next ();
}));

app.use (accept_charset ("UTF-8", () => {
    return next ();
}));

var home = new Template.from_path ("templates/home.html");

app.get ("/", (req, res) => {
    home.expand (res.body, null);
});
```

This is another step forward a `0.3` release!

