---
layout: post
title: Twelvth week update (from 29/06/15 to 17/07/15)
---

I have been very busy in the last weeks so this update will cover the work of
three weeks instead of a typical bi-weekly update.

There's no release announcement as I have been working on the assignment I have
to realize with the framework and steadily worked toward the `0.2.0-beta`
release.

Alongside, I have been working on feature for the `0.3` serie which will
introduce middlewares. I have prototyped the following:

 - HTTP authentication (basic and digest)
 - content negociation
 - static resources

I have also introduced `then` in `Route`, which is a really handy feature to
create handling sequences and implemented the trailer from the chunked
encoding.

Update from Colomban!
---------------------

I had an unexpected update from the developer of CTPL, Colomban Wendling. We
have talked a few weeks ago about the possibilities of having GObject
Introspection into the library so that we could generate decent bindings for
Vala.

He's got something working and I will try to keep a good eye on the work so
that we can eventually ship a better binding for the templating engine.

CTPL is a good short-term solution for templating and if the library evolves
and integrates new features, it could possibly be a replacement for a possible
Mustache implementation.

The two big issues with CTPL is the lack of basic features:

 - filters
 - mapping
 - array of array

Filters let one attach a function to the environment so that it can be applied
on the variables instead of pre-processing the data.

Mappings could be easily implemented if Ctpl.Environ would be allowed to
contain themselves.

Containers are limited to hold scalars of the same type, which is quite
restrictive and prevents many usages.

Working prototype
-----------------

I have a working prototype for the assignment that I will briefly describe
here.

In order to expose the algorithm developed by Nicolas Scott for his Ph. D
thesis, I decided to describe a RESTful API with the following endpoints:

    PUT /task
    GET /task/{uuid}
    DELETE /task/{uuid}
    GET /task/{uuid}/results
    GET /tasks
    GET /statistics

The task is still a very generic concept as I do not know much about what kind
of data will be poured into the program.

 1. client submits a task with its data
 2. the task is created (stored in memcached) and then queued in a [ThreadPool](http://valadoc.org/#!api=glib-2.0/GLib.ThreadPool)
     - the pool eventually process the task in a worker thread
 3. client requests the results of the task and either one of the following
    scenario occurs:
     - the task is queued or processing and a 4xx is thrown
     - the task is completed and the result is transmitted

I have finished [bindings for libmemcachedutil](), which provides a connection
pool which has roughly doubled the throughput.

There's still a few things to do:

 - `GLib.MainLoop` integration for libmemcached bindings to let the loop
   schedule request processing and memcached operations
 - client based on [Semantic UI](http://semantic-ui.com/) (in progress...)

Semantic UI has nice API mapping capabilities that will be very useful to
present the data interactively.

The project will be containerized and shipped probably on Google Compute
Engine as it supports Docker.

Then...
-------

This feature is really handy as it is common to reuse the matching process for
a sequence of handling callbacks. I will be introduced in the `0.3` branch as
it will work nicely along middlewares.

```vala
app.get ("", (req, res, next) => {
    // step 1
}).then ((req, res, next) => {
    // step 2
}).then ((req, res) => {
    // step 3
});
```

