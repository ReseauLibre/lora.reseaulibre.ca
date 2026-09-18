---
date:
  created: 2026-09-18
title: Please use 3 bytes routing
categories:
  - announcements
---

In August, many repeater operators in the greater Montreal area
started experimenting with [multi-byte path routing](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#39-q-what-is-multibyte-support-what-do-1-byte-2-byte-3-byte-adverts-and-messages-mean). We now
strongly recommend that you configure your repeaters (and companions)
to use multi-byte routing, particularly if you have trouble with
direct messages or remotely operating a repeater.

One-byte repeaters are also at risk of being dropped from the
MeshMapper map, and the new "Canada" preset should pre-configure your
devices correctly.

This announcement explains how to retrofit your devices and why we are
making this change.

## How do I configure 3-byte routing?

The MeshCore project has introduced a new "Canada" preset which
pre-selects 3-byte routing. If you are configuring a device (or
existing!) using the latest firmware, just pick this preset and it
will do the right the right thing.

For older devices, see [this question in the FAQ](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#393-q-how-do-i-change-my-companions-path-hash-size) but generally,
you need to configure the "Path hash mode" to "3 bytes (max 21 hops)",
which can be also shown as "2 - 3 bytes". That setting used to be
hidden behind a ", which "Experimental settings" section but is now a
first level setting in the official application.

On the command-line, use:

    set path.hash.mode 2

The value is a little confusing, 2 means 3 bytes, here are the
possible values:

| `path.hash.mode` | Advert path hash size |
|------------------|-----------------------|
| 0                | 1 byte (default)      |
| 1                | 2 bytes               |
| 2                | 3 bytes               |

## Why 3-byte routing?

The MeshCore project still defaults to 1-byte for most regions, but
*has* switched to 3 bytes for Canada. The upstream rationale for
keeping the 1-byte default for other regions is that multibyte
messages just get dropped by older releases, but we have long passed
that threshold. In fact, we believe the mesh *cannot* function correctly
with single-byte repeaters, so every repeater *must* set a multibyte
path hash mode.

The fundamental issue with 1-byte routing is that one byte is a very
small address space. There's at most 256 possible identifiers that fit
in one byte. But because of the [birthday paradox](https://en.wikipedia.org/wiki/Birthday_problem), with only 20
repeaters, there is a 50% chance of a clash.[^1] Raising this to two
bytes only brings us to 300 repeaters, so we believe we need *at
least* 3 bytes (which gives a 50% clash with ~4000 repeaters).

[^1]: for math people, this is [OEIS sequence A033810](https://oeis.org/A033810), with
    `n=256` (`256 = 2**8`) instead of `n=365`. You can use the Python
    code in that sequence to calculate the others:
    
        >>> A033810(2**8)
        20
        >>> A033810(2**16)
        302
        >>> A033810(2**24)
        4823

Identifier clashes like this are causing all sorts of problems:

 1. they make routing much harder to debug: when tracing a path to see
    which repeaters a message took, we can get aberrations like a
    message seemingly hopping hundreds of kilometers

 2. they make direct messages nearly impossible: because clashes can
    happen with as few as 20 repeaters, you are much more likely to
    pick the wrong path for a direct message, or experience route
    flapping, as conflicting paths are announced, which leads to
    direct messages being lost

But this applies not only to repeaters, but also companions. Because
multi-byte routing is used only when the *companion* sets it,
single-byte companion experience the mesh as if it was entirely made
of single-byte repeaters as well!

So setting a multibyte path hash mode on your companion should improve
the reliability of your direct messages (DMs). Because DMs are
*routed* (as opposed to channel messages and adverts that are
*flooded*), it is crucial that the right path is taken. In single-byte
configuration, that single byte is ambiguous and can refer to multiple
conflicting repeaters. So an advert you receive that might tell you to
go through a specific set of repeaters might actually tell your
companion to use a really bad route for a contact.

This applies to direct messages, but also remote operation of repeaters.

If you're having trouble with DMs or repeater administration, try
setting multibyte path hash mode!

## Won't this limit the size of the mesh and number of hops?

Some might notice that the number of allowed hops is reduce by this
change. The setting in the official app says:

- 1-byte (max 64 hops)
- 2-byte (max 32 hops)
- 3-byte (max 21 hops)

We don't believe this to be a problem. Beyond 10-20 hops, the mesh
gets *extremely* noisy and traffic rarely gets through. LoRa has
limited bandwidth, and limiting the size of the mesh is a good
thing. 

With 10 hops, we are already reaching Quebec and believe that, with
proper region management, we should be able to connect Ottawa and
Quebec with a 21 hop limit.

## Feedback and comments

We welcome comments and feedback on this proposal through [our regular
contact points](../../contact.md) and the [merge request on Codeberg](https://codeberg.org/reseaulibre/lora-reseaulibre-ca/pulls/13).
