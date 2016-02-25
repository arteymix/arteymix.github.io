---
layout: post
title: Just reached 6.3k req/sec
---

I often profile Valum's performance with [wrk](https://github.com/wg/wrk) to
ensure that no regression hit the stable release.

It helped me identifying a couple of mistakes n various implementations.

Anyway, I'm glad to announce that I have reached 6.3k req/sec on small payload,
all relative to my very lowgrade Acer C720.

The improvements are available in the [0.2.14 release][v0.2.14].

[v0.2.14]: https://github.com/valum-framework/valum/releases/tag/v0.2.14

 - `wrk` with 2 threads and 256 connections running for one minute
 - Lighttpd spawning 4 SCGI instances

Build Valum with examples and run the SCGI sample:

```bash
./waf configure build --enable-examples
lighttpd -D -f examples/scgi/lighttpd.conf
```

Start `wrk`...

```bash
wrk -c 256 http://127.0.0.1:3003/
```

Enjoy!

```
Running 1m test @ http://127.0.0.1:3003/
  2 threads and 256 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    40.26ms   11.38ms 152.48ms   71.01%
    Req/Sec     3.20k   366.11     4.47k    73.67%
  381906 requests in 1.00m, 54.31MB read
Requests/sec:   6360.45
Transfer/sec:      0.90MB
```

There's still a few things to get done:

 - hanging connections benchmark
 - throughput benchmark
 - logarithmic routing [#144](https://github.com/valum-framework/valum/issues/144)

The trunk buffers SCGI requests asynchronously, which should improve the
concurrency with blocking clients.

Lighttpd is not really suited for throughput because it buffers the whole
response. Sending a lot of data is problematic and use up a lot of memory.

Valum is designed with streaming in mind, so it has a very low (if not
neglectable) memory trace.

I reached 6.5k req/sec, but since I could not reliably reproduce it, I prefered
posting these results.

