---
date:
  created: 2026-08-29
  actual:  2026-09-02
title: Mesh night in September
categories:
  - events
---

!!! success

    Now with notes!

You know the drill!

Every month, [Foulab][], the Montreal hacker space, holds a mesh
night the first Wednesday of the month, and this month is
no exception!  <!-- post link when ready:
https://foulab.org/news/events-may-2026/ -->

 [Foulab]: https://foulab.org/

<!-- more -->

So join us at Foulab on September 2 from 19:00 to 22:00. We will be
talking about and experimenting with radio and mesh networking
technologies such as Reticulum, MeshCore and Meshtastic.

Beginners are welcome to drop by! We are happy to answer your
questions, but we'll also be hacking together!.

Foulab's [location][] is [Suite 33B, 999 du Collège, Montréal,
Québec, Canada, H4C 2S3][] ([Google maps][]). 

[location]: https://foulab.org/location/
[Google maps]: https://www.google.com/maps/place/999+Rue+du+Coll%C3%A8ge,+Montr%C3%A9al,+QC+H4C+2S2,+Canada
[Suite 33B, 999 du Collège, Montréal, Québec, Canada, H4C 2S3]: https://www.openstreetmap.org/node/717702812

# Notes

About 15-20 people showed up during the night. I (anarcat) noticed the
following:

- Tony demo'd [PRNS](https://reticulum.rs/) with groups, LoRa - Bluetooth -
  Bluetooth - Lora bridge with groups for isolation. PRNS has a button
  interface, no remote configuration options yet
- demo was done using, among other devices, a [Heltec Meshtower v2](https://heltec.org/project/meshtower/)
  a beautiful (if a little pricier) solar repeater with a NRF chipset,
  a solid-looking metal casing (which require some hacking at the
  screws to close correctly), and a built-in N connector, from the Ali
  Express store, which had staunch supporters
- [reflashed a relunctant RAK board](https://scoat.es/@sean/117207646077486927) using Pi Pico Zero, a debug
  probe, many fingers holding things together because we don't want to
  solder stuff permanently and me barely understanding what's
  happening
- participated in the Reticulum hacking as well by sending text
  messages with LXMF (think Signal), browsing Nomad pages (think
  Gopher/Gemini) and joining a [RRC](https://reticulum.miraheze.org/wiki/RRC) (think IRC over Reticulum) channel
  over Nomad net (yes, that impossible to use client, what do you mean
  <kbd>control-d</kdb> to send, this is not `cat(1)`)
- monitored the airwaves with an software-defined radios like the
  RTL-SDR and a [Portapack HackRF One](https://opensourcesdrlab.com/products/clifford-heath-hackrf-one-with-portapack-h4m?VariantsId=10177), with [gqrx](https://www.gqrx.dk/) on Mac and
  Linux
- witnessed the (presumably) smallest Android 13 cell phone, the
  [Jelly Star](https://en.wikipedia.org/wiki/Unihertz_Jelly_series) which seems to be deliberately designed to be
  annoying to use, a thing which its owner was very happy about
  because he was spending less time on his phone
- understood that I can hook up my LoRa transport node with the rest
  of the internet-wide Reticulum backbone without flooding LoRa, using
  a [different interface mode](https://reticulum.network/manual/interfaces.html#interfaces-modes) ([wiki](https://reticulum.miraheze.org/wiki/Interface#Modes), [simulator](https://rns.moscow/announce-sim.html)),
  probably in [`access_point`](https://reticulum.miraheze.org/wiki/Interface#access_point) (or `internal` if i eventually want
  to bridge with other LoRa networks) mode for the LoRa relay, and
  [`boundary`](https://reticulum.miraheze.org/wiki/Interface#boundary) for the internet side (but I kind of just made this
  up while writing this and god this is complicated right now, and
  don't trust this until it turns into a proper [guide](../../guides/meshcore/index.md))
- may devices were backed up, reflashed, tested, monitored and demo'd,
  including the infamous [fire hazard previously announced here](2026-08-26-wismesh-pocket-fire-hazard.md)

I'm considering making more frequent notes like this of mesh nights so
people remember what happened and see what we do there. 

If I forgot anything, let me know. Next time, I'll setup a pad so
people can note down there stuff.
