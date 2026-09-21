---
date:
  created: 2026-09-12
title: A draft region practice
categories:
  - announcements
---

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
