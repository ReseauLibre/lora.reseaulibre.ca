# Getting started with Meshcore

There are two ways of configuring a Meshcore device:

- a **companion**: this a "client" to the mesh, that needs a repeater
  to relay messages, but that is the primary interface to send and
  receive messages

- a **repeater**: this is the "relay" in the mesh, which transmits
  messages between clients and repeaters and other clients and
  repeaters

If you're just getting started, try a Companion, and we'll assume
you're configuring a Companion for the rest of this guide, unless
otherwise noted.

!!! warning

    Some Meshcore configurations exposes your location by default on devices which have
    a GPS device! To work around this problem, you can disable the GPS
    or reduce the [coordinates
    precision](https://wiki.openstreetmap.org/wiki/Precision_of_coordinates),
    we recommend two digits (~1km) for clients and 3 digits (~100m)
    for repeaters.

## Hardware

Pick a device in [our hardware review notes](../references/hardware/index.md) or the [official
hardware list](https://meshtastic.org/docs/hardware/devices/).

It's cheap! Expect to pay 50$CAD for a starter kit, 150$CAD for a
decent solar relay.

!!! tip

    If the device you picked comes with a removable antenna, make sure
    you connect the antenna before powering up the device. A radio
    that transmits without an antenna can damage itself!

## Software

Now you own a [LoRa](https://en.wikipedia.org/wiki/LoRa) transceiver, congratulations! The next step is
to make sure it runs Meshcore by installing firmware on it, and that
you can talk to the device, typically by installing an app on your
phone.

### Flash the firmware on the device

First you need to [flash your device](https://flasher.meshcore.io), which essentially means
connecting to the following website from a Chrome (or derivative) web
browser:

<https://flasher.meshcore.io>

You *may* skip this step if it comes flashed with Meshcore already.

!!! important

    This is the moment when you pick between Companion and Repeater,
    and you can't go back without reflashing!

!!! tip

    If you are configuring a repeater, this is also the step where you
    configure the repeater through the [web
    interface](https://config.meshcore.io/). *Some* settings can be performed
    over Bluetooth later.
    
    You need to at least:
    
     1. set a name to the router: the local convention is to use a
     `YUL-` prefix and the general location of the router,
     e.g. `YUL-Villeray` or `YUL-Parc-Extension`
     
     2. set an admin password and save it to your password manager for
     remote administration

     The remaining settings can be done over Bluetooth from a
     companion, which we'll assume below.

!!! tip

    Many settings can be done over a serial port, if you're an
    advanced user. You can connect to the serial port on Linux with
    tio:
    
        tio /dev/ttyUSB0

    Then the above commands are:
    
        set name YUL-Villeray
    
    You can also connect to your devices with the
    [`meschore-cli`](https://github.com/meshcore-dev/meshcore-cli)
    program. The full command line reference is [available in the
    upstream documentation](https://docs.meshcore.io/cli_commands/).

### Install an app

Unless you picked a standalone device, now you'll need something to
talk with people on the mesh. Unless you use a standalone device, this
means installing software on your phone.

You can try that from your computer with a web browser by using one of
the web-based apps: [Liam Cottle's](https://app.meshcore.nz/). There are also
[iOS and Android versions](https://meshcore.io/#download).

!!! bug "A warning about proprietary software"

    Both official Meshcore apps are [proprietary software](https://en.wikipedia.org/wiki/Proprietary_software) that do not
    publish their source code and require a subscription or a 10 second
    wait time for certain features.
    
    You can work around some of those problems by installin the [open
    app](https://github.com/zjs81/meshcore-open) which requires going through [Obtainium](https://obtainium.imranr.dev/) on Android or
    [test flight](https://github.com/zjs81/meshcore-open/issues/375). It's a little complicated, so don't venture there
    unless you get frustrated with the official apps (and, honestly, you
    might!).

!!! tip "Backing up Meshtastic before flashing"

    If you're replacing a Meshtastic device, you can backup your
    Meshtastic configuration and keys to restore those if you change your
    mind or want to use that configuration on another device. This can be
    done by exporting the configuration in the Meshtastic app settings, or
    with the [Meshtastic command line tool](https://meshtastic.org/docs/software/python/cli/):

        meshtastic --export-config > devicename.yaml

## Configuration

The main configuration you need to do on the device is set the
"region".

The Montreal mesh uses the "recommended USA / Canada" preset:

- **Frequency**: 910.525 MHz
- **Bandwidth**: 62.5 kHz
- **Spreading Factor** (`SF`): 7 or `SF7`
- **Coding Rate** (`CR`): 5 or `CR5`

You shouldn't need to write those down by hands, generally. Just pick
the recommended preset.

!!! tip

    You can also perform this configuration over the command line:
    
    ```
    set freq 910.525
    set bw 62.5
    set sf 7
    set cr 5
    ```

!!! success "You made it! Say hi!"

    At this point, your companion should be properly
    configured. Repeaters require a little more work, below.
    
    Introduce yourself! Say "hi!" on the "Public" channel. Explain
    what device did you setup, where's your general area, what's the
    weather like, etc. Be kind, reply to people, participate!

!!! note "Multi-byte repeater configuration"

    On a repeater, you should also configure the router identifier for
    [multi-byte path routing](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#39-q-what-is-multi-byte-support--what-do-1-byte-2-byte-3-byte-adverts-and-messages-mean), specifically for three bytes, which is
    called "mode 2". For this, you need to enter the "command line" mode
    and enter the command:
    
        set path.hash.mode 2
    
    You can confirm the current mode with:
    
        get path.hash.mode
    
    And some relays require a reboot for the change to take effect:
    
        reboot
    
    Others have reported having to do the change *twice* for it to take
    effect as well.

!!! bug "Repeaters can lose track of time"

    Repeaters can lose their time after reboot.
    
    Make sure the repeater has an accurate clock. Companion apps can
    be configured to automatically sync the clock on login to
    workaround this issue.
    
    Repeaters without an accurate clock route packets properly, but
    its adverts will be ignored until its time is accurate.

### Channels

If you want to go a little further, you should know that Meshcore
supports the concept of "channels" which are essentially different
communities separated by their own private keys.

Many of those are "public", in the sense that the encryption key is
derived from an easy to guess name, like `#testing`, so those are not
"really" encrypted.

But you can use channels to really create your own secret
communication channels. Contents will be encrypted as long as the
channel name remains secret, but who is talking to who, the number of
messages sent will be visible to an attacker.

### Public channels

We know about the follow channels currently in use:

| Name          | Hex Key                            | Base64                     | Purpose                                     |
|---------------|------------------------------------|----------------------------|---------------------------------------------|
| Public        | `8b3387e9c5cdea6ac9e5edbaa115cd72` | `izOH6cXN6mrJ5e26oRXNcg==` | General conversations                       |
| `#testing`    | `cde5e82cf515647dcb547a79a4f065d1` | `zeXoLPUVZH3LVHp5pPBl0Q==` | Should be used for test                     |
| `#wardriving` | `e3c26491e9cd321e3a6be50d57d54acf` | `48JkkenNMh46a+UNV9VKzw==` | Used by [Meshmapper](https://meshmapper.net/) pings |

You should generally not need the hex and Base64 keys. They are only
provided here as a reference for some rate situations where you need
to enter the secret key directly. (For example, some standalone
firmware like the T-Deck require this.)

See also the channels used in other communities:

- [Puget mesh](https://pugetmesh.org/meshcore/)
- [Switzerland](https://www.meshcore.ch/channels/)
