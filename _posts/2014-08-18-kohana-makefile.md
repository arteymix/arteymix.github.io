---
layout: post
title: Kohana Makefile
description: A Makefile I have just released on GitHub for the Kohana Framework
keywords: SELinux Makefile make Kohana
tags: Kohana
external-url: https://gist.github.com/arteymix/4a162dd185ac0e4f781e
---

I have just released [my sample Kohana Makefile](https://gist.github.com/arteymix/4a162dd185ac0e4f781e).
It has useful recipes for minification, testing, setting permissions and
[SELinux](http://wikipedia.com/wiki/SELinux) contexts.

Clone it
{% highlight bash %}
git clone https://gist.github.com/4a162dd185ac0e4f781e.git
{% endhighlight %}

Or wget it
{% highlight bash %}
wget https://gist.githubusercontent.com/arteymix/4a162dd185ac0e4f781e/raw/5f744b0e157a03e330e2512af852005c8c51d594/Makefile
{% endhighlight %}

It has a recipe for installing Kohana files like `index.php` and `application/bootstrap.php`
{% highlight bash %}
make install
{% endhighlight %}

It runs PHPUnit
{% highlight bash %}
make test
{% endhighlight %}

Or minify your resources
{% highlight bash %}
make minify
{% endhighlight %}

It is fully configurable, so if you use a different css minifier, you may edit
the file like you need it.

My goal is to provide every Kohana developer with a good Makefile to automate
frequent tasks when using the framework. I will eventually propose it in the
[sample Kohana application](https://github.com/kohana/kohana).
