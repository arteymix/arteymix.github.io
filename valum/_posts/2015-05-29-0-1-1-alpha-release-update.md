---
layout: post
title: 0.1.1-alpha released!
---

Valum `0.1.1-alpha` has been released, the changeset is described in the
[fifth week update]({% post_url 2015-05-29-fifth-week-update %}) I published
yesterday.

You can read the [release notes](https://github.com/valum-framework/valum/releases/tag/v0.1.1-alpha)
on GitHub to get a better idea of the changeset.

I am really proud of announcing that release as it bring two really nice
features:

 - `next` continuation in the routing process
 - `all` and `methods`

These two features completely replace the need for a `setup` signal. It's only
a matter of time before `teardown` disappear with the `end` continuation and
status handling that the `0.2.0-alpha` release will bring.

I expect the framework to start stabilizing on the `0.2.*` branch when the
asynchronous processing model will be well defined and VSGI more solid.

Okay, I'm back to work now ;)
