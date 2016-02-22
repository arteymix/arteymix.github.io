---
layout: post
---

My <kbd>up</kbd> key stopped working, so I'm kind of forced into vim motions.

All warnings have been fixed and I'm looking forward enforcing
``--experimental-non-null`` as well.

The response head is automatically written on disposal and the body is not
closed explicitly when a status is thrown.

In the mean time, I managed to backport write-on-disposal into the
[0.2.12](https://github.com/valum-framework/valum/releases/tag/v0.2.12) hotfix.

I have written a formal grammar and working on an implementation that will be
used to reverse rules.

## VSGI Redesign

There's some work on a slight redesign of VSGI where we would allow the
`ApplicationCallback` to return a value. It would simplify the call of a `next`
continuation:

```csharp
app.get ("", (req, res, next) => {
    if (some_condition)
        return next (req, res);
    return res.body.write_all ("Hello world!".data, null);
});
```

In short, a boolean returned tells if the request is or will eventually be
handled.

The only thing left is to decide what the server will do about _not_ handled
requests.

### Update (Feb 21, 2016)

This work has been merged and it's really great because it provides major
improvements:

 - no more 404 at the bottom of `perform_routing`, we use the return value to
   determine if any route has matched
 - `OPTIONS` work even if no route has matched: a `404 Not Found` would be
   thrown with the previous approach

Yeah, we are even handling `OPTIONS`! It produce a 0-length body with the
`Allow` header assigned with a list of available methods for the resource.

## Expand!

The `Response` class now has a `expand` and `expand_utf8` methods that work
similarly to `flatten` for `Request`.

```csharp
app.get ("", (req, res) => {
    return res.expand_utf8 ("Hello world!");
});
```

It will deal with writting the head, piping the passed buffer and close the
response stream properly.

The asynchronous versions are provided if `gio (>=2.44)` is available during
the build.

## SCGI improvements

Everything is not buffered in a single step and resized on need if the request
body happen not to hold in the default 4kiB buffer.

I noticed that `set_buffer_size` literally allocate and copy over data, so we
avoid that!

I have also worked on some defensive programming to cover more cases of failure
with the SCGI protocol:

 - encoded lengths are parsed with [int64.try_parse](), which prevented `SEGFAULT`
 - a missing `CONTENT_LENGTH` environment variable is properly handled

I noticed that `SocketListener` also listen on IPv6 if available, so the SCGI
implementation has a touch of modernity! This is not available (yet) for
FastCGI.

Right now, I'm working on supporting UNIX domain socket for SCGI and
libsoup-2.4 implementations.

It's rolling at 6k req/sec behind Lighttpd on my _shitty_ Acer C720, so enjoy!

I have also fixed errors with the FastCGI implementation: it was a kind of
[major issue in the Vala language][bug #762377]. In fact, it's not possible to
return a code and throw an exception simultaneously, which led to an
inconsistent return value in `OutputStream.write`.

[bug #762377]: https://bugzilla.gnome.org/show_bug.cgi?id=762377

To temporairly fix that, I had to supress the error and return `-1`. I'll have
to hack this out eventually.

In short, I managed to make VSGI more reliable under heavy load, which is
a very good thing.

