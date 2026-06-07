# Networking with RNS

RNS is the [base Reticulum software](https://github.com/markqvist/Reticulum/), still developed by the
original founder of the Reticulum project.

!!! bug "Proprietary software warning"

    Unfortunately, Reticulum now ships [with a non-free license](https://github.com/markqvist/Reticulum/discussions/781#discussioncomment-13209632) which
    has [stalled the Debian packaging effort](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1101959) but also lead to the
    proliferation of [other implementations](https://reticulum.miraheze.org/wiki/Implementations). 
    
    [RetiNet](https://codeberg.org/skyguy/retinet) seems to be the
    direct descendent, a fork of RNS before the license
    change. [rsReticulum](https://github.com/ratspeak/rsReticulum)
    seems pretty advanced as well, and so is
    [leviculum](https://codeberg.org/Lew_Palm/leviculum). There are
    also other implementations by military startups we will not
    glorify here.

    Since most people still use the reference implementation, and that
    others derive from it generally stay compatible, this guide
    follows the reference implementation.

## Installation and configuration

Installing Reticulum is easy if you're familiar with the command line
and Python:

    python -m venv --system-site-packages .venvs/reticulum
    .venvs/reticulum/bin/pip install rns
    echo 'PATH=$PATH:.venvs/reticulum/bin/' >> .bashrc

The primary service you will run is called `rnsd`, and you can simply
run it with:

    rnsd -v

You can also [configure it as a systemd service](https://markqvist.github.io/Reticulum/manual/using.html#using-systemd).

On first start, `rnsd` will create a configuration file and a
public/private key pair for your identity:

```
anarcat@dorothea:~$ rnsd -v
[2026-06-05 09:53:44] [Notice]   Could not load config file, creating default configuration file...
[2026-06-05 09:53:44] [Notice]   Default config file created. Make any necessary changes in /home/anarcat/.reticulum/config and restart Reticulum if needed.
[2026-06-05 09:53:45] [Verbose]  Bringing up system interfaces...
[2026-06-05 09:53:45] [Verbose]  AutoInterface[Default Interface] discovering peers for 1.92 seconds...
[2026-06-05 09:53:47] [Verbose]  System interfaces are ready
[2026-06-05 09:53:47] [Verbose]  Configuration loaded from /home/anarcat/.reticulum/config
[2026-06-05 09:53:47] [Verbose]  Destinations file does not exist, no known destinations loaded
[2026-06-05 09:53:47] [Verbose]  No valid Transport Identity in storage, creating...
[2026-06-05 09:53:47] [Verbose]  Identity keys created for <6575da95d1d9c8e5d01c560c73c8e67f>
[2026-06-05 09:53:47] [Notice]   Started rnsd version 1.3.5
```

## Interfaces

In the above default configuration file, you will see this interface:

```
[interfaces]

  [[Default Interface]]
    type = AutoInterface
    enabled = Yes
```

Reticulum is built on "[interfaces](https://markqvist.github.io/Reticulum/manual/interfaces.html)", which represent each of the
physical layers (LoRa, TCP/IP, Bluetooth, etc).

The above configures the [Auto interface](https://reticulum.network/manual/interfaces.html#auto-interface) which connects
automatically to hosts discovered on the local network. On its own, it
will not do much but it *will* allow you to experiment with Reticulum
with peers on the local network. If you come to Mesh night, there's a
good chance someone will be available to test this with you.

But a local interface only goes so far as the local network, and is
not very useful on its own. So let's look at other interfaces.

### TCP interfaces

If you do not have local partner to play with, add a couple interfaces
(perhaps those that look the closest to you) from one of those lists
of public entry points:

- [`reticulum.community`](https://reticulum.community/connect.html)
- [`directory.rns.recipes`](https://directory.rns.recipes/)
- [`rmap.world`](https://rmap.world/)

Here is an example interface:

    [[Example Testnet]]
      type = TCPClientInterface
      enabled = yes
      target_host = reticulum.example.com
      target_port = 4242

This configuration will tell Reticulum to connect to the given host on
the internet to route with other Reticulum users.

!!! note

    Yes, we know, this is kind of cheating: we're not really doing a
    local mesh in this case, and are routing over the Internet
    instead. But Reticulum is a mixed medium system: it considers the
    possibility of using the internet a *feature* and happily uses
    TCP/IP or LoRa. We show this example to allow you to test the
    system without having LoRa neighbours, which might not be
    available.
    
    In our defence, the above configuration is actually *not*
    functional as `example.com` does not run a reticulum interface at
    the moment.

So yes, this is cheating. Let's try a "real" interface, LoRa, the same
medium used by Meshtastic and Meshcore.

### RNode

[RNode](https://unsigned.io/rnode/) is a firmware that can be flashed on small LoRa radio
transceivers that act as "modems" for the RNS software, allowing it to
talk over much longer distances than the `AutoInterface` (which is
restricted to the local network).

This is where we're going into the real, physical world of building a
fully autonomous, local mesh network, without the internet.

But for this, you need a device. Many devices, but not all, from our
[hardware reference](../../references/hardware/index.md) are supported by RNode. The [RNode
Firmware](https://github.com/markqvist/RNode_Firmware) originally supported only a few of those devices, but a
[community edition](https://github.com/liberatedsystems/RNode_Firmware_CE) came out with [support for many more](https://github.com/liberatedsystems/RNode_Firmware_CE#supported-products-and-boards).

Thankfully, flashing those devices is rather easy. You can use [Liam
Cottle's web-based flasher](https://liamcottle.github.io/rnode-flasher/) (also known for his Meshcore
work). Note that if you're used to Meshtastic or Meshcore flashers,
the Reticulum one is a little less intuitive: you first need to
download the firmware, then select it after downloading it.

Once the device is flashed, you will need to add the following
interface to your `~/.reticulum/config` file:

```
[[RNode LoRa Interface]]
  type = RNodeInterface
  enabled = yes
  port = /dev/ttyUSB1
  frequency = 914875000
  bandwidth = 125000
  txpower = 22
  spreadingfactor = 7
  codingrate = 7
  
  # this will make the interface announced to other networks, for
  # example someone browsing the local wifi network will be able to
  # notice the LoRa configuration and configure *their* RNode
  # appropriately
  discoverable = yes
```

The [full RNode interface configuration](https://markqvist.github.io/Reticulum/manual/interfaces.html#rnode-lora-interface) is worth a read as well.

Restart `rsnd` and it should try to connect to your RNode device!

!!! example "Command line option"

    If you are familiar with the command line, there is a program shipped
    with RNS called `rnodeconf` allows you to flash those devices with
    RNode in an interactive way, with:
    
        rnodeconf --autoinstall
    
    It will walk you through a series of prompts to flash your device.
    
    At some point, it will ask you for the device model. If you're
    flashing a heltec it will tell you it is experimental, and you can
    ignore it.
    
    It will ask you which region / band to use, make sure you pick the 915
    MHz band. You will then be prompted for actual frequency,
    bandwidth and power settings, see below for those.

#### A note on frequency settings

When configuring LoRa frequencies, we recommend people who want to
join the Reticulum mesh in Montreal use those frequencies:

- frequency: 914.875 MHz
- bandwidth: 125 kHz
- power: 22 dB
- spread factor: SF7
- coding rate: 4:7

!!! note

    Those are inspired by the [Ottawa settings](https://ottawamesh.ca/reticulum/reticulum-frequency-settings/#frequency-settings-for-reticulum).

    See also our [discussion of frequencies in the FAQ](../faq.md#which-radio-frequencies-are-you-using).

### Meshcore tunneling

We can run Reticulum over Meshcore! See our [Tunneling Reticulum over
Meshcore](meshcore.md).

## Basic RNS tools

Once `rnsd` is running with an interface you can start testing if you
can connect with anyone.

The first thing you need to run is:

    rnstatus

This will show you your interfaces and whether they are working.

Here's an example output with *all* the above interfaces configured:

    $ rnstatus 

     Shared Instance[rns/default]
        Status    : Up
        Serving   : 1 program
        Rate      : 1.00 Gbps
        Traffic   : ↑0 B        0 bps
                    ↓405 B      3.24 Kbps

     AutoInterface[Default Interface]
        Status    : Up
        Mode      : Full
        Rate      : 10.00 Mbps
        Peers     : 0 reachable
        Traffic   : ↑0 B        0 bps
                    ↓0 B        0 bps

     TCPInterface[Example Testnet/reticulum.example.com:4242]
        Status    : Down
        Mode      : Full
        Rate      : 10.00 Mbps
        Traffic   : ↑0 B        0 bps
                    ↓0 B        0 bps

     RNodeInterface[RNode LoRa Interface]
        Status    : Up
        Mode      : Full
        Rate      : 3.91 kbps
        Noise Fl. : -99 dBm, no interference
        CPU temp  : 62°C
        Battery   : 96% (discharging)
        Airtime   : 0.0% (15s), 0.0% (1h)
        Ch. Load  : 0.0% (15s), 0.0% (1h)
        Traffic   : ↑0 B        0 bps
                    ↓0 B        0 bps


There you can see all the interfaces are working, *except* the
`TCPInterface`. You should be able to see the reason in the  `rnsd`
output, for example in our case:

    [2026-06-05 10:15:03] [Error]    Initial connection for TCPInterface[Example Testnet/reticulum.examplecom:4242] could not be established: [Errno -2] Name or service not known

In this case, you'll need to pick a different TCP interface. We
purposefully do not provide a default here because we do not want to
overwhelm a public interface.

!!! tip

    You *could* run such an interface for the local mesh! If you run
    Linux, you would probably want to start by configuring a public
    [backbone interface](https://markqvist.github.io/Reticulum/manual/interfaces.html#backbone-interface).

You can monitor the interfaces with:

    rnstatus -m

To see the adverts we have received:

    rnpath -t

To *send* adverts is a little more complicated, because *now* you need
to pick one of the clients listed in the first section.

The trick here is that adverts, like in Meshcore and Meshtastic, are
bound to an identity, but contrarily to those two-site, the identity is not
tied to keys on the device (in Meshcore) or the hardware ("MAC")
address of the device (in Meshtastic).

The keys reside on the computer or mobile operating the interface! So
they depend on the application.

!!! tip

    You *can* technically send an announce by using the transport identity:

        rnid -i .reticulum/storage/transport_identity -a

    But we do not recommend doing this outside of the lab.

Once you have peers, you can see the path to them with `rnpath`, which
will show you how any hops, through which peer and which interface,
reaches a given destination.

```
$ rnpath 64607119a6bfd90f3ca6d4332968b35c
Path found, destination <64607119a6bfd90f3ca6d4332968b35c> is 1 hop away via <48b2dbadf91f9b7a181b1ff0a7017b72> on RNodeInterface[RNode LoRa Interface]
```

So let's get talking!
