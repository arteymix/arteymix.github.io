---
title: Scheme is fun!
description: Scheme is a minimal Lisp dialect
keywords: scheme list gambit
category: Scheme
tags: scheme, lisp, gambit
---

Since I have started programming, I always been attracted by simplicity and
minimalism. I always considered that a good architecture is a simple one. The
raise of complexity really tickle me, whenever it happens in the code.

So I stumbled upon Scheme at University. One of my teacher is actually seating
on their comitee and works on an C-implementation of the Lisp dialect,
[Gambit-C](). It's really cool stuff and I would like to share my first
impressions as a still-learning-functionnal-programming guy.

If you have ever heard of side-effect -- outside the medical field -- you know
how a pain it is in imperative and oriented-object programming. I tell you, a
simple example of code should give you the idea:
{% highlight python %}
james = ("James", "Morrison")

def foobar():
    """foobarize james, outside his will"""
    james = ("Side", "Effected")

foobar() # yeah, sorry james!

print("My name is {0}, {0} {1}".format(**james))
{% endhighlight %}

A scope is defined as what is accessible from a given point in a program. Mosly,
we have lexical and dynamic scope. Lexical is static and know when the program
is analyzed and dynamic scope is constructed at runtime. Language like C only
have a lexical scope, but Python has both.

The global scope is the ultimate scope. Every point in the program can access
it, where its global nature emanates.

Technically, whenever you get a pass the control flow and it is restituted, you
want to know what have changed in your scope. In this very case, calling
`foobar` has changed the value of `james` variable, which is in the global
scope. Although, the value was changed in `foobar` scope.

This is something that must be considered as probably the reason why programs
written in imperative language fail so often. It makes it difficult to compose
pieces of code when you have to take side-effects in consideration. It often
results in bugs if the programmer is inattentive in its coding.

Functionnal programming throws that away. Although Scheme is note purely
functionnal (unlike Haskell), all of its *imperative* behiavours are generally
necessary for OS interaction, so we may excuse it.

When do we start coding?
------------------------
I know you are eager to see some coding. But first, let's introduce you to basic
concepts.

Infix is making the operator preceeding its operands, just like that:
```
+ 1 2 3 4 5 ...
```

Lisp is infix, so is Scheme:
{% highlight scheme %}
(+ 1 2 3)
{% endhighlight %}

The first argument is a function taking a fixed or arbitrary number of
arguments. That _number_ of argument is called arity.

Definitions are made using the `define` keyword:
```
(define five 5)
```

A definition associate a namespace with a value.

Functions are declared with `lambda`:
```
(lambda (arg1 arg2 arg3 ...) (...))
```

The first argument of lambda is a list of arguments and the second is the body
of the function. Functions can be defined, just like anything else.
```
(define foobar (lambda (x) (+ x 1)))
```

Calling a function is refeering to the first example of code `(+ 1 2 3)`:
```
(foobar 5)
```

Which will evaluate to `(+ x 1)` then `(+ 5 1)` then `6`.
