---
layout: post
---

I couldn't touch the framework much these last days due to my busy schedule, so
I just wanted to write a few words.

I like the approach used by [Express.js](http://expressjs.com/) to branch in
the routing by providing a forward callback and call it if some conditions are
met.

It is used for content negociation and works quite nicely.

```vala
app.get ("", accept ("text/html", (req, res, next) => {
    // user agent understands 'text/html'

    // well, finally, it's not available
    next (req, res);
}));

app.get ("", (req, res) => {
    // user agent wants something else
});
```

Other negociator are provided for the charset, encoding and much more. All the
wildcards defined in the HTTP/1.1 specification are understood.

The code for static resource delivery is almost ready. I am finishing some
tests and it should be merged.

It supports the production of the following headers (with flags):

 - `ETag`
 - `Last-Modified`
 - `Cache-Control: public`

And can deliver resources from a [GResource bundle][GResource] or a [GFile
path][GFile] path. This also means that any [GVFS backends][GVFS backends] are
supported.

If the resource is not found, `next` is invoked to dispatch the request to the
next handler.

[GResource]: https://developer.gnome.org/gio/2.46/GFile.html
[GFile]: https://developer.gnome.org/gio/2.46/GFile.html
[GVFS backends]: https://wiki.gnome.org/Projects/gvfs/backends

One last thing is [GSequence][GSequence], which store a sorted sequence in
a binary tree. I think that if we can sort `Route` objects in some way, this
could provide a really effective routing in logarithmic time.

Or using a Trie

[GSequence]: https://developer.gnome.org/glib/2.46/GSequence.html
