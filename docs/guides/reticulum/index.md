# Getting starting with Reticulum

[Reticulum](https://reticulum.community/) is an advanced mesh networking protocol that is more
secure, flexible, powerful, but also less easy to use than Meshcore
and Meshtastic.

This page aims at providing a guide to get started with Reticulum. It
is based off the [official manual](https://markqvist.github.io/Reticulum/manual/gettingstartedfast.html) and first hand experience.

If you know a little where you're going, start at [RNS](reticulum/rns.md).

!!! example "Advanced users only"

    This is an **advanced** guide and assumes more prior knowledge
    than our other guides normally do. Reticulum is a powerful, but
    much more complex stack than Meshcore or Meshtastic, so this guide
    is harder to follow.
    
    It's also incomplete. It is represents notes of our successes on
    various aspects of our research and development on Reticulum.
    
    Most people doing mesh networking in Montreal are currently on
    Meshcore, so you should probably see our [Getting started with
    Meshcore](meshcore.md) guide instead and [Why not
    Reticulum?](faq.md#why-not-reticulum).

## Picking the right tool

There are various ways to get started with Reticulum. Contrarily to
Meshcore and Meshtastic, Reticulum supports multiple physical medium
including LoRa, of course, but also HF radios, Bluetooth, or
TCP/IP. We have even ran Reticulum over Meshcore and Meshtastic!

This guide covers the following tools:

- [RNS](reticulum/rns.md): base routing layer, supports announcements, routing
  ("transport") over WiFi, TCP, UDP, I2P, LoRa, serial, HF radios;
  works on Linux, MacOS, Windows, Android; command-line
- [LXMF-CLI](reticulum/lxmf-cli.md): chat interface on top of RNS,
  Linux, Windows; command-line 
- [RTNode](reticulum/rtnode.md): on-device transport node firmware

Those are rather advanced tools, mostly geared towards the
command-line.

If you're just getting started but have limited patience or capacity
at dealing with such complexity, you can try one of those apps instead:

- [`Ratspeak`](https://ratspeak.org/): chat, voice calls, games, desktop, mobile and
  embedded app, Mac, Windows, Linux, iOS, Android, T-Deck Plus,
  [`Cardputer`](https://shop.m5stack.com/products/m5stack-cardputer-adv-version-esp32-s3), standalone rewrite in Rust
- [`retichat`](https://newendian.com/retichat): Mac ([App store](https://apps.apple.com/us/app/retichat/id6762225314))
- [Columba](https://columba.network/): chat, voice calls, Android
- [`MeshChatX`](https://meshchatx.com/): chat, group chat, voice calls, vibe-coded,
  integrates (poorly) with RNS, Linux

We (unfortunately) do not have guides for those applications for
now.

We also acknowledge the hard work done to create those other
applications, but consider them too hard to use for new users:

- [`Sideband`](https://github.com/markqvist/sideband): flagship GUI implementation of a chat client,
  supports Android, Linux, MacOS and Windows
- [`nomadnet`](https://github.com/markqvist/nomadnet): chat client, web-like browser, text user interface
  (TUI), Linux

Instead, we start with the basic building block of Reticulum,
[RNS](reticulum/rns.md).

## Glossary

Before we go any further, let's go over a few basic concepts in
Reticulum, as it can get confusing quickly.

- **[Reticulum](https://reticulum.community/)**: a set of transport (e.g. radio) protocols, routing
  (e.g. mesh) and application (e.g. LXMF) protocols, but also a
  reference implementation of those called RNS
- **[RNS](https://github.com/markqvist/Reticulum/)**, "Reticulum Network Stack": the reference Reticulum
  implementation, see [our guide](reticulum/rns.md)
- **[Interface](https://markqvist.github.io/Reticulum/manual/interfaces.html)**: a specific back end for Reticulum, for example LoRa, WiFi,
  TCP, Bluetooth[^1], ham radio
- **[Transport](https://markqvist.github.io/Reticulum/manual/understanding.html#reticulum-transport)**: a node that relays traffic for other. A "transport node",
  for example, is roughly equivalent to a "repeater" in Meshcore. For
  LoRa, typically comprises an embedded device (e.g. a Heltec) running
  RNode (below) and a computer (e.g. a Raspberry Pi) running RNS or
  some other application. Without a "transport node", devices can
  still talk to each other point-to-point, but they do not "mesh" over
  multiple hops.
- **[RNode](https://unsigned.io/rnode/)**: the stock Reticulum firmware that allows you to talk
  with other peers over LoRa, and that you flash on embedded devices
  (e.g. a Heltec). Different than Meshcore or Meshtastic firmware in
  that it does not work standalone; it requires software on an
  attached computer to send and receive messages or route
  traffic. Think of it like an old-school [modem](https://en.wikipedia.org/wiki/Modem).
- **[microReticulum](https://github.com/attermann/microReticulum_Firmware)**: a re-implementation of the Reticulum stack designed
  to fit in embedded devices (e.g. a Heltec). Essentially a RNode that
  can act also as a transport node.[^2] Equivalent to a Meshcore repeater.
- **[announcement](https://markqvist.github.io/Reticulum/manual/understanding.html#public-key-announcements)**: a message sent over an interface that is used to
  establish routing with transport nodes. roughly equivalent to an
  "advert" in Meshcore.
- **[identity](https://markqvist.github.io/Reticulum/manual/understanding.html#understanding-identities)**: an address in the Reticulum routing system. Roughly
  equivalent to the "public key" in Meshcore or the MAC address in
  Meshtastic, except that the full identity is used for routing
  (whereas only a few bytes are used in Meshcore).
- [**LXMF**](https://github.com/markqvist/lxmf): Lightweight Extensible Message Format. The reference chat
  implementation built on top of Reticulum. Does not support groups,
  only point to point messaging. Think of it like Signal if Reticulum
  is TCP/IP. When we say a Reticulum application supports chat, it is
  implemented with LXMF.
- **[LXST](https://github.com/markqvist/lxst)**: Lightweight Extensible Transport. Streaming system enabling
  applications like voice calls, two-way radio systems, media
  streaming and so on. When we say a Reticulum application supports
  voice calls, it is implemented with LXST.
- **[RRC](https://rrc.kc1awv.net/)**: Reticulum Relay Chat. Re-implementation of IRC over Reticulum.

[^1]: note that here, Bluetooth is used for communicating between
  devices, in a mesh network, not just for an application to control a
  device like we do in Meshcore and Meshtastic, which do *not* support
  running a mesh over Bluetooth like Reticulum does.

[^2]: [microReticulum](https://github.com/attermann/microReticulum) is technically just a C++ reimplementation
    of RNS and not useful on its own. It is combined into the
    [`microReticulum_Firmware`](https://github.com/attermann/microReticulum_Firmware) project which is a fork of the
    [reference `RNode_Firmware`](https://github.com/markqvist/RNode_Firmware), which is much more useful and why
    we link to that instead of microReticulum directly.
