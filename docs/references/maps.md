---
tags:
  - traduction/aucune
---

# Maps

We hope to eventually show a map of nodes in the local mesh, but for
now use one of those.

## Meshcore

- [official map](https://map.meshcore.io/), see [this link for Montreal](https://map.meshcore.io/?zoom=11&lat=45.5951&lon=-73.5294), which shows
  about 14-25 relays in the greater Montreal area as of 2026-03-18
- <https://analyzer.letsmesh.net/map> has lots of data and will spin
  up the fan on your laptop. shows three relays in the greater
  Montreal area as of 2026-03-18
- <https://yul.meshmapper.net/> shows actual tested coverage from the
  [MeshMapper project](https://wiki.meshmapper.net/), which essentially allows users to "war
  drive" a real-time map of where repeaters can be reached, shows 6 nodes in Montreal

## Meshtastic

- [`meshmap.net`](https://meshmap.net/), shows neighbours, hardware details, altitude,
  position precision and so on, based on the [official MQTT server](https://meshtastic.org/docs/software/integrations/mqtt/#public-mqtt-server)
  and [`brianshea2/meshmap.net`](https://github.com/brianshea2/meshmap.net), sees about 35 nodes in the
  Montreal area as of 2026-03-18
- [Liam Cottle's map](https://meshtastic.liamcottle.net/), similar to `meshmap.net`, but more details in
  the per-node reports, based on MQTT reports to
  `mqtt.meshtastic.liamcottle.net`, powerful map (now advertising
  Meshcore), sees about 51 nodes in the Montreal area
  as of 2026-03-18
- [Canada mesh map](https://map.mt.gt/), also based on the `meshmap.net` software and the
  official MQTT server, but with the `msh/CA` prefix (as opposed to
  the "default" `msh/US`, sees about 23 nodes in the Montreal area
  as of 2026-03-18
- [Meshsense map](https://meshsense.affirmatech.com/), based on reports from [Meshsense](https://github.com/Affirmatech/MeshSense) installs,
  shows links between nodes, sees about 23 nodes in the Montreal area
  as of 2026-03-18

Note that those maps don't necessarily reflect actual relays that are
visible on the ground, only relays that report their position. A relay
might be in your neighbourhood and not visible on the map, so don't
rely on the map to predict success. Try anyways!

## Progression

We're trying to keep track of how many relays we see on those maps,
over time. Here's an attempt at summarizing this:

| Date       | Meshcore | Meshtastic |
|------------|----------|------------|
| 2026-03-18 | 3-25     | 23-51      |
| 2026-04-24 | 17-47    | ~25        |

## Site planners

Those tools allow you to see what a relay in a given location would
see. It's useful to plan where to install a relay.

- [Planificateur de site](https://site.meshtastic.org/)
- [Hey What's That](https://www.heywhatsthat.com/) can also be used to predict coverage, and gives
  elevation profiles as a bonus
