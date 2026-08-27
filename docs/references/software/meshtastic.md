# Meshtastic

A collection of software we find interesting enough to outline on top
of the [official list](https://meshtastic.org/docs/software/).

## Apps

Those are programs that run on a phone or tablet:

- official [app](https://meshtastic.org/downloads//), also [shipped on F-Droid](https://f-droid.org/packages/com.geeksville.mesh/)

Note that those won't work without a LoRa transmitter, to which you
typically connect over Bluetooth.

## Computer clients

Those are clients that run on a normal computer (as opposed to a phone
"app"):

- [command-line client and Python library](https://github.com/meshtastic/python): can be used to talk to
  devices (packaged in Debian)

- rudimentary [GTK client](https://gitlab.com/kop316/gtk-meshtastic-client) (packaged in Debian)

- [official network management client](https://github.com/meshtastic/network-management-client)

- [contact](https://github.com/pdxlocations/contact) (messaging)

- [connect](https://github.com/pdxlocations/connect) (LoRa-less client)

- [Meshsense](https://github.com/Affirmatech/MeshSense) monitors the local view of the mesh, shows maps,
  traceroute, signal reports, see also [this demo](https://affirmatech.com/meshsense/FJP1/) and the global
  [Meshsense map](https://github.com/Affirmatech/MeshSense) created from installs that report back

## BBS and bots

A BBS ([Bulletin Board System](https://en.wikipedia.org/wiki/Bulletin_board_system)) is a server hooked up to Meshtastic
to provide information, storage, etc.

- [TC2-BBS-mesh](https://github.com/TheCommsChannel/TC2-BBS-mesh): mail, channel directory, stats, fortune

- [Frozen BBS](https://github.com/kstrauser/frozenbbs): another BBS, rust

- [hops](https://github.com/morria/hops): bot from [`nyme.sh`](https://nyme.sh/)

- [meshing-around](https://github.com/SpudGunMan/meshing-around): "BBS" like functionality, ping, weather alerts,
  shell commands, games, quizzes, messaging, testing (one of the
  [Puget mesh projects](https://pugetmesh.org/meshtastic/#member-projects))

## Bridges

A "bridge" is a service that will connect Meshtastic to another
service or network.

- [official home assistant bridge](https://github.com/meshtastic/home-assistant), untested
- [MeshCore to Meshtastic relay](https://meshnard.com/mesh/mt-mc_relay): source of the `[MT<>MC]`
  messages you might have seen in the wild
- [`IceNet-01/meshtastic-bridge`](https://github.com/IceNet-01/meshtastic-bridge): Meshtastic to Meshtastic
  bridge to forward between channels, Prometheus, MQTT, and Home
  assistant support, there's a couple like this, see also
  [`geoffwhittington/meshtastic-bridge`](https://github.com/geoffwhittington/meshtastic-bridge): "WIP", connects
  multiple networks over MQTT or HTTP
- [`aprstastic`](https://github.com/afourney/aprstastic): [APRS](https://en.wikipedia.org/wiki/Automatic_Packet_Reporting_System) gateway (one of the [Puget mesh
  projects](https://pugetmesh.org/meshtastic/#member-projects)), untested
- [`jaredquinn/meshtastic-bridge`](https://github.com/jaredquinn/meshtastic-bridge): APRS, GPS, logger,
  Prometheus, untested
- [`siltamesh`](https://codeberg.org/tpikonen/siltamesh): [XMPP](https://en.wikipedia.org/wiki/XMPP) bridge, untested
- [`jeremiah-k/meshtastic-matrix-relay`](https://github.com/jeremiah-k/meshtastic-matrix-relay): [Matrix](https://matrix.org) bridge, see the
  [Matrix bridge documentation](bots.md#usage) for more usage tips
- [`AkitaEngineering/Akita-Meshtastic-Meshcore-Bridge`](https://github.com/AkitaEngineering/Akita-Meshtastic-Meshcore-Bridge): another
  generic bridge, named after MeshCore, but really aimed at
  bridging Meshtastic with other tools, untested
- [`cpatulea/matterbridge`](https://github.com/cpatulea/matterbridge): [fork of Matterbridge](https://github.com/42wim/matterbridge/compare/master...cpatulea:matterbridge:master) ([itself
  unmaintained](https://github.com/42wim/matterbridge/issues/2251)) that [posts messages](https://codeberg.org/foulab/foubot2/commit/f1e79507cdff83bd5ee88b05168f45240e434f8f) from the Meshtastic
  mesh to the Foulab Mattermost

# Monitoring
 
 - [`hacktegic/meshtastic-prometheus-exporter`](https://github.com/hacktegic/meshtastic-prometheus-exporter): Prometheus metrics
   exporter, counts packets, signal levels, sensor data, last report
   time per node, untested
 - [`cordelster/mesh-metrics`](https://github.com/cordelster/mesh-metrics/): metrics sent over a Prometheus push
   gateway, odd design, untested
 - [`tcivie/meshtastic-metrics-exporter`](https://github.com/tcivie/meshtastic-metrics-exporter): MQTT to
   TimescaleDB/Grafana monitoring, behind [`dash.mt.gt`](https://dash.mt.gt/), untested
 - [`Meshmonitor`](https://meshmonitor.org/): maps, analytics, traceroute, triggers, untested

## Flashing tools

- [reflashtic](https://gitlab.com/anarcat/scripts/-/blob/main/reflashtic.py?ref_type=heads): batch flashing tool I wrote, derived from work a
  friend did on a similar bash script

- [`mikecarper/meshfirmware`](https://github.com/mikecarper/meshfirmware): "automatic" flasher (one of the [Puget mesh
  projects](https://pugetmesh.org/meshtastic/#member-projects))
