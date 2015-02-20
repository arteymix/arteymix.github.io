XML is not inappropriate, you are.

This is simple

Why does it seems that we have to choose between JSON and XML when those two format are semantically different? As you have probably noticed, these two formats are intrisically different.

One very simple way to notice the difference is probably through trying passing from one another.

```json
{
    "color": "blue"
    ""
}
```

<table>
  </>
</table>


XML is document-oriented and JSON is object-oriented.

The same distinction applies between a tree and a map.

Let's say you have the following XML:

<node key="value">

</node>

How well does it translates to JSON?

We know, at least, that the attributes form a mapping:

{
    "key": "value"
}

When you think it the oriented-object way, you have to ask you what are the entities and what they possess.

What does a node in a XML tree possess?

 - children
 - attributes

```json
{
    "children": [],
    "attributes": {
        "key": "value"
    }
}
```

To represent correctly an XML document in JSON, we had to add information to represent the a of mapping structure.

Now, let's do the same, but the opposite way.

{
    "name": "Alfred",
    "age": 34
}

<person name="alfred" age="34"/>

Same thing happened: we had to introduce the `person` tag in order to represent correctly our JSON object.

We have another opposition:

 - JSON structure is implicit
 - XML structure is explicit

These two formats do not represent the same thing, at least not as efficiently one another.

There are situation where JSON is more appropriate than XML and the opposite is as true.

 - an HTML document requires a hiearchy and a mapping
 - your invoices

Choose XML when it is clear what the tree represents and what the attributes are used for.
