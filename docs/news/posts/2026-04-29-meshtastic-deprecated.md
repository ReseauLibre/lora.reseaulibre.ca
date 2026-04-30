---
date:
  created: 2026-04-29
title: Deprecating Meshtastic in Montreal
categories:
  - announcements
---

As of today, Meshcore has overtaken Meshtastic in number of devices
visible from maps in the greater Montreal area. While this might be a
questionable heuristic, it's pretty clear when comparing the current
[Meshcore map](https://map.meshcore.io/?zoom=8&lat=45.8594&lon=-73.1580) and the [Meshtastic map](https://meshmap.net/) that Meshcore has
already surpassed Meshtastic in raw numbers. 

As of today, there are 48 Meshcore devices and at most 29 Meshtastic
devices on those maps.

Last year, Meshcore barely existed at all. 

Late 2025, I setup my first Meshcore companion, and I wasn't seeing
any relays. In fact, I don't remember there being *any* relay in
Montreal a couple of months ago.

In March 2026, a similar map survey showed about 25 devices. A month
later, there's double that number.

All that time, I tried to work with Meshtastic. I tried to ping
people, talk, nothing went through. Telemetry showed me devices as far
as Burlington, Vermont! And we'd sometimes hear messages from
there. But I have never really seen a full conversation happen over
Meshtastic.

Now, with about a dozen relays visible from my roof, I already feel
the mesh is more reliable. It's just a hunch, but I feel Meshcore's
more deliberate, "infrastructure" device will scale better than
Meshtastic's more "ad-hoc" approach.

So this is my call: let's deprecate Meshtastic and focus on other
technologies. Right now, Meshcore certainly seems to have the
momentum. 

But let's keep an eye on Reticulum too; good progress has been made on
various firmware projects based on micro-Reticulum, which embed a full
transport node onto the same micro-controller devices that run
Meshtastic or Meshcore. It's not yet as easy to deploy yet, but
certainly something to keep an eye on.
