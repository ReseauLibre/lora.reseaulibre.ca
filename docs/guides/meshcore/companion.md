# Companion guide

This guide should help you configure a Meshcore "companion", which you
need to communicate with other people on the mesh.

Companions *must* be able to talk with a repeater connected to the
mesh to talk with other companions, unless companions are within
range. If there's no repeater in your area, you should consider
setting one up following the [repeater guide](repeater.md)!

## Hardware

Pick a device in [our hardware review notes](../../references/hardware/index.md) or the [official
hardware list](https://meshtastic.org/docs/hardware/devices/).

It's cheap! Expect to pay 50$CAD for a starter kit or 100$CAD for a
good companion.

!!! tip

    If the device you picked comes with a removable antenna, make sure
    you connect the antenna before powering up the device. A radio
    that transmits without an antenna can damage itself!

## Software

<!-- note that this paragraph is a copy of the reppeater.md page, -->
<!-- update both at once -->

Now you own a [LoRa](https://en.wikipedia.org/wiki/LoRa) transceiver, congratulations! The next step is
to make sure it runs Meshcore by installing firmware on it, and that
you can talk to the device, typically by installing an app on your
phone.

### Flash the firmware on the device

<!-- note that this section is a clone of the repeater.md page, -->
<!-- update both at once -->

First you need to [flash your device](https://flasher.meshcore.io), which essentially means
connecting to the following website.

<https://flasher.meshcore.io>

Your web browser must support the [Web Serial API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Serial_API#browser_compatibility), which includes
Chrome (and derivatives) and Firefox 151 or later.

You *may* skip this step if it comes flashed with Meshcore already.

Connect your device to your computer using a USB cable. Note that for
some USB-C cables, you might need to flip the cable over for the
connection to work. A good hint is whether the device is charging or
not from your laptop: if it isn't, it means it likely isn't connected
correctly.

On many devices, you need to enter some special mode for flashing to
work. Here are examples:

- Heltec: hold the "program" (`PRG`) button while connecting
  the USB cable. For the Heltec v4, it will show up as a `JTAG`
  device. On the Heltec v3, it will show up as a `CP2102 USB to UART
  Bridge Controller`.

- RAK: double-click the reset button will bring it in "DFU" mode, but
  the web flasher should also be able to do that automatically.

!!! important

    You will  have the option to flash a "Bluetooth" of "Serial"
    companion. You should typically choose "Bluetooth" unless you want
    to connect to the device over the USB cable. Those are exclusive:
    a Bluetooth device cannot be accessed over serial and vice-versa.

!!! bug "Proprietary software warning"

    While most Meshcore firmware is free software (the
    [`meshcore-dev/MeshCore`
    repository](https://github.com/meshcore-dev/MeshCore), the [T-Deck
    firmware is
    proprietary](https://docs.meshcore.io/faq/#57-q-is-meshcore-open-source). [Awesome
    MeshCore lists a few alternatives](https://github.com/samuk/awesome-meshcore#free-and-open-source-firmware).

During first boot, the device will display the message:

    Loading...

... for a solid minute, that is normal.

### Backing up before flashing

If you're flashing an already configured device, you should backup
before flashing it.

On the Meshcore you want to:

 1. go into Settings (the "gear" icon)
 2. go into `Export Config`
 3. hit `Select All`
 4. hit the check mark
 5. save the file somewhere safe

Normally, flashing a Meshcore device with a newer version should be
safe and your settings should be kept, but it's always good to backup
your configuration anyways, and this can be used to copy your
configuration to another device as well.

If you're flashing over a Meshtastic device, backups can be done by
exporting the configuration in the Meshtastic app settings, or with
the [Meshtastic command line tool](https://meshtastic.org/docs/software/python/cli/):

    meshtastic --export-config > devicename.yaml

### Install an app

Unless you picked a standalone device, now you'll need something to
talk with people on the mesh. Unless you use a standalone device, this
means installing software on your phone.

You can try that from your computer with a web browser by using [Liam
Cottle's](https://app.meshcore.nz/) web app. There are also [iOS and Android versions](https://meshcore.io/#download) and
a pretty good Linux desktop app called [Meshy](https://codeberg.org/sesivany/meshy).

!!! bug "Proprietary software warning"

    The official Meshcore app is [proprietary software](https://en.wikipedia.org/wiki/Proprietary_software) that do not
    publish their source code and require a subscription or a 10 second
    wait time for certain features.
    
    You can work around some of those problems by installin the [open
    app](https://github.com/zjs81/meshcore-open) which requires going through [Obtainium](https://obtainium.imranr.dev/) on Android or
    [test flight](https://github.com/zjs81/meshcore-open/issues/375). It's a little complicated, so don't venture there
    unless you get frustrated with the official apps. The open app
    also lacks a few features from the official one, namely:
    
     - [full multibyte support](https://github.com/zjs81/meshcore-open/issues/367)
     - [support for changing the Blutooth PIN](https://github.com/zjs81/meshcore-open/issues/431)
     - [Google Play Store](https://github.com/zjs81/meshcore-open/issues/323) and [F-Droid](https://github.com/zjs81/meshcore-open/issues/113) releases
     - [Reactions are non-standard](https://github.com/zjs81/meshcore-open/issues/109)
     - [Regions support](https://github.com/zjs81/meshcore-open/issues/120)
     - [Channel utilization display](https://github.com/zjs81/meshcore-open/issues/312)
     - [User blocking support](https://github.com/zjs81/meshcore-open/issues/340)

To connect your phone to the device, you need to find the right device
in your list, which can be challenging if you are in an environment
with lots of Bluetooth devices. 

Pick the device name that looks like the alphanumeric identifier
displayed at the top left of the display.

The Bluetooth PIN should also be displayed, bigger, and in the center,
as a string of 6 digits. That is different from the device name, which
will have letters in it, and is only used in pairing.

The device name on the top left, however, identifies the device over
the airwaves, both on the Mesh and Bluetooth.
  
## Configuration

The main configuration you need to do on the device is set the
preset, but you should also pick a display name.

- **Radio settings**: "recommended USA / Canada", see [the frequencies
  question](../faq.md#which-radio-frequencies-are-you-using) for details
- **Display name**: your name,  `YUL-Area` for a repeater, for example
  `YUL-Villeray`, `YUL-Parc-Extension`, etc
- **Region**: do *not* set a region, as we currently do not use one,
  and it will interfere with routing

!!! warning

    Some Meshcore configurations exposes your location by default on devices which have
    a GPS device! To work around this problem, you can disable the GPS
    or reduce the [coordinates
    precision](https://wiki.openstreetmap.org/wiki/Precision_of_coordinates),
    we recommend two digits (~1km) for clients and 3 digits (~100m)
    for repeaters.

### You made it! Say hi!

At this point, your companion should be properly configured.
    
Introduce yourself! Say "hi!" on the "Public" channel.

Explain what device did you setup, where's your general area, what's
the weather like, etc. Be kind, reply to people, participate!

If no one answers, try the `#bots` channel and send `ping` or
`test`. See also the [channels list](channels.md).
