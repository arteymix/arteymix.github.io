---
layout: post
tags: Mirdesign Valum
---

The `0.2.0-beta` has been released with multiple improvements and features that
were described in the preceeding update. It can be
[downloaded from GitHub](https://github.com/valum-framework/valum/releases/tag/v0.2.0-beta)
as usual or installed from the Docker image.

The documentaion has been nicely improved with more contextual notes to put
emphasis on important points.

The framework has reached a really good level of stability and I should
promptly release a stable version in the coming week.

There's a couple of features I think that could be worth in the stable release:

 - listen to multiple sources (socket, file descriptor, )
 - listen to an arbitrary socket using a descriptive URL

I have implemented a `lookup` function for cookies which finds a cookie in the
request headers by its name.

```csharp
var cookie = Cookies.lookup ("session", req.headers);
```

Mirdesign
---------

I started working more seriously on the side project as I could meet up with
Nicolas Scott to discuss what kind of web applications will be developed with
Valum.

<figure class="thumbnail">
  <img class="img-responsive" src="/valum/mirdesign-hiv-prototype.png">
  <figcaption class="caption">Mirdesign HIV prototype built with Semantic UI.</figcaption>
</figure>

But first, let me briefly introduce you to his work. He works on µRNA
simulations using a modified version of an algorithm that performs matches
between two sets: µRNA and genes (messaging RNA) from a cell line.

He developed a language that let one efficiently describe and execute
simulations. It does not have a name, but the whole thing is named Mirdesign,
"Mir" standing for µRNA.

The web application will become a showcase for his work by providing specific
testcases his language can actually describe. It consists of two layers:

 - an API written with Valum and backed by a worker pool, memcached, MySQL and
   JSON documented [here](/valum/mirdesign-api-docs.html) with [Swagger](http://swagger.io)
 - a client written with Semantic UI that consumes the API

As of now, we decided to go on with a HIV testcase that would let one select
a cell line, the amount of µRNA to pour and some extra genes that could be
specified or extracted from a FASTA file.

If it works well, other testcases will be implemented to cover yet unexplored
aspects of Mirdesign.

There's still a couple of things to work out:

 - parsing the FASTA file (fasta will be used)
 - generating a Mirdesign word from user input
 - exposing (partially) the MySQL database through the web API
 - change the processing backend (TORQUE or other cluster)
