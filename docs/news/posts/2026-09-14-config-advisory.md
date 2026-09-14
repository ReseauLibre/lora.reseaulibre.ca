---
date:
  created: 2026-09-12
title: optimizing the Montreal mesh
categories:
  - Drafts
---

After discussion with key operators in Montreal and its greater area,
we are suggesting you make the following changes to your repeaters:

- [Loop detection](https://docs.meshcore.io/cli_commands/#view-or-change-this-nodes-loop-detection): `moderate`, defaults to `off`
- [Zero hop advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-zero-hop-advert-interval): `240` (minutes, defaults to `60`)
- [Flood advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-flood-advert-interval): `47` (hours, defaults to `12`)
- [Number of hops for a flood message](https://docs.meshcore.io/cli_commands/#limit-the-number-of-hops-for-a-flood-message): `16` (defaults to `64`)

On the command-line, the following is equivalent to setting the above:

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

# Why?

We are growing fast. In January, there were essentially no MeshCore
repeaters in Montreal, but since then we have passed the 100 (June)
then 200 (August) repeater mark quickly. We are on the verge of
connecting all the way from Ottawa to Québec city, which would bring
the total number of repeaters closer to a thousand.

And while we should eventually think about how to segment this traffic
with regions, that is a more complex and controversial topic than some
immediate fine-tuning we can do to improve our capacity.

So let's look at each setting in turn and see how it helps us.

## Loop detection

By default, MeshCore has no loop detection which means it's
technically possible for a packet to route back onto itself. In March,
[MeshCore 1.14 introduced loop detection](https://buymeacoffee.com/ripplebiz/path-diagnostics-improvements) but did not turn it on by
default.

With more widespread adoption of multi-byte hash mode, we believe it
is a safe setting: the setting was picked because we want people using
two-byte repeaters to still work in case of conflicts. The change
*will* impact single-byte routes over conflicting repeaters, so we
encourage companions to start switching to at least 2-byte.

## Advert limits

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

## Regions

TODO: maybe split in another proposal

flood.max.unscoped defaults to 64 in which case it tracks flood.max:

> Note: An alternative to region denyf *, setting flood.max.unscoped
> to a lower value such as 3 would allow for local unscoped messages
> to propagate, while preventing noisy neighbors from flooding a local
> region.

region strategy:

flood.max.unscoped 8
region denyf *
region def can qc mtl|qc laval
region def can qc mtl|qc laval|qc lanau|qc laur|qc mtrg
region def can qc mtl|qc laval|qc lanau|qc laur|qc mtrg|qc cqc|qc maur
region save
region

québec:

region def can qc capnat|qc maur|qc cqc|qc chapp|qc saglac

canaux:

- `#capnat` - région `capnat`
- `#montreal` - région `mtl`
- `#quebec` - région `qc`

https://meshcore.ca/config/map/

https://meshcore.ca/config/
