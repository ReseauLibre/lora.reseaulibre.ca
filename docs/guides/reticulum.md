# Getting starting with Reticulum

[Reticulum](https://reticulum.community/) is an advanced mesh networking protocol that is more
secure, flexible, powerful, but also less easy to use than Meshcore
and Meshtastic.

This page aims at providing a guide to get started with Reticulum. It
is based off the [official manual](https://markqvist.github.io/Reticulum/manual/gettingstartedfast.html) and first hand experience.

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

If you're just getting started but have limited patience or capacity
at dealing with exotic software or the command line, you should try
one of those apps first:

- [Columba](https://columba.network/): chat, voice calls, Android
- [`MeshChatX`](https://meshchatx.com/): chat, group chat, voice calls, vibe-coded,
  integrates (poorly) with RNS, Linux
- [`retichat`](https://newendian.com/retichat): Mac ([App store](https://apps.apple.com/us/app/retichat/id6762225314))
- [`Ratspeak`](https://ratspeak.org/): chat, voice calls, games, desktop, mobile and
  embedded app, Mac, Windows, Linux, iOS, Android, T-Deck Plus,
  [`Cardputer`](https://shop.m5stack.com/products/m5stack-cardputer-adv-version-esp32-s3), standalone rewrite in Rust

We (unfortunately) do not cover on boarding with most of those
applications for now.

In this guide, we will cover the following command-line tools:

- [RNS](https://github.com/markqvist/Reticulum/): base routing layer, supports announcements, routing
  ("transport") over WiFi, TCP, UDP, I2P, LoRa, serial, HF radios;
  works on Linux, MacOS, Windows, Android
- [LXMF-CLI](https://github.com/fr33n0w/lxmf-cli): chat interface on top of RNS, Linux, Windows

We also acknowledge the hard work done to create those other
applications, but consider them too hard to use for new users:

- [`Sideband`](https://github.com/markqvist/sideband): flagship GUI implementation of a chat client,
  supports Android, Linux, MacOS and Windows
- [`nomadnet`](https://github.com/markqvist/nomadnet): chat client, web-like browser, text user interface
  (TUI), Linux

Instead, we're covering the basic building block of Reticulum, RNS.

## Glossary

Before we go any further, let's go over a few basic concepts in
Reticulum, as it can get confusing quickly.

- **[Reticulum](https://reticulum.community/)**: a set of transport (e.g. radio) protocols, routing
  (e.g. mesh) and application (e.g. LXMF) protocols, but also a
  reference implementation of those called RNS
- **[RNS](https://github.com/markqvist/Reticulum/)**, "Reticulum Network Stack": the reference Reticulum
  implementation
- **[Interface](https://markqvist.github.io/Reticulum/manual/interfaces.html)**: a specific backend for Reticulum, for example LoRa, WiFi,
  TCP, Bluetooth[^1], ham radio
- **[Transport](https://markqvist.github.io/Reticulum/manual/understanding.html#reticulum-transport)**: a node that relays traffic for other. A "transport node",
  for example, is roughly equivalent to a "repeater" in Meshcore. For
  LoRa, typically comprises an embedded device (e.g. a Heltec) running
  RNode (below) and a computer (e.g. a Raspberry Pi) runnin RNS or
  some other application. Without a "transport node", devices can
  still talk to each other point-to-point, but they do not "mesh".
- **[RNode](https://unsigned.io/rnode/)**: the stock Reticulum firmware that allows you to talk with
  other peers over LoRa, and that you flash on embedded devices
  (e.g. a Heltec). Different than Meshcore or Meshtastic firmware in
  that it does not work standalone and requires software on a computer
  attached to it to send receive messages or route traffic. Think of
  it like an old-school "modem".
- **[microReticulum](https://github.com/attermann/microReticulum)**: a reimplementation of the Reticulum stack designed
  to fit in embedded devices (e.g. a Heltec). Essentially a RNode that
  can act also as a transport node.
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
- **[RRC](https://rrc.kc1awv.net/)**: Reticulum Relay Chat. Reimplementation of IRC over Reticulum.

[^1]: note that here, Bluetooth is used for communicating between
  devices, in a mesh network, not just for an application to control a
  device like we do in Meshcore and Meshtastic, which do *not* support
  running a mesh over Bluetooth like Reticulum does.

## RNS

RNS is the [base Reticulum software](https://github.com/markqvist/Reticulum/), still developed by the
original founder of the Reticulum project.

!!! bug "Proprietary software warning"

    Unfortunately, Reticulum now ships [with a non-free license](https://github.com/markqvist/Reticulum/discussions/781#discussioncomment-13209632) which
    has [stalled the Debian packaging effort](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1101959) but also lead to the
    proliferation of [other implementations](https://reticulum.miraheze.org/wiki/Implementations). 

    Since most people still use the reference implementation, and that
    others derive from it generally stay compatible, this guide
    follows the reference implementation.

### Installation and configuration

Installing Reticulum is easy if you're familiar with the command line
and Python:

    python -m venv --system-site-packages .venvs/reticulum
    .venvs/reticulum/bin/pip install rns

The primary service you will run is called `rnsd`, and you can simply
run it with:

    rnsd -v

You can also [configure it as a systemd service](https://markqvist.github.io/Reticulum/manual/using.html#using-systemd).

On first start, `rnsd` will create a configuration file and a
public/private keypair for your identity:

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

### Interfaces

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

#### TCP interfaces

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

#### RNode

[RNode](https://unsigned.io/rnode/) is a firmware that can be flashed on small LoRa radio
transceivers that act as "modems" for the RNS software, allowing it to
talk over much longer distances than the `AutoInterface` (which is
restricted to the local network).

This is where we're going into the real, physical world of building a
fully autonomous, local mesh network, without the internet.

But for this, you need a device. Many devices, but not all, from our
[hardware reference](../references/hardware/index.md) are supported by RNode. The [RNode
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

##### A note on frequency settings

When configuring LoRa frequencies, we recommend people who want to
join the Reticulum mesh in Montreal use those frequencies:

- frequency: 914.875 MHz
- bandwidth: 125 kHz
- power: 22 dB
- spread factor: SF7
- coding rate: 4:7

!!! note

    Those are inspired by the [Ottawa settings](https://ottawamesh.ca/reticulum/reticulum-frequency-settings/#frequency-settings-for-reticulum).

    See also our [discussion of frequencies in the FAQ](faq.md#which-radio-frequencies-are-you-using).

#### Meshcore

Amazingly, because Reticulum can route over essentially anything, you
can route Reticulum traffic over Meshcore meshes.

!!! example "Advanced users only!"

    This is a particularly exotic Reticulum configuration. 
    
    We are not sure this is a good idea. It might flood the Meshcore
    mesh, for example. So far, there seems to be only moderate (2x)
    amplification in traffic so we're continuing to experiment. but we
    do not recommend people adopt this, generally.
    
    Meshcore people typically frown upon Meshcore being bridged across
    regions or with other networks, and might consider such use to be hostile.

    Finally, if you're just getting started with Reticulum, this one
    will be particularly confusing, just skip this section.

During the May 2026 mesh night at Foulab, we have successfully routed
Reticulum messages over a local LoRa link with two Meshcore companions
connected over serial.

We are using [this fork of the `RNS_Over_MeshCore` interface](https://github.com/slack-t/RNS_Over_MeshCore).

To install it, we clone it and deploy the file in place.
```
cd .reticulum/interfacse
git clone https://github.com/slack-t/RNS_Over_MeshCore
ln -s RNS_Over_MeshCore/Interface/MeshcoreInterface.py .
```

Then we add the interface to the RNS configuration file in `~/.reticulum/config`:

```
[[MeshCore]]
   type = MeshcoreInterface
   interface_enabled = true

   # === Transport settings ===
   #transport = ble           # Options: ble | serial | tcp
   transport = serial
   #port = /dev/ttyUSB0       # Serial port if transport = serial
   #baudrate = 115200         # Serial baudrate
   #host = 127.0.0.1          # TCP host if transport = tcp
   #tcp_port = 4403           # TCP port if transport = tcp
   #ble_name = MeshCore-Obdolbus  # BLE device name (optional, auto-scan if empty)

   # === RNS channel settings ===
   # IMPORTANT: Change channel_secret to a unique value! The default is published
   # in the source code — anyone using it can read your traffic. Generate one with:
   #   python3 -c "import os; print(os.urandom(16).hex())"
   # Then set the SAME secret on ALL your RNS-over-MeshCore nodes.
   # channel_name = RNSTunnel
   # channel_secret = <your-unique-16-byte-hex-secret>
   # channel_idx =                                        # Leave empty to auto-select, fallback = 39
   channel_name = RNSTunnel
   # this is #RNSTunnel
   channel_secret = 04f6a140660d9836752cbbdb71bb601a

   # === Fragmentation / reliability ===
   #count_repeat = 1              # Number of full interleaved rounds to send all fragments
   #fragment_mtu = 100            # Max payload bytes per fragment (test higher values for speed)
   #fragment_delay = 3            # Starting delay between fragments (seconds), adapts automatically
   #fragment_delay_min = 1        # Minimum adaptive delay (seconds)
   #fragment_delay_max = 30       # Maximum adaptive delay (seconds)
   #delay_step_down = 0.5         # Seconds subtracted from delay on each successful send
   #delay_backoff_factor = 1.5    # Multiplier applied to delay on each failed send
   #fragment_timeout = 180        # Timeout for incomplete fragment reassembly (seconds)
   #bitrate = 2000                # Rate limiting in bytes/sec, 0 = unlimited
   #opportunistic_sending = false # Send next fragment as soon as previous completes
   #guard_delay = 0.3             # Minimum gap between sends in opportunistic mode (seconds)
   #flood_scope =                 # Limit propagation to repeaters allowing this scope (requires firmware >1.14)
```

Note that we use a hardcoded `channel_secret` above, which upstream
[strongly warns against](https://github.com/slack-t/RNS_Over_MeshCore#channel-secret). We consider those concerns to be
unfounded since Reticulum encrypts traffic before injecting into the
transport. Instead, we favor instead broad compatibility across
clients, using a common, public channel.

!!! bug

    Pay close attention to the `type` line above. In the upstream
    documentation, it says to use:
    
        type = MeshCoreInterface
    
    But the filename is `MeshcoreInterface.py`, which will make
    loading file. This is case sensitive! So either rename the file or
    change the type to:
    
        type = MeshcoreInterface
    
    The above instructions are correct and should work, but you will
    fail if you copy directly from upstream.

In the above configuration, we connect RNS to a Meshcore companion
over "serial" (USB) and specify the given port. It *may* be
`/dev/ttyACM0` as well on some devices. It might be possible to make
this work with Bluetooth as well, but we found serial to be much
easier.

For this to work, you need to have a "companion" flashed with
Meshcore. You can follow our [Meshcore flashing guide](meshcore.md#flash-the-firmware-on-the-device), just make
sure you pick "serial" and not "Bluetooth".

!!! bug

    Some applications like MeshChatX will fail to load the `meshcore`
    library because it cannot be found. This is often related to the
    sandboxing some of those applications.
    
    One workaround is to install the Debian package instead.
    
    Or it's also possible to hijack the load path inside the interface
    itself.
    
    We have had success adding something similar to this to the top of
    the interface Python file (`MeshcoreInterface.py`):
    
        import sys
        sys.path.insert(0, "/usr/lib/python3/dist-packages/")
        sys.path.insert(0, "/home/anarcat/.venvs/reticulum/lib/python3.13/site-packages/")

If both endpoints are configured this way, they should be able to send
an announce (see below), see each other, and exchange text messages
and so on.

### Basic RNS tools

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

## LXMF-CLI

Since a basic RNS setup like the above does not do much on its own, we
will introduce you to a first basic chat application.

If you are familiar with the command-line, [LXMF-CLI](https://github.com/fr33n0w/lxmf-cli) is a nice and
simple chat client. When starting, it will prompt you for your
identity and some settings, then it will announce your identity on the
network through `rnsd`.

If other identities are found through announces, it will notify you
and you will be able to add them as contacts. For example:

```
📡 New Announce: newfriend
🔗 <a18d35e7e283b3e95158c5412ac58b4c>
💡 Quick save: 'ap 1' | Send: 'sp 1 <msg>'
> ap 1
✓ Contacts saved
✓ Added contact: newfriend
  Display name: My New Friend
> sp 1 found you!
Sending to peer #1: My New Friend
📤 Sending to: My New Friend...

✅ Delivered to My New Friend (0.5s)
```

The interface is otherwise pretty intuitive, use `h` or `help` for
usage. A few useful commands:

- `ann` or `announce`: announce your presence on the mesh, required
  for others to message you, if you are new or changed place
- `p` or `peers`: show the currently visible peers
- `c` or `contacts`: show contact list
- `s` or `send`: send a message to a user
- `reply` or `re`: reply to a user that just came in

## Transport nodes and microReticulum

All of the above is about "clients", in the sense that most of the
software is geared towards new users, and rightly so.

But we did not talk much about routing, which is a core tenant of mesh
networks of course. That's because there is a separate feature to
enable on a RNode to enable that, it's called a "transport".

Because the devices we have setup, so far, all require a client like a
computer, it makes this all inconvenient to host on your rooftop.

Thankfully people figured out a solution to this problem and starting
expanding RNode to support routing, into something called an RTNode,
for "Reticulum Transport Node".

Cleeyv wrote an [excellent guide on how to setup the RTNode
firmware](https://rns.recipes/forum/build-guides/how-to-install-and-test-the-rtnode-firmware), which we'll defer to.

Our only addition is that we had to put the device in upload mode, by
holding the "BOOT" (actually labeled `PGR` on the board) button while
pressing "RESET" (`RST`), before running the `flash.py` command.
