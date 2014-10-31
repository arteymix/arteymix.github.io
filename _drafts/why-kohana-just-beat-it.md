---
layout: post
title: Why Kohana just beat it
description:
keywords:
category: Kohana
tags: Kohana
---

Kohana is, to my opinion, the greatest modern MVC PHP5 framework. I have always
been critical to PHP itself and from as far as I remember, building up a web
application upon it is a painful thing. In fact, PHP is not designed for web, as
any language, but a framework like Symphony or Zend is. You may learn much of
a language from using it solely, but when you need to write real code that will
run somedays on a machine, you need to stick on a well developed tool. Kohana is
one of that tool.

There is so much misunderstanding about it that it gets me angry sometimes. I
wish people to see its greatness, but I don't know any other mean but making its
demonstration.

This article is therefore dedicated to promote the Kohana framework as a working
tool for web application. I would like to cover a few points, especially what
makes it a modern MVC framework and also make some comparisons with equivalent
feature from other frameworks ([Symphony 2](), [CakePHP](), [Laravel]()).

Kohana is surprisingly simple
-----------------------------
The Kohana framework has a simple code base. Example of this could be found in
pattern reusing, simple and generic Request model, small codebase and enforced
conventions.

Once you've learned how something work, you've learned it all. Kohana sticks on
its best practices all over its codebase. The way to make singleton, the
getter/setter method, the simplicity of its classes. This way, you never get
lost when you dig the code.

| Kohana | Zend | Symphony 2 |
---------|------|------------|
Number of classes
Class compleity

This test evaluates the number of class present in each framework core and
measure their coupling.

Although criticized for its lack of documentation and abrupt learning curve, the
latter is a myth that can be deconstructed.

Kohana induce and encourage the best coding practices by defining strong
conventions and applying it rigourously.

There is no code generation as there is no need for it. CRUD generator you
usually find in other framework are not useful here: code ending in controller
and model is so simple that you are better writting it down yourself.
{% highlight php %}
class User extends ORM { }
{% endhighlight %}

All columns are already mapped to the SQL definition, only by inheriting from
`ORM`.

Basically, a constructor that operates on model looks like
{% highlight php %}
<?php

class Controller_User extends Controller_Template {

    public action_index()
    {
        $user = ORM::factory('User', $this->request->param('id'));

        if ($this->request->method() === Request::POST)
        {
            $user
              ->values($this->request->post())
              ->update();
        }

        $this->template->user = $user;
    }
}
{% endhighlight %}

Although, you might want your other actions to operate on the same model:
{% highlight php %}
<?php

class Controller_User extends Controller_Template {

    public function before()
    {
        parent::before();

        $this->user = ORM::factory('User', $this->request->param('id'));
    }

    public function action_index()
    {
        if ($this->request->method() === Request::POST)
        {
            $this->user
                ->values($this->request->post())
                ->update();
        }
    }

    public function action_delete()
    {
        $this->user->delete();

        HTTP::redirect(Route::get('default')->uri());
    }

    public function after()
    {
        $this->template->user = $user;

        parent::after();
    }
}
{% endhighlight %}

In the `before` function, you fetch model. In `action_`, you operate and in
`after`, you finalize the response. Every line of the preceeding code does
a significant operation.

Route can be heavily parametrized
---------------------------------
Many framework passes their variables through action function arguments. This is
a strange practice that compromise considerably the flexibility of the
application.

Having the route parameters bound to the Request object accessible in the
controller is what Kohana does.

```php
public function action_index()
{
    $id = $this->request->param('id');
}
```

This way, it is even possible to do generic handling for every action related to
a specific resource.

```php
public function before()
{
    parent::before();

    $this->user = ORM::factory('User', $this->request->param('id'));
}
```

This avoid code repetition and let action deal directly with the model layer.

The framework provides a cascading file system (CFS) that allow application to
override specific behiavior in the framework or to extend it. Doing so
simplifies the application code as it does not need to create new structures
outside its very requirements (controllers, models and views) but
only extending.

The interface is your application, not the framework.

Many framework provide graphical user interface to do things. Kohana let
developer do things.

Modules are completly independent.

It is fast

It is satisfying.

Integration and unit testing is simple
--------------------------------------
Kohana integrates with [PHPUnit]() like a charm.

Learning is worth
-----------------
Writting apps is fast.

Kohana is compatible with [Composer](), giving you access to thousands of
PHP-written libraries to solve specific issues.

Kohana is not an easy framework. It does not do everything for you, but when you
know how to use it, you realize it does just enough so that it does not get in
your way.

I like what's arriving!
-----------------------
The `3.4/develop` has very [interesting features incoming]().

Kohana is now fully developed on GitHub, making collaboration easier and more
accessible.

The cascading `application`, `modules` and `system` folders will be restructured
in modules, allowing you to couple multiple application in a single one like
[blueprints in Flask]().

PHP 5.3 is now deprecated: Kohana exploit non-legacy features from the language,
which makes code slightly more readable.

An application will be completely installable through the `composer` command,
which will make the dependencies easier to manage.

