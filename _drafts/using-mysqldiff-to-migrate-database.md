---
title: Using mysqldiff to generate database migration
---

Database migration is a pain for most web developers.

I work with 3 different environment, each requiring its exclusive data source:
production, development and testing. It's quite clear that you don't want your
test data messing with your development data and even less with any production
data.

I have also the same on my remote server as I need to run unit tests (testing) 
on it, do some manual checks (development) and having my app running live
(production).

This lead to a great complexity when it comes to structure synchronization. I
don't like the idea of maintaining delta sql and even less having a automated
database update mechanism built in my application: I would't trust it anyway.
Moreover, the only database I have to worry about is the production one.

I use a tool called `mysqldiff` to generate delta between my local and remote
databases. I automate the process using a Makefile recipe:

{% highlight make %}
DB=production development testing # list all your database here
DBLOCAL=user:password@localhost
DBREMOTE=user:password@remote

# mysqldiff to generate table delta
mysqldiff: $(addprefix $(DBPREFIX), $(DB))

$(DB)%:
    mysqldiff --server1=$(DBLOCAL) \
              --server2=$(DBREMOTE) \
              --difftype=sql \
              --changes-for=server2 \
              $@:$@
{% endhighlight %}

The `--difftype` option allow you to control what kind of output you want. In
this case, we want some `ALTER TABLE` output so we set it to `sql`.

Then you call `make mysqldiff > delta.sql`

*Double check the output!* I often end with duplicate key definitions, but
overall I get a nice diff that I can execute on the remote server.

Obviously, the tool will not deduce renamed columns and other particular
alteration cases: adapt the output in consequence.

You may also combine that tool with an automated migration mechanism by lazily
using it instead of tracking every change you make on your development database.
