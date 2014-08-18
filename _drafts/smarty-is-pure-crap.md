---
template: post
---

Despites being the most used template engine for PHP, Smarty is the worst of
all.

I will try to be clear here, I am a [Twig]() user and it will be my main
comparison element to make a clear statement that Smarty is outdated,
unfriendly, syntacticly ugly and slow.

I have had to use it on a PrestaShop based website. I needed to produce a module
that provides a specific fonctionality and some user interface to configure it.
I had to do Smarty and it was painful.

Often, you need to loop in a set of value. Using Twig, you have a pythonic and
simple syntax to do so:
```jinja2
{% for element in ensemble %}

{% endfor %}
```
Though under Smarty...
```smarty
{foreach key=key value=value ensemble=ensemble}
    {$value}
{/foreach}
```
