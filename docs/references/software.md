# Software

A collection of software we find interesting enough to outline on top
of the [official list](https://meshtastic.org/docs/software/):

## Apps

Those are programs that run on a phone or tablet:

- official [Android app](https://meshtastic.org/docs/category/android-app/), also [shipped on F-Droid](https://f-droid.org/packages/com.geeksville.mesh/)
- official [iOS app](https://meshtastic.org/docs/software/apple/installation/)

Note that those won't work without a LoRa transmitter, to which you
typically connect over Bluetooth.

## Computer clients

Those are clients that run on a normal computer (as opposed to a phone
"app"):

- [commandline client and Python library](https://github.com/meshtastic/python): can be used to talk to
  devices (packaged in Debian)

- rudimentary [GTK client](https://gitlab.com/kop316/gtk-meshtastic-client) (packaged in Debian)

- [contact](https://github.com/pdxlocations/contact) (messaging)

- [connect](https://github.com/pdxlocations/connect) (LoRa-less client)

## BBS and bots

A BBS ([Bulletin Board System](https://en.wikipedia.org/wiki/Bulletin_board_system)) is a server hooked up to Meshtastic
to provide information, storage, etc.

- [TC2-BBS-mesh](https://github.com/TheCommsChannel/TC2-BBS-mesh): mail, channel directory, stats, fortune

- [Frozen BBS](https://github.com/kstrauser/frozenbbs): another BBS, rust

- [hops](https://github.com/morria/hops): bot from [nyme.sh](https://nyme.sh/)

- [meshing-around](https://github.com/SpudGunMan/meshing-around): "BBS" like functionality, ping, weather alerts,
  shell commands, games, quizzes, messaging, testing (one of the
  [Puget mesh projects](https://pugetmesh.org/meshtastic/#member-projects))

## Gateways and bridges

A "gateway" is a server that will connect Meshtastic to another
service or network.

 - [aprstastic](https://github.com/afourney/aprstastic): [APRS](https://en.wikipedia.org/wiki/Automatic_Packet_Reporting_System) gateway (one of the [Puget mesh
   projects](https://pugetmesh.org/meshtastic/#member-projects))

## Other tools

- [reflashtic](https://gitlab.com/anarcat/scripts/-/blob/main/reflashtic.py?ref_type=heads): batch flashing tool I wrote, derived from work a
  friend did on a similar bash script

- [meshfirmware](https://github.com/mikecarper/meshfirmware): "automatic" flasher (one of the [Puget mesh
  projects](https://pugetmesh.org/meshtastic/#member-projects))
