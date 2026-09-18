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
MeshMapper map. The new "Canada" preset should pre-configure your
devices correctly.

This announcement explains how to configure your devices and why we
are making this change.

## How do I configure 3-byte routing?

The MeshCore project has introduced a new "Canada" preset which
pre-selects 3-byte routing. If you configure a new (or existing!)
device using the latest firmware, just pick the Canada preset and it
will do the right thing.

For older devices, see [this question in the FAQ](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#393-q-how-do-i-change-my-companions-path-hash-size) but generally,
you need to configure the `Path hash mode` to `3 bytes (max 21 hops)`,
which can be also shown as `2 - 3 bytes`. That setting used to be
hidden behind a `Experimental settings` section but is now a first
level setting in the official application.

You can also make the change through the command-line interface with
the command:

    set path.hash.mode 2

The value is a little confusing, `2` here means `3 bytes`. Here are
the possible values for the setting:

| `path.hash.mode` | Advert path hash size |
|------------------|-----------------------|
| 0                | 1 byte (default)      |
| 1                | 2 bytes               |
| 2                | 3 bytes               |

## Why 3-byte routing?

The MeshCore project still defaults to 1-byte for most regions, but
*has* switched to 3 bytes for Canada. The upstream rationale for
keeping the 1-byte default for other regions is that multibyte
messages just get dropped by releases before 1.14 (released in March
2026). We believe a vast majority of routers on the local mesh are
running that release or later.

We believe the mesh *cannot* function correctly with single-byte
repeaters, so every repeater *must* set a multibyte path hash mode.

The fundamental issue with 1-byte routing is that one byte is too
small. There are 256 possible identifiers that fit in one byte. But
because of the [birthday paradox](https://en.wikipedia.org/wiki/Birthday_problem), there is a 50% chance of a clash
with only 20 repeaters.[^1] Raising this to two bytes only brings us
to 300 repeaters, so we believe we need *at least* 3 bytes, which
gives a 50% clash with ~4800 repeaters.

[^1]: for math people, this is [OEIS sequence A033810](https://oeis.org/A033810), with
    `n=256` (`256 = 2**8`) instead of `n=365`. You can use the Python
    code in that sequence to calculate the others:
    
        >>> A033810(2**8)
        20
        >>> A033810(2**16)
        302
        >>> A033810(2**24)
        4823

Identity clashes cause all sorts of problems:

 1. routing is much harder to debug: when tracing a path to see which
    repeaters used by a given message, we can get aberrations like a
    message seemingly hopping hundreds of kilometers

 2. direct messages are nearly impossible to route: because clashes
    can happen with as few as 20 repeaters, you are much more likely
    to pick the wrong path for a direct message, or experience route
    flapping, as conflicting paths are announced, which leads to
    direct messages being lost

But this applies not only to repeaters, but also companions. Because
multi-byte routing is used only when the *companion* sets it,
single-byte companion experience the mesh as if it was entirely made
of single-byte repeaters as well!

So setting a multibyte path hash mode on your companion will improve
the reliability of your direct messages (DMs). Because DMs are
*routed* (as opposed to channel messages and adverts that are
*flooded*), it is crucial for messages to find the right path. In
single-byte configuration, that byte is ambiguous and can refer to
multiple conflicting repeaters. So an advert you receive that might
tell you to go through a specific set of repeaters might actually tell
your companion to use a really bad route for a contact.

This applies to direct messages, but also remote operation of
repeaters, which operate similarly to direct messages, in that they
are routed.

So if you're having trouble with DMs or repeater administration, try
setting multibyte path hash mode!

## Won't this limit the size of the mesh and number of hops?

Some might notice that the number of allowed hops is reduce by this
change. The setting in the official app says:

- 1-byte (max 64 hops)
- 2-byte (max 32 hops)
- 3-byte (max 21 hops)

We don't believe this to be a problem. Limiting the number of hops in
the mesh is a good thing, because each hop exponentially raises the
number of retransmissions, see [this post for details](https://forum.meshcore.ca/t/follow-up-from-salishmesh-swbc-experiences-how-to-deal-with-large-saturated-congested-meshes/38/7?u=anarcat).

With 10 hops, we are already reaching Quebec and believe that, with
proper region management, we should be able to connect Ottawa and
Quebec with a 21 hop limit.

## Why not 2 bytes?

We go with 3 bytes because 2 bytes is not enough either. With the
birthday paradox, there's a 50% chance of a collision with 300
repeaters.

And while we're not quite there yet in Montreal strictly speaking (as
of September 2026), we definitely have more than 300 repeaters if we
count Ottawa (289), Trois-Rivières (37) and Québec (80), we definitely
have more than 300 repeaters.

## Feedback and comments

We welcome comments and feedback on this proposal through [our regular
contact points](../../contact.md) and the [merge request on Codeberg](https://codeberg.org/reseaulibre/lora-reseaulibre-ca/pulls/13).
