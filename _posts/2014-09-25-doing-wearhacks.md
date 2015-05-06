---
layout: post
title: Doing WearHacks!
external-url: https://wearhacks.com
keywords: WearHacks, Hackaton, wearable, Nod ring, Bluetooth, Unity
tags: Bluetooth Hackaton
---

This week-end, I'll be participating to WearHacks which occurs in my hometown
Montreal. You can find out more [here](https://wearhacks.com).

<img class="img-responsive" src="/assets/img/wearhacks/front-in-poa.png">

So far, I am very confident. We have 2 excellent programmers and a UI/UX guys
which will be working on Unity. If everything goes as planned, we will push a
web app backed with Python offering a very interesting user experience.

I have two concerns right now. I do not know much about the device, which will
be the [Nod ring](https://hellonod.com) and I am worried about scaling the
computation we will have to be done. Roughly, we have to do some linear algebra
and approximate value comparison.

Thing is, I want to keep stuff in Python as it will allow us to code lightning
quick, which is essential when you have a 36 hours deadline.


Communicating using Bluetooth
-----------------------------

That's the tricky part: we don't know the device since it's not on market. We
will have to reverse-engineer the data we need. I know it follows these
OpenSpacial next-to-be standard and it seems to work in 6D (x, y, z) for
acceleration and gyro, so if I can extract that data, I'm fine. I need to do
this quick, if I can do it, then the rest will be a piece of cake.

I will also have the possibility to communicate with people who designed the
hardware, so I guess I will have more information on Bluetooth protocol implied
and general data encoding.


Scaling the computation
-----------------------

We will receive 3-directional data from the device which is pretty much an
accelerometer. We have to figure out the trajectory, smooth the transitions and
compare it with another trajectory. This is a lot of data to treat, especially
since we need to have the result in real time (otherwise, we will have to
redesign the product). I plan to rely on [numpy](http://www.numpy.org/) to make
any of these calculation possible.

I will have to normalize the acceleration based on gyroscope data. I do not want
to deal with rotational acceleration.

The trajectory will be approximated using a polynom per dimension since the
acceleration data is 3-dimensional. I will generate a polynom going through
every points of acceleration using the
[polyfit](http://docs.scipy.org/doc/numpy/reference/generated/numpy.polyfit.html)
function.

To compare two trajectories, we will have to calculate the integral difference
between each polynoms


Communicating with the frontend
-------------------------------

Frontend communication will be done using WebSocket through
[socket.io](http://socket.io/) library. It creates a full-duplex communication
system, which will allow us to communicate in both directions. The device will
update the frontend and the frontend will send messages. The frontend uses
Unity, so this library will do the trick
[UnitySocketIO](https://github.com/NetEase/UnitySocketIO).


Producing the UI
----------------

UI will be done using Unity 3D. I do not know much about it and I don't need to!

I really hope we will do good at this Hackaton.
