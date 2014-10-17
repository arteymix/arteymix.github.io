---
title: Database migration
description: How to do the database migration.
---

Database migration is something we face a day or another if the software
developed ever get through its first version. It is an important task that
shouldn't be left apart on the planning.

The core of the issue is about going forward

There are multiple approaches to solve that issue.

* completely avoiding by using evolving database like MongoDB
* calculating a differential with existing databases
* maintaining migration scripts

Whathever approach is taken, it will have to follow the evolution of the
codebase

I think that an iterative approach forged on the versionning of the software is
a good way to solve the issue. Code evolution requires a symmetric data
structure evolution: both things should therefore follow the same workflow.
