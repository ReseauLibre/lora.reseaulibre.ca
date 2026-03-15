# Maps

We hope to eventually show a map of nodes in the local mesh, but for
now use one of those:

- [meshmap.net](https://meshmap.net/), shows neighbours, hardware details, altitude,
  position precision and so on, based on the [official MQTT server](https://meshtastic.org/docs/software/integrations/mqtt/#public-mqtt-server)
  and [brianshea2/meshmap.net](https://github.com/brianshea2/meshmap.net)
- [Liam Cottle's map](https://meshtastic.liamcottle.net/), similar to meshmap.net, but more details in
  the per-node reports, based on MQTT reports to
  `mqtt.meshtastic.liamcottle.net`, powerful map (now advertising
  meshcore)
- [Canada mesh map](https://map.mt.gt/), also based on the meshmap.net software and the
  official MQTT server, but with the `msh/CA` prefix (as opposed to
  the "default" `msh/US`
- [Meshsense map](https://github.com/Affirmatech/MeshSense), based on reports from [Meshsense](https://github.com/Affirmatech/MeshSense) installs,
  shows links between nodes

Note that those maps don't necessarily reflect actual relays that are
visible on the ground, only relays that report their position. A relay
might be in your neighbourhood and not visible on the map, so don't
rely on the map to predict success. Try anyways!

Other tools include:

- [Meshtastic Site planner](https://site.meshtastic.org/)
- [Hey What's That](https://www.heywhatsthat.com/) can also be used to predict coverage, and gives
  elevation profiles as a bonus
