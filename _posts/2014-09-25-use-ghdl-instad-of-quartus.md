---
title: Using ghdl instead of Quartus II
keywords: ghdl vhdl quartus gtkwave
tags: ghdl
layout: post
---

ghdl is a great tool to prototype hardware quickly. It can be combined with
gtkwave to analyze signals.

I did hardware design last semester and this is a bit tough for my mind right
now, but I think it could help others out having a hard time with Quartus II.
This post explain how to replace Quartus in the process of developing the device
...

First of all, you need `ghdl` and `gtkwave` installed on your workstation.
{% highlight bash %}
yum install ghdl gtkwave
{% endhighlight %}

Then you can create a sample project or
[clone one I did last semester](https://github.com/arteymix/ghdl-lmc).
{% highlight bash %}
git clone https://github.com/arteymix/ghdl-lmc.git
{% endhighlight %}

A project usually consist of entities and testbeds on these entities. A testbed
applies entries on an entity and make assertions on outputs.
{% highlight vhdl linenos %}
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity testbed is
end entity;

architecture testbed of testbed is

    type inputs_t is array(0 to 255) of signed(11 downto 0);

    constant inputs: inputs_t := (
        0 => x"000",
        1 => x"123",
        2 => x"456",
        3 => x"ABC",
        others => x"000"
    );

    signal cycle: natural             := 0;
    signal clk:   std_logic           := '1';
    signal input: signed(11 downto 0) := inputs(cycle);

begin
    input <= inputs(cycle mod 256);
    lmc: entity work.lmc port map(clk, '1', input);
    process is
    begin

        while TRUE loop
            clk <= '1';
            wait for 10 ns;
            clk <= '0';
            wait for 10 ns;
            cycle <= cycle + 1;
        end loop;

    end process;
end architecture;
{% endhighlight %}

ghdl can generate a Makefile for a specified unit
{% highlight bash %}
ghdl --gen-makefile testbed
{% endhighlight %}

ghdl can analyze, elaborate or run a simulation. The analyze part is essential
as it will generate object files for each entities. Then you can link all those
into a single executable. This is automated by the `make` command.
{% highlight bash %}
make
{% endhighlight %}

Once you have a correct result, you may run it and capture signals
{% highlight bash %}
./testbed --vcd=testbed.vcd
{% endhighlight %}

gtkwave is a tool designed to analyze signals, specifically the generated vcd
file.
{% highlight bash %}
gtkwave testbed.vcd
{% endhighlight %}

In gtkwave, you have to select the device in SST section and append the signals
on your workarea. You may then zoom it and out to see the actual waves.

<figure class="thumbnail">
    <img class="img-responsive" src="/assets/img/sample-of-gtkwave.png">
    <figcaption class="caption">Example of gtkwave usage.</figcaption>
</figure>

I really hope this will help you out! I did enjoy VHDL and I really liked
learning Ada-like syntax.
