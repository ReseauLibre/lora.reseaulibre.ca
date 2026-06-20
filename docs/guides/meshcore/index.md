# Meshcore guides

There are two ways of configuring a Meshcore device, and so we have
two guides:

- a **[companion guide](companion.md)**: this a "client" to the mesh, that needs a repeater
  to relay messages, but that is the primary interface to send and
  receive messages

- a **[repeater guide](repeater.md)**: this is the "relay" in the mesh, which
  transmits messages between clients and repeaters and other clients
  and repeaters

If you're just getting started, try a [setting up a
companion](companion.md). You'll need a companion even if you setup a repeater.

If you want can't see anyone, want to extend the mesh, try [setting up
a repeater](repeater.md). See also the question [Should I install a relay?](../faq.md#should-i-install-a-relay)
in the FAQ.

# References

- [Official site](https://meshcore.io/)
- [Wiki](https://deepwiki.com/meshcore-dev/MeshCore)
- [Awesome MeshCore](https://github.com/samuk/awesome-meshcore)
- [Meshcore Canada](https://meshcore.ca/), and [forum](https://forum.meshcore.ca/)
- [our Matrix room](https://matrix.to/#/#reseaulibre-meshcore:matrix.org)
- [Ripple firmware user guide](https://files.liamcottle.net/MeshCore/Documentation/Ripple_User_Guide.pdf)
- [Netherlands guide on how Meshcore routing works](https://www.localmesh.nl/en/meshcore-routing-algorithms/)

## Other software

- [`meshcore-cli`](https://github.com/meshcore-dev/meshcore-cli):
  official CLI interface
- [`Meshy`](https://codeberg.org/sesivany/meshy): Linux desktop client
- [`taedryn/mesh-citadel`](https://github.com/taedryn/mesh-citadel): BBS
- [`jkingsman/Remote-Terminal-for-MeshCore`](https://github.com/jkingsman/Remote-Terminal-for-MeshCore): remote web interface
- [`Cyclenerd/meshcore-bot`](https://github.com/Cyclenerd/meshcore-bot)
- [`agessaman/meshcore-bot`](https://github.com/agessaman/meshcore-bot)
- [`watsoncj/meshcore-stats`](https://github.com/watsoncj/meshcore-stats): Prometheus exporter for repeater
  telemetry, golang
- [`rupertdev/meshcore-prometheus-exporter`](https://github.com/rupertdev/meshcore-prometheus-exporter): same, Python
- [`pyMC-dev/pyMC_Repeater`](https://github.com/pyMC-dev/pyMC_Repeater): Python-based repeaters
- [`meshcorrode`](https://github.com/Fingel/meshcorrode/): partial Rust reimplementation
