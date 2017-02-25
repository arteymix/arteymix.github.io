---
title: Valadoc.org Rewrite and More!
layout: post
---

The rewrite of [valadoc.org](https://valadoc.org/) in Vala using Valum has been
completed and should be deployed eventually be elementary OS team (see [pull
#40][pull40]). There's a couple of interesting stuff there too:

[pull40]: https://github.com/Valadoc/valadoc-org/pull/40

 - experimental search API using JSON via the `/search` endpoint
 - [GLruCache](https://github.com/chergert/glrucache) now has Vala bindings and an improved API
 - an eventual GMysql wrapper around the C client API if extracting the classes
   I wrote is worth it

In the meantime, you can test it at [valadoc2.elementary.io](https://valadoc2.elementary.io/)
and report any regression on the pull-request.

Valum 0.3 has been patched and improved while I have been working on the 0.4
feature set. There's a [work-in-progress WebSocket middleware][wip/websocket],
VSGI 1.0 and support for PyGObject planned.

[wip/websocket]: https://github.com/valum-framework/valum/pull/206

If everything goes as planned, I should finish the AJP backend and maybe
consider Lwan.

On the top, there's Windows support coming, although the most difficult part is
to test it. I might need some help there to setup AppVeyor CI.

I'm aware of the harsh discussions about the state of Vala and whether or not
it will just end into an abysmal void. I would advocate inertia here: the
current state of the language still make it an excelllent candidate for
writing GNOME-related software and this is not expected to change.

