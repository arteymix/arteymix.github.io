---
layout: post
title: Rebasing Valum
tags: git
---

In order to keep a clean history of changes, we use a rebasing model for the
development of Valum.

The development often branches when features are too prototypical to be part of
the trunk, so we use branch to maintain these different states.

Some branches are making a distinct division in the development like those
maintaining a specific minor release.

 - master
 - 0.1/*
 - 0.2/*
 - ...

They are public and meant to be merged when the time seems appropriate.

At some point of the development, we will want to merge 0.2/* work into the
master branch, so the merge is a coherent approach.

When rebasing?
--------------

However, there's those branches that focus on a particular feature that does
not consist of a release by themselves. Typically, a single developer will
focus on bringing the changes, propose them in a pull request and adapt them
with others reviews.

It is absolutely correct to `push --force` on these submissions as it is
assumed that the author has authority on the matter and it would be silly for
someone else to build anything from a _work in progress_.

If changes have to be brought, amending and rewritting history is recommended.

If changes are brought on the base branch, rebasing the pull request is also
recommended to keep things clean.

The moment everyone seems satisfied with the changes, it gets merged. GitHub
creates a merge commit even when fast-forwarding, but it's okay considering
that we are literally merging and it has the right semantic.

Let's just take a typical example were we have two branches:

 - `master`, the base branch
 - `0.1/route-with-callback`, a branch containing a feature

Initially, we got the following commit sequence:

    master
    master -> route-with-callback

If a hotfix is brought into master, `0.1/route-with-callback` will diverge from
`master` by one commit:

    master -> hotfix
    master -> route-with-callback

Rebasing is appropriate and the history will be turned into:

    master -> hotfix -> route-with-callback

When the feature's ready, the master branch can be fast-forwarded with the
feature. We get that clean, linear and comprehensible history.

How do I do that?
-----------------

Rebasing is still a cloudy git command and can lead to serious issues from
a newcomer to the tool.

The general rule would be to **strictly** rebase from a non-public commit. If
you rebase, chances are that the sequence of commits will not match others, so
making sure that your history is not of public authority is a good starter.

`git rebase -i` is what I use the most. It's the interactive mode of the rebase
command and can be used to rewrite the history.

When invoked, you get the rebasing sequence and the ability to process each
commit individually:

 - squash will meld two commits
 - fixup is like squash, but will discard the squashed commit message
 - reword will prompt you for editing the commit message

I often stack work in progress in my local history because I find it easier to
manage than stashes. When I introduce new changes on my prototypes, I fixup the
appropriate commit.

However, you can keep a cleaner work environment and branch & rebase around,
it's as appropriate. You should do what you feel the best with to keep things
manageable.

Hope that's clear enough!
