---
layout: post
title: Scheme is fun!
description: Scheme is a minimal Lisp dialect
keywords: scheme, list, gambit
category: Scheme
tags: scheme lisp gambit
---

Since I have started programming, I always been attracted by simplicity and
minimalism. I always considered that a good architecture is a simple one. The
raise of complexity really tickle me, whenever it happens in the code.

So I stumbled upon Scheme at University. One of my teacher is actually seating
on their comitee and works on an C-implementation of the Lisp dialect,
[Gambit-C](http://gambitscheme.org/wiki/index.php/Main_Page). It's really cool
stuff and I would like to share my first impressions as a
still-learning-functionnal-programming guy.

If you have ever heard of side-effect --- outside the medical field --- you know
how a pain it is in imperative and oriented-object programming. I tell you, a
simple example of code should give you the idea:
{% highlight python %}
james = ("James", "Morrison")

def foobar():
    """foobarize james, outside his will"""
    james = ("Side", "Effected")

foobar() # yeah, sorry james!

print("My name is {0}, {0} {1}.".format(**james))
{% endhighlight %}

A scope is defined as what is accessible from a given point in a program. Mostly,
we have lexical and dynamic scope. Lexical is static and known when the program
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

Prefix notation is a way to describe arithmetic by making the operator
preceeding its operands, just like that:
{% highlight scheme %}
+ 1 2 3 4 5 ...     ; prefix
1 + 2 + 3 + 5 + ... ; infix
1 2 3 5 +           ; postfix
{% endhighlight %}

As you can see, it is a very compact notation with multiple advantages:
* operator can take as many operands
* easy to interpret
* compact

The postfix notation has its advantages too, but it is hard to write programs
when they expand on the left. You can, for instance, easily interpret them using
a stack.

In the preceeding example, you need to push `1`, `2`, `3`, `4`, `5` in the
stack. When you read `+`, you pop the stack and apply the addition then push the
result back. It works no matter how complicated your expression is. This is how
[PostScript](http://en.wikipedia.org/wiki/PostScript) work for instance.

Lisp is prefix, so is Scheme:
{% highlight scheme %}
(+ 1 2 3)
{% endhighlight %}

The `a => b` notation means `a` evaluates to `b`.
{% highlight scheme %}
(+ 1 2 3) => 6
{% endhighlight %}

The first argument is a function taking a fixed or arbitrary number of
arguments. The number of argument is called arity.

Definitions are made using the `define` keyword:
{% highlight scheme %}
(define five 5)
{% endhighlight %}

A definition associate a namespace with a value.

Functions are declared with `lambda`:
{% highlight scheme %}
(lambda (arg1 arg2 arg3 ...)
  (...))
{% endhighlight %}

The first argument of lambda is a list of arguments and the second is the body
of the function. Functions can be defined, just like anything else.
{% highlight scheme %}
(define foobar (lambda (x)
  (+ x 1)))
{% endhighlight %}

Calling a function is refeering to the first example of code `(+ 1 2 3)`:
{% highlight scheme %}
(foobar 5) => 6
{% endhighlight %}

Which will evaluate to `(+ x 1)` then `(+ 5 1)` then `6`.

So now, we can make definitions, create lambda function, declare values: how
does that make functionnal programming so powerful? or at least as powerful as
any imperative programming language?

The rest of the article will describe how things are to be thoughts in
functionnal programming when you have an imperative background --- just like me
a few weeks ago.

Conditional
-----------
In order for conditional expression to work, we need boolean values. In Scheme,
`#f` is false and anything different is considered true (`#t`). This is a very
elegant way to describe truth, considering other languages like PHP have a
really ill way of doing so.

Scheme has `if` and `cond` syntax for describing conditionals.

`if` is a function of three arguments: the second
being evaluated on the truth of the first argument, the second otherwise.
{% highlight scheme %}
(if c
  (...)  ; evaluated if c is #t
  (...)) ; evaluated if c is #f
{% endhighlight %}

`cond` is a function of an arbitrary number of arguments. Each argument is a
pair where the first element is an boolean expression and the second an
expression to be evaluated given the first to be true. Scheme stops on the first
condition being true.
{% highlight scheme %}
(cond
  ((c1) (e1))  ; e2 evaluated if c1 is #t
  ((c2) (e2))) ; e2 evaluated if c1 is #f and c2 is #t
{% endhighlight %}

This really looks like a `switch` statement from imperative programming.

`cond` are preferred over `if` when you need to branch in more than 2 control
flow as it keeps the program depth constant.

Loops
-----
How do we loop? Mostly we don't: applying a treatment on all elements of an
list is done using `map`.
{% highlight scheme %}
(map function list)
{% endhighlight %}

For example, if you want to have a list of absolute values,
{% highlight scheme %}
(map (lambda (x)
       (+ x)) '(1 -1 2))
=> '(1 1 2)
{% endhighlight %}

However, if we really need to do a literal loop:
{% highlight scheme %}
(define f (lambda (x)
    (f (+ x 1)))) ; call f with x incremented
{% endhighlight %}

If your terminal call is the function or a base case, Gambit-C will convert it
in a simple loop: this is called tail-recursion. This is a very important notion
in functionnal programming. We call a expression that can be tail-recursed an
iterative form. They are very practical as they use a constant amount of stack
once optimized.

Data structure
--------------
Think of it: list can represent fixed-size array, linked-list, tree and even
map.

To introduce data structure property, I have to describe what a symbol is.
Usually, a Scheme interpreter will evaluate expression, but you may prevent this
behiaviour using a the `quote` function or a simple quote.
{% highlight scheme %}
(quote (1 2 3)) => '(1 2 3)
{% endhighlight %}

This will freeze the evaluation which result in a symbol. Symbols are generally
lists and used for data structure.

Map are implemented as a list of pair. To understand what a pair is, you must
know that every list in Lisp is a pair where the first element is a value and
the second is a list where the first element.. you get the point.

Therefore, when you write
{% highlight scheme %}
'(1 2 3)
{% endhighlight %}

You have, in fact, written
{% highlight scheme %}
'(1 (2 (3 ())))
{% endhighlight %}

If you want to create a pair, you can use the `cons` function or put a dot
before the second element.
{% highlight scheme %}
(cons 1 2) => '(1 . 2)
{% endhighlight %}

A map is a list of pairs that can be accessed using `assoc`
{% highlight scheme %}
(define m '((1 . 2) (2 . 3) (3 . 4)))
(assoc m 1) => 2
(cons 1 2) => '(1 . 2)
{% endhighlight %}

Remarks
-------
I would like to finish with a couple of remarks about Scheme and Lisp in
general.

You have probably noticed that outside _special forms_, order of evaluation is
irrelevant, providing great parallelism perspectives. No doubt Lisp was
developed to be the language for AI.

This is it. I really hope you dig into functionnal programming like I do: it
makes you think differently and better at programming.

