---
tags:
  - traduction/aucune
---

# Maps

This the coverage map of the [MeshMapper
project](https://wiki.meshmapper.net/), for the MeshCore mesh. See
below for other maps.

<!-- update the iframe in index.md when updating this, see also https://wiki.meshmapper.net/embedding/-->
<iframe src="https://yul.meshmapper.net/embed.php?lat=45.508545&amp;lon=-73.589824&amp;zoom=10&amp;geofence=0&amp;" width="100%" height="500px" style="border:0;" loading="lazy" allowfullscreen>
  </iframe>

## MeshCore

- [official map](https://map.meshcore.io/), see [this link for Montreal](https://map.meshcore.io/?zoom=11&lat=45.5951&lon=-73.5294), which shows
  about 14-25 relays in the greater Montreal area as of 2026-03-18
- <https://analyzer.letsmesh.net/map> has lots of data and will spin
  up the fan on your laptop. shows three relays in the greater
  Montreal area as of 2026-03-18
- <https://yul.meshmapper.net/> (also shown above) shows actual tested coverage from the
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
  MeshCore), sees about 51 nodes in the Montreal area
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

## Reticulum

- [`rmap.world`](https://rmap.world/)
- [`rns.fyi`](https://rns.fyi/)

## Progression

Moved to the FAQ, in [How many nodes in the network?](../guides/faq.md#how-many-nodes-in-the-network).

## Site planners

Those tools allow you to see what a relay in a given location would
see. It's useful to plan where to install a relay.

- [Planificateur de site](https://site.meshtastic.org/)
- [Hey What's That](https://www.heywhatsthat.com/) can also be used to predict coverage, and gives
  elevation profiles as a bonus
