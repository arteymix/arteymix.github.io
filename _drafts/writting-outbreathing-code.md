Writting outbreathing code
==========================

The quality of a written code could be measured in how long its lines remain
unchanged in a codebase.

## Write simple code
Writting simple code is easy.

Declaring the smallest amount of variables is a good start. It is efficient
to write code the reuses data structure instead of creating new one. Your 
code will likely run faster if it does a minimum of operations to get things
done.

In particular, avoid counters. It is much clearer to iterate using an iterator
syntax than counting till the last element of an ensemble.

    def simple():
        for i in range(10):
            print(i * 2)

    def complicated():
        i = 0
        while i < 10:
            print(i * 2)
            i += 1

If your language provide a collection api like Java or Python: use it 
extensively instead of declaring your own types. Also, use the right types!
In Python, for instance, if what you need is an unordered collection, use
a set, not a list.

    unordered\_values = {1, 2, 'a'}

You can use set operations like union and difference.

    unordered\_values = unordered\_values - {1}


## Indent your code
Indentation makes your code readable. Scopes should always be indented with
a fixed amount of spaces. Line within a scope should always be indented with
the minimum amount of space that makes it easily readable.

It is always a matter of language wether to align code within block or not.
In assembly, always align: but not in Python.

    def foo():
        # operate...

    a = 1
    ab = 2

    add 1,  $1
    sub 10, $1
