---
layout: post
---

This post is a simple introduction to Makefile and how it can make you more
proficient.

`make` is a powerful tool designed to automate tasks on files. It is generally
used by C programmers for compiling efficiently. 

A Makefile is a set of recipes. Each recipe process dependencies and produce
target. In C, a source file `*.c` (the dependency) will be compiled 
(the recipe code) to an object file `*.o` (the target).

This way, you can define dependencies between your recpies. For instance, you
may want to call a preprocessor and compiler on your source files and then link
the resulting objects. The first dependencies are your source files and their 
targets are the object codes. The second dependencies are your objects and the
target is the linked executable.

A tabulation (TAB) character must introduce every recipe code line. It is
generally a good practise to write one-liner by keeping a strong recipe
division.

```make
target: dependencies
    recipe code
```

`make` process recipes in a way it ensures the latest modification date of
all dependencies match the target.

The target and the dependency is available through `$@` and `$<` variables
respectively in the recipe code.

```make
main.o: main.c
    gcc -c -o $< $@
```

Recipes can be made generic using a wildcard (`%`)

```make
%.o: %.c
    gcc -c -o $< $@
```

Then you can define a target that depends on the generic recipe so that you can
handle as many source files as you have.

```make
SOURCES=main.c
all: $(SOURCES)
```

And you may also be more generic on how `$(SOURCES)` is defined

```make
SOURCES=$(find . -name '*.c')
```

The last code example introduced a very important feature of makefiles. Every
line of a recipe code can be shell commands, but `make` also has a powerful
macro system.

```make
$(<macro> <arguments>)
```

The most notable are `shell` and `patsubstr`, but `make` provide a wide range
of macro.

$(prefix )

$(suffix $(CSS) ) 
