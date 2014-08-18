---
layout: post
title: Why Kohana just beat it
description:
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

## Kohana is surprisingly simple

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
measure their complexity.

Although criticized for its 

Kohana introduces and encourage best coding practices by defining strong
conventions and applying it rigourously.

There is no code generation.

Route can be heavily parametrized.

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

Many framework provide graphical user interface to do things

Modules are completly independent.

It is fast

It is satisfying.

Learning is worth

Kohana is not an easy framework. It does not do everything for you, but when you
know how to use it, you realize it does just enough so that it does not get in
your way.

