---
layout: post
title: Just discovered.. zsh!
keywords: zsh antigen liquidprompt shell linux
tags: Linux zsh
---

I never thought I would find `zsh` actually that great. I feel like I've been
missing a nice prompt since ages.

I would like to cover my first experience a little and show you how you can turn
your default shell into a powerful development tool. In order to do that, you
have to:

 1. install zsh
 2. get a real plugin manager (antigen here!)
 3. get a really nice and powerful prompt
 4. enjoy all the above!

zsh is quite easy to install using your distribution package manager:

{% highlight bash %}
yum install zsh
{% endhighlight %}

antigen can be cloned from GitHub

{% highlight bash %}
git clone https://github.com/zsh-users/antigen.git .antigen
{% endhighlight %}

Now, edit your first `.zshrc` initialization file!

{% highlight bash %}
source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle nojhan/liquidprompt

antigen apply
{% endhighlight %}

Run `zsh` from your current shell and `antigen` should clone and install all the
declared bundles.

[liquidprompt](https://github.com/nojhan/liquidprompt) will be installed, which
you shall enjoy quite greatly.
