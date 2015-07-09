---
layout: post
title: Writting bindings for libmemcached
tags: Memcached
---

In the past day, I have been working on writting bindings for
libmemcached so that I can use it on my project assignment.

I bound the `error.h`, `server.h`, `server_list.h`, `storage.h`, `touch.h` and
`quit.h` headers.

It is now possible, from Vala, to do the following operations:

 - querying the server about the last error
 - add a server from tcp, udp, UNIX socket with an optional weight
 - parsing servers list
 - store values with operations like set, add, replace, append and
   prepend
 - touch entries to update their expiration timestamp
 - quit the memcached server connection
 - interacting with an instance

I plan to write the complete binding to dig a little more the language. The
hardest part still remain, but it should be done neatly.

 - the asynchronous result API with `mget` and `fetch_result`
 - various callbacks
 - SASL and other external dependencies
