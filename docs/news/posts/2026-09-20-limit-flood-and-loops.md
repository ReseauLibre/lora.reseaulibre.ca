---
date:
  created: 2026-09-12
title: Please limit adverts, loops and floods
categories:
  - announcements
---

After discussion and testing with key operators in Montreal and its
greater area, we strongly encourage you to make the following changes
to your repeaters:

- [Loop detection](https://docs.meshcore.io/cli_commands/#view-or-change-this-nodes-loop-detection): `moderate`, defaults to `off`
- [Zero hop advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-zero-hop-advert-interval): `240` (minutes, defaults to `60`)
- [Flood advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-flood-advert-interval): `47` (hours, defaults to `12`)
- [Number of hops for a flood message](https://docs.meshcore.io/cli_commands/#limit-the-number-of-hops-for-a-flood-message): `16` (defaults to `64`)

On the command-line, the equivalent is the following commands:

```
set loop.detect moderate
set advert.interval 240
set flood.advert.interval 47
set flood.max 16
```

For repeaters with many neighbors (30-50), we also advise raising `txdelay`

- [Retransmit delay for flood traffic](https://docs.meshcore.io/cli_commands/#view-or-change-the-retransmit-delay-factor-for-flood-traffic): `1` (defaults to `0.5`)
- [Retransmit delay for direct traffic](https://docs.meshcore.io/cli_commands/#view-or-change-the-retransmit-delay-factor-for-direct-traffic): `0.5` (defaults to `0.2`)

Command-line equivalent:

```
set txdelay 1
set direct.txdelay 0.5
```

TODO: rxdelay? https://docs.meshcore.io/cli_commands/#experimental-view-or-change-the-processing-delay-for-received-traffic

## Why?

We are growing fast. In January, there were essentially no MeshCore
repeaters in Montreal, but since then we have passed the 100 (June)
then 200 (August) repeater mark quickly. We are on the verge of
connecting all the way from Ottawa to Québec city, which would bring
the total number of repeaters closer to a thousand.

And while we should eventually think about how to segment this traffic
with regions, that is a more complex and controversial topic than some
immediate fine-tuning we can do to improve our capacity.

So let's look at each setting in turn and see how it helps us.

### Loop detection

By default, MeshCore has no loop detection which means it's
technically possible for a packet to route back onto itself. In March,
[MeshCore 1.14 introduced loop detection](https://buymeacoffee.com/ripplebiz/path-diagnostics-improvements) but did not turn it on by
default.

With more widespread adoption of multi-byte hash mode, we believe it
is a safe setting: the setting was picked because we want people using
two-byte repeaters to still work in case of conflicts. The change
*will* impact single-byte routes over conflicting repeaters, so we
encourage companions to start switching to at least 2-byte.

### Advert limits

The other three settings ([Zero hop advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-zero-hop-advert-interval), [Flood advert
interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-flood-advert-interval) and [Number of hops for a flood message](https://docs.meshcore.io/cli_commands/#limit-the-number-of-hops-for-a-flood-message)) are all
designed to reduce non-content traffic on the mesh.

Adverts are the single largest packet on the mesh and use the most
airtime of any packet. And while they are nice in that they show us
where repeaters are, they are not actually required for the mesh to
function.

Right now, adverts are flooding the UK and pacific northwest meshes
right now, as they have passed a critical mass where the frequency of
adverts times the number of repeaters essentially means the mesh is
constantly relaying telemetry instead of content.

The local (non-flood) advert interval was raised from one hour to six
hours, to make sure companions would see local repeaters appear within
their first day.

The flood advert inter is raised from twice a day to once every *four*
days, which still allows for building a good map over the course of a
week. It's set to four days minus one hour to creep the flood time by
one hour every day, to avoid having repeaters always flooding at the
same time every day.

Looking at the [analytics](https://dev.meshcore.ca/?iata=YUL&tab=Analytics&range=30d), we spend a *lot* of airtime (16%, or
one out of six packets!)  doing adverts. As of this writing
(2026-09-20), we have had this number of packets in the last 30 days:

| Payload type      | Count   | Ratio | Note                       |
|-------------------|---------|-------|----------------------------|
| Group text        | 271664  | 26%   | Channel messages, good.    |
| Request           | 262860  | 25%   | Unexpected, see below      |
| Advert            | 188927  | 16%   | What we want to fix!       |
| Text message      | 87445   | 8%    | Direct messages            |
| Response          | 84382   | 8%    | Related to Request         |
| Control           | 60127   | 6%    |
| Anonymous request | 43458   | 4%    |
| Path              | 42249   | 4%    |
| Others            | ~10000  | ~1%   |
| **TOTAL**         | 1051112 | 98%   | Forgive the rounding error |

## What about regions?

Regions are... more complicated. They require more in-depth, perhaps
breaking changes to people's configuration and are not currently
widely in use. The above settings have been tested on actual repeaters
and are known to be safe, and will improve the mesh.

## What about those requests?

While writing the "Advert limits" section documentation above, we
actually found out a large amount of traffic on the mesh was,
surprisingly, of the payload type ["request"](https://docs.meshcore.io/payloads/#request).

While we would *love* to fix that problem too, we currently do not
know exactly what is causing this or how to fix it. We are *hoping*
that people [switching to 3-byte routing](2026-09-18-3-bytes-hash-mode.md) will help with reducing
the number of such packets that *flood* the network, that said.

## Feedback and comments

In any case, suggestions welcome!
We welcome comments and feedback on this proposal through [our regular
contact points](../../contact.md) and the [merge request on Codeberg](https://codeberg.org/reseaulibre/lora-reseaulibre-ca/pulls/TODO).
