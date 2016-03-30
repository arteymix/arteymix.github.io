---
layout: post
title: Proposal for asynchronous delegates in Vala
---

This post describe a feature I will attempt to implement this summer.

The declaration of async delegate is simply extending a traditional delegate
with the `async` trait.

```csharp
public async delegate void AsyncDelegate (GLib.OutputStream @out);
```

The syntax of callback is the same. It's not necessary to add anything since
the async trait is infered from the type of the variable holding it.

```csharp
AsyncDelegate d = (@out) => {
    yield @out.write_all_async ("Hello world!".data, null);
}
```

Just like regular callback, asynchronous callbacks are first-class citizen.

```csharp
public async void test_async (AsyncDelegate callback,
                              OutputStream  @out) {
    yield callback (@out);
}
```

It's also possible to pass an asynchronous function which is type-compatible
with the delegate signature:

```csharp
public async void hello_world_async (OutputStream @out)
{
    yield @out.write_all_async ("Hello world!".data);
}

yield test_async (hello_world_async, @out);
```

## Chaining

I still need to figure out how to handle chaining for async lambda. Here's
a few ideas:

 - refer to the callback using `this` (weird..)
 - introduce a `callback` keyword

```csharp
AsyncDelegate d = (@out) => {
    Idle.add (this.callback);
    yield;
};

AsyncDelegate d = (@out) => {
    Idle.add (callback);
    yield;
};
```

## How it would end-up for Valum

Most of the framework could be revamped with the `async` trait in
`ApplicationCallback`, `HandlerCallback` and `NextCallback`.

```csharp
app.@get ("/me", (req, res, next) => {
    if (req.lookup_signed_cookies ("session") == null) {
        return yield next (req, res);
    }
    return yield res.extend_utf8_async ("Hello world!".data);
});
```

The semantic for the return value would simply state if the request has been
handled instead of being *eventually* handled.

