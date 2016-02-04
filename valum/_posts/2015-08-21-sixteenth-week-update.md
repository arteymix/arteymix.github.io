---
layout: post
---

This last weekly update marks the final release of `valum-0.2` and a couple of
things happened since the last beta release:

 - code and documentation improvements
 - handle all status codes properly by using the message as a payload
 - favour `read_all` over `read` and  `write_all` over `write` for stream
   operations
 - `all` and `methods` now return the array of created `Route` objects
 - move cookies-related utilities back to VSGI
 - `sign` and `verify` for cryptographically secure cookies
 - filters and converters for `Request` and `Response`

I decided to move the cookies-related utilities back into VSGI, considering
that VSGI provide a layer over libsoup-2.4 and cookies utilities are simply
adapting to the `Request` and `Response` objects.

I introduced `sign` and `verify` to perform cookie signature and verification
using HMAC.

```csharp
using Soup;
using VSGI;

var cookie = new Cookie ("name", "value", ...);

cookie.@value = Cookies.sign (cookie, ChecksumType.SHA512, secret);

string @value;
if (Cookies.verify (cookie.@value, ChecksumType.SHA512, secret, out @value)) {
    // cookie is authentic and value is stored in @value
}
```

The signing process uses a HMAC signature over the name and value of the cookie
to guarantee that we have produced the value and associated it with the name.

The signature is computed as follow:

    HMAC (algorithm, secret, HMAC (algorithm, secret, value) + name) + value

Where

 - the algorithm is chosen from the [GChecksumType](https://developer.gnome.org/glib/unstable/glib-Data-Checksums.html#GChecksumType)
   enumeration
 - the secret is chosen
 - the name and value are from the cookie

The documentation has been updated with the latest changes and some parts were
rewritten for better readability.

Filters and converters
----------------------

Filters and converters are basis to create filters for `Request` and `Response`
objects. They allow a handling middleware to apply composition on these objects
to change their typical behaviour.

Within Valum, it is integrated by passing the `Request` and `Response` object
to the `NextCallback`.

```csharp
app.get ("", (req, res, next) => {
    next (req, new BufferedResponse (res));
}).then ((req, res) => {
    // all operations on res are buffered, data are sent when the
    // stream gets flushed
    res.write_all ("Hello world!".data, null);
});
```

These are just a beginning and the future releases will introduce a wide range
of filters to create flexible pipelines.

Work on Mirdesign testcases
---------------------------

I have been actively working on Mirdesign testcases and finished its API
specification.

 - final API specification
 - poll for status update
 - grammar productions and tokens implementation in JavaScript to generate code
   from an AST

The work on grammar productions and tokens in JavaScript will eventually lead
to a compliant implementation of Mirdesign which will be useful if we decide to
go further with the project. The possible outcome would be to provide all the
capabilities of the language in an accessible manner to people in the field.

To easily integrate dependencies, Browserify is used to bundle relevant
[npm](https://www.npmjs.com/) packages.

 - store.js to store data in localStorage with multiple fallbacks
 - codemirror to let user submit its own design
 - lex to lex a Mirdesign input
 - numeral to generate well formatted number according to Mirdesign EBNF
 - fasta-parser to parse a fasta input

I updated the build system to include the JS compilation with [Google Closure Compiler](https://developers.google.com/closure/compiler/)
and generation of API documentation with [Swagger](http://swagger.io/) in the
parallel build. I first thought using another build system specialized in
compiling front-end applications, but `waf` is alread well adapted for our
needs.

```python
bld(
    rule   = 'browserify ${SRC} | closure-compiler --js_output_file ${TGT} -',
    target = 'mirdesign.min.js',
    source = 'mirdesign.js')
```

Google Closure Compiler performs static type checking, minification and
generation of highly optimized code. It was essential to ensure type safety for
the use of productions and tokens.

[JSDocs](http://usejsdoc.org/) is used to produce the documentation for the
productions, tokens as well as the code backing the user interface.

I decoupled the processing function from the `ThreadPool` as we will eventually
target a cluster using [TORQUE](http://www.adaptivecomputing.com/products/open-source/torque/)
to perform computation.

Long-term features:

 - API key to control resource usage
 - monitor CPU usage per user
 - theme for the user interface

