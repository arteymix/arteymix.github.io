---
layout: post
title: Zero-copy FASTA Parser
tags: C GLib
---

Where I work, we deal often deal with large datasets from which we copy the
relevant entries into the program memory. However, doing so typically incurs
a very large usage of memory, which could leads to memory-bound parallelism if
multiple instances are launched.

The memory-bound parallelism issue is arising when a system cannot execute more
tasks due to a lack of available memory. It is essentially wasting of all other
available resources such as CPU time.

To address this kind of issue, I'll describe in this post a strategy using
memory-mapped files and on-demand processing over a very common data format in
bioinformatics: FASTA. The use case is pretty simple: we want to query small
and arbitrary subsequences without having to precondition them.

### About Virtual Memory Space

The virtual address space is large, very. Think of all the addresse values a 64
bit pointer can take. That's about 18 quitillions of addressable bytes, which
is enough to never be bothered with.

Understandbly, no computer can hold that much of memory. Instead, the operating
system partitions the virtual memory into pages and the physical memory into
frames. It uses a cache algorithm and load addressed pages into physical
frames. Unused pages are stored on disk, in the available swap partitions or
compressed into physical memory if you use Zswap[^zswap].

[^zswap]: [https://www.kernel.org/doc/Documentation/vm/zswap.txt](https://www.kernel.org/doc/Documentation/vm/zswap.txt)

The `mmap`[^mmap] system call makes a correspondance between a file and pages in
virtual memory. Addressing the memory where the file has been mapped will
result in the kernel fetching its content dynamically. Moreover, if multiple
processes map the same file, the same frames (i.e. physical memory) will be
used across all of them.

[^mmap]: [http://man7.org/linux/man-pages/man2/mmap.2.html](http://man7.org/linux/man-pages/man2/mmap.2.html)

```c
void * mmap (void *addr,
             size_t length,
             int prot,
             int flags,
             int fd,
             off_t offset);
```

Where `addr` hint the operating system for a memory location, `length` indicates
the size of the mapping, `prot` indicates permissions on the region, `flags`
holds various options, `fd` is a file descriptor and `offset` is a byte offset
from the file content. The returned value is the mapped address.

We can use this feature at our advantage by loading our data once and
transparently share them across all the instances of our program.

I'm using GLib, a portable C library, and its providen `GMappedFile` to
carefully wrap `mmap` with reference counting.

```c
g_auto (GMappedFile) fasta_map = g_mapped_file_new ("hg38.fa",
                                                    false);
```

### Our Use Case

To be more specific our use case only require to view small windows (~7
nucleotides) of the sequence at once. If we assume 80 nucleotides per line, we
have 80 possible windows from which 73 are free of newlines. The probability
for a random subsequence of length 7 of landing on a newline is thus
approximately 8.75%.

For the great majority of cases, assuming uniformly distributed subsequence
requests, we can simply return the address from the mapped memory.

From now on, we assume that the in-memory mapped document has already been
indexed by bookeeping the beginnings of each sequences, which can be easily
done with `memchr`[^memchr]. The `sequence` pointer points to some start of
a sequence and `sequence_len` indicate the length before the next one.

[^memchr]: [http://man7.org/linux/man-pages/man3/memchr.3.html](http://man7.org/linux/man-pages/man3/memchr.3.html)

To work efficiently, it is worth to index the newlines. For this purpose, we
use a `GPtrArray`, which is a simple pointer array implementation that we
populate with the addresses of the newlines in the mapped buffer.

```c
const gchar *sequence = "ACTG\nACTG";
gsize sequence_len    = 9;

g_autoptr (GPtrArray) sequence_skips =
    g_ptr_array_sized_new (sequence_len / 80); // line feed every 80 characters

const gchar* seq = sequence;
while ((seq = memchr (seq, '\n', sequence_len - (seq - sequence))))
{
    g_ptr_array_add (sequence_skips, (gpointer) seq);
    seq++; // jump right after the line feed
}
```

A newline can either preceed, follow or land within the subsequence.

 - all thoses preceeding the desired subsquence shifts the sequence to the right
 - all those within the subsequence must be stripped
 - the remaining newlines can be safely ignored

If only the first or last condition apply, we're in the 92.5% of the cases as
we can simply return the corresponding memory address.

```c
gsize subsequence_offset = 1;
gsize subsequence_len = 7;
```

We first position our subsequence at its initial location.

```c
const gchar *subsequence = sequence + subsequence_offset;
```

We need some bookkeeping for filling a fixed-width buffer if a newline land
within our subsequence.

```c
static gchar subsequence_buffer[64];
gsize subsequence_buffer_offset = 0;
```

Now, for each linefeed we've collected, we're going to test our three
conditions and either move the subsequence right or fill the static buffer.

The second condition require some work. Using the indexed newlines, we
basically trim the sequence into a static buffer that is returned. Although we
lose thread safety working this way, it will be mitigated by process-level
parallelism.

```c
gint i;
for (i = 0; i < sequence_skips->len; i++)
{
    const gchar *linefeed = g_ptr_array_index (sequence_skips, i);
    if (linefeed <= subsequence)
    {
        subsequence++; // move the subsequence right
    }
    else if (linefeed < subsequence + subsequence_len)
    {
        // length until the next linefeed
        gsize len_to_copy = linefeed - subsequence;

        memcpy (subsequence_buffer + subsequence_buffer_offset,
                subsequence,
                len_to_copy);

        subsequence_buffer_offset += len_to_copy;
        subsequence += len_to_copy + 1; // jump right after the linefeed
    }
    else
    {
        break; // linefeed supersedes the subsequence
    }
}
```

Lastly we check whether or not we've used the static buffer, in which case we
copy any trailing sequence.

```c
if (subsequence_buffer_offset > 0)
{
    if (subsequence_buffer_offset < subsequence_len)
    {
        memcpy (subsequence_buffer + subsequence_buffer_offset,
                subsequence,
                subsequence_len - subsequence_buffer_offset);
    }

    return subsequence_buffer;
}
else
{
    return subsequence;
}
```

It's possible to use a binary search strategy to obtain the range of newlines
affecting the position of the requested subsequence, but since the number of
newlines is considerably small, I ignored this optimization so far.

Here we are with our zero-copy FASTA parser that efficiently look for small
subsequences.

P.S.: This technique has been used for the C rewrite of miRBooking[^mirbooking]
I've been working on these past weeks.

[^mirbooking]: [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4538818/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4538818/)
