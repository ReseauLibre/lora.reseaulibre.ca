---
date:
  created: 2026-09-12
title: Please stop mining repeater identifiers
categories:
  - Announcements
---

We are seeing a trend come up in the Montreal mesh that we feel might
be problematic.

It seems people are brute-forcing "vanity" hashes, for example
repeatedly generating a device private key to have a certain 3-byte
value like [`444444`](https://live.meshcore.ca/#/nodes/4444444494a03a6cf8cf9760f135c7f9be4713c3f0084d0805529c045a0ebd5f) or [`424242`](https://live.meshcore.ca/#/nodes/424242427a28e41ea3c3da34f2b5db30e9800d868e707203d238413df6775e7e)[^1].

[^1]: We of course do appreciate finding the [Answer to the Ultimate
    Question of Life, the Universe, and Everything](https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#The_Answer_to_the_Ultimate_Question_of_Life,_the_Universe,_and_Everything_is_42), in this case.

This is problematic because it reduces the collision space for
repeaters. MeshCore already has a small space for device identifiers:
it is why you (really!) should be using 3-byte path hash mode. But if
everyone tries to guess the same cute hashes, we *will* have more
collisions and it will create routing problems in the network.

So please keep the default, randomly generated identity generated on
your device. If you notice your device is in a collision with another,
regenerate your identity as soon as possible.

If you have *already* generated a vanity hash, we strongly encourage
you to regenerate a new identifier.

This particularly affects repeaters, and especially well-reachable
ones, but also companions.

And if you are considering doing this, please don't: someone likely
already did and you will just create trouble for the mesh (and for yourself!).
