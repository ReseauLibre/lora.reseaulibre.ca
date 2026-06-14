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

On Meshtastic, this can be done by exporting the configuration in the
Meshtastic app settings, or with the [Meshtastic command line
tool](https://meshtastic.org/docs/software/python/cli/):

    meshtastic --export-config > devicename.yaml

### Flash the firmware on the device

First you need to [flash your device](https://flasher.meshcore.io), which essentially means
connecting to the following website.

<https://flasher.meshcore.io>

Your web browser must support the [Web Serial API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Serial_API#browser_compatibility), which includes
Chrome (and derivatives) and Firefox 151 or later.

You *may* skip this step if it comes flashed with Meshcore already.

!!! important

    This is the moment when you pick between Companion and Repeater,
    and you can't go back without reflashing!

    You will also have the option to flash a "Bluetooth" of "Serial"
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

!!! bug

    We have had trouble flashing RAK4631 device. You can:
    
     1. download the `U2F` file
     2. put the device in "DFU" mode
     3. mount it
     4. copy the file on the disk
     5. unmount

    This can also be done automatically with this
    [reflashtic](https://gitlab.com/anarcat/scripts/-/blob/main/reflashtic.py?ref_type=heads)
    command:
    
        reflashtic.py --pmount -i RAK_4631_companion_radio_ble-v1.15.0-dee3e26.uf2

    The [`adafruit-nrfutil`](https://github.com/adafruit/Adafruit_nRF52_nrfutil)
    command can also apparently be used for this.

During first boot, the device will display the message:

    Loading...

... for a solid minute, that is normal.

#### Repeater configuration

If you are configuring a repeater, this is also the step where you
configure the repeater through the [web
interface](https://config.meshcore.io/). *Some* settings can be performed
over Bluetooth later.
    
You need to at least:

 1. set a name to the router: the local convention is to use a `YUL-`
    prefix and the general location of the router, e.g. `YUL-Villeray`
    or `YUL-Parc-Extension`
     
 2. set an admin password and save it to your password manager for
    remote administration

The remaining settings can be done over Bluetooth from a companion,
which we'll assume below.

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

#### Flashing an observer

If you want to setup an "observer", you should head over to the
[`observer.gessaman.com` flasher](https://observer.gessaman.com/) and flash that firmware
instead. It will flash a custom firmware that automatically connects
to WiFi and MQTT to relay packet data.

You should *not* flash an observer if there is already one in your
local area. As a rule of thumb, if you're multiple hops from the
nearest observer, or it's far enough that it doesn't see *your*
traffic, it's a good idea to set one up. Otherwise, we might not need
your observer!

You can setup the observer as a Room Server if you want one of those
in your area, but similarly, we might not need one of those if there
is already one around.

In any case, it's likely not necessary to setup the observer as a
"repeater" unless it's the only repeater in your area. In that case,
either set it up as a room server or as a repeater with repeat turned
off. This will help reduce the noise on the mesh.

#### Boot loader OTA fix

!!! example "Advanced users only"

    This section is a little more advanced and not required for beginners.

You might want to flash upgrades "over the air" (OTA) if your device
is in a hard to reach location. There are problems with built-in
boot loaders for this, so it is recommended to flash this [alternative
boot loader](https://github.com/oltaco/Adafruit_nRF52_Bootloader_OTAFIX). 

For that, you need to flash a custom boot loader, *before* you install
the device in the remote location:

 1. find and download the right device file in the last release of the
    [release list](https://github.com/oltaco/Adafruit_nRF52_Bootloader_OTAFIX/releases), which should end in a `.uf2`, for example in
    the [current release](https://github.com/oltaco/Adafruit_nRF52_Bootloader_OTAFIX/releases/tag/0.9.2-OTAFIX2.2-BP1.3) the SenseCAP Solar P1 file is the
    [`update-sensecap_solar_p1_bootloader-0.9.2-OTAFIX2.2-BP1.3_nosd.uf2`](https://github.com/oltaco/Adafruit_nRF52_Bootloader_OTAFIX/releases/download/0.9.2-OTAFIX2.2-BP1.3/update-sensecap_solar_p1_bootloader-0.9.2-OTAFIX2.2-BP1.3_nosd.uf2)

 2. connect the device to your computer over USB

 3. put the device in DFU mode, which typically involves
    double-clicking on the reset button (clicking twice within 500ms)

 4. mount the device that appears

 5. copy the `.uf2` file to the device

This should take only a short time and reboot the device.


#### OTA upgrades

!!! example "Advanced users only"

    Over-the-air (OTA) upgrades are risky and should be used only if
    remote access is inconvenient, or if you have a secondary device
    to run a first test run on.
    
    Beginners shouldn't need to follow those instructions.
    
    You should also *not* do your initial flash over the air, it's not
    worth it! 
    
    Only use this for upgrades and *only* if you performed the above
    [Bootloader OTA fix](#boot-loader-ota-fix)!

Once your device is correctly flashed for OTA (over the air) upgrades,
you should be able to perform upgrades remotely, by following [this
official guide](https://blog.meshcore.io/2026/04/02/nrf-ota-update) or the [Ottawa Mesh guide](https://ottawamesh.ca/meshcore/update-repeater-ota/). A few tips:

 - if you have a custom Android firmware, you might not have access to
   the App store and the [nRF Device Firmware Update app](https://play.google.com/store/apps/details?id=no.nordicsemi.android.dfu&hl=en_US). You can
   add [this GitHub repository](https://github.com/nordicsemi/Android-DFU-Library) to Obtainium instead, which works fine.

 - you *must* change the settings in the app before flashing the
   upgrade, if you get a timeout, it's because the settings are wrong.

 - flashing over Bluetooth is slow, we're seeing 3KB/s transfer speeds

Here is a full procedure, but see the official or Ottawa mesh guide if
it fails (and let us know):

 1. install the [nRF Device Firmware Update app](https://play.google.com/store/apps/details?id=no.nordicsemi.android.dfu&hl=en_US) ([source code](https://github.com/nordicsemi/Android-DFU-Library)
    which can be installed through Obtainium)

 2. configure the right settings in the app which is called `DFU`:
 
     - Packet receipts notification - **ON**
     - Number of packets - **8**
     - Request high MTU (Android only) - **OFF**
     - Disable resume - **ON**
     - Prepare object delay - **0 ms**
     - Force scanning - **ON**

    Leave the other settings untouched.

 3. download the right firmware for your device in the [Meshcore web
    flasher interface](https://flasher.meshcore.io), make sure you pick the `.zip` file!

 4. connect to the device command-line, which should be accessible
    over the LoRa management interface

 5. type the following magic command:

        start ota

    This will show the Bluetooth MAC address of your device, which can
    be used to identify it below.

 6. back in the app, start the update, by tapping `Select` and picking
    the `.zip` file you downloaded earlier

 7. select the device which should show up as something like
    `SENSECAP_SOLAR_OTA` and also show the MAC address above

 8. press start

    This will go through various steps. If you have messed up the
    settings, it will like timeout at the `DFU initialized`
    step. Otherwise it should show a progress bar and transfer rate
    after that.

 9. you're done!

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

- **Radio settings**: "recommended USA / Canada"
- **Display name**: your name,  `YUL-Area` for a repeater, for example
  `YUL-Villeray`, `YUL-Parc-Extension`, etc
- **Region**: do *not* set a region, as we currently do not use one,
  and it will interfere with routing

The "recommended USA / Canada" preset is, at the time of writing, the
following settings:

- **Frequency**: 910.525 MHz
- **Bandwidth**: 62.5 kHz
- **Spreading Factor** (`SF`): 7 or `SF7`
- **Coding Rate** (`CR`): 5 or `CR5`

But you shouldn't need to write those down by hands, generally. Just
pick the recommended preset.

!!! tip

    You can also perform this configuration over the command line:
    
    ```
    set freq 910.525
    set bw 62.5
    set sf 7
    set cr 5
    set name YUL-Area
    ```

### Repeaters can lose track of time

Repeaters can lose their time after reboot.
    
Make sure the repeater has an accurate clock. Companion apps can
be configured to automatically sync the clock on login to
workaround this issue.
    
Repeaters without an accurate clock route packets properly, but
its adverts will be ignored until its time is accurate.

Enabling the GPS on a device can keep the clock in sync at the cost of
a lower battery life.

### Multi-byte repeater configuration

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

### Observer configuration

Assuming you flashed your device with the [`observer.gessaman.com`
flasher](https://observer.gessaman.com/) above, you need to do extra configuration here:

 1. as above, setup the preset:

        set radio 910.525,62.5,7,5

 1. if setup as a repeater and you already have one of those, turn off
    repeat:

        set repeat off

 1. setup the right MQTT servers:

        set mqtt1.preset meshcore-ca-1
        set mqtt2.preset meshcore-ca-2
        set mqtt.iata YUL

 1. setup WiFi credentials:

        set wifi.ssid YourWiFiNetwork
        set wifi.pwd YourWiFiPassword

 1. reboot:

        reboot

See also the [configuration guide](https://observer.gessaman.com/docs.html).

### You made it! Say hi!

At this point, your companion should be properly
configured. Repeaters require a little more work, below.
    
Introduce yourself! Say "hi!" on the "Public" channel. Explain
what device did you setup, where's your general area, what's the
weather like, etc. Be kind, reply to people, participate!

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

#### Public channels

We know about the follow channels currently in use[^1]:

| Name                  | Hex Key                            | Base64                     | Purpose                                                    |
|-----------------------|------------------------------------|----------------------------|------------------------------------------------------------|
| Public                | `8b3387e9c5cdea6ac9e5edbaa115cd72` | `izOH6cXN6mrJ5e26oRXNcg==` | General conversations                                      |
| `#testing`            | `cde5e82cf515647dcb547a79a4f065d1` | `zeXoLPUVZH3LVHp5pPBl0Q==` | Should be used for tests                                   |
| `#wardriving`         | `e3c26491e9cd321e3a6be50d57d54acf` | `48JkkenNMh46a+UNV9VKzw==` | Used by [Meshmapper][] pings                               |
| `#habs`               | `e570409412b40c123b4ab787351ab30b` | `5XBAlBK0DBI7SreHNRqzCw==` | Far from real time game updates and gossip                 |
| `#bots`               | `0d24f5830b449668b8c221759b6c50d2` | `DST1gwtElmi4wiF1m2xQ0g==` | Where to run bots, a bot replies to `test` and `ping`there |
| `#ceuxquimarchemoyen` | `751be125eb7d167e07a95603c9e9a5dd` | `dRvhJet9Fn4HqVYDyeml3Q==` | Another test channel for people who have trouble           |

 [Meshmapper]: https://meshmapper.net/

You should generally not need the hex and Base64 keys. They are only
provided here as a reference for some rate situations where you need
to enter the secret key directly. For example, some standalone
firmware like the T-Deck might require this although you might get
away with popping up the menu to select the <kbd>Enter</kbd> <kbd>#</kbd> option.

[^1]:
    Those hashes were generated with the one-liner:
    
        python -c 'import base64; import hashlib; import sys; bytes = hashlib.sha256(sys.argv[1].encode("utf-8")).digest()[:16]; print(bytes.hex(), base64.b64encode(bytes).decode("utf-8"))' '#testing'

    A more readable version is available as [hashchan.py](hashchan.py).

#### Other channels

See also the channels used in other communities:

- [Puget mesh](https://pugetmesh.org/meshcore/)
- [Switzerland](https://www.meshcore.ch/channels/)

## References

- [Official site](https://meshcore.io/)
- [Wiki](https://deepwiki.com/meshcore-dev/MeshCore)
- [Awesome MeshCore](https://github.com/samuk/awesome-meshcore)
- [Meshcore Canada](https://meshcore.ca/), and [forum](https://forum.meshcore.ca/)
- [our Matrix room](https://matrix.to/#/#reseaulibre-meshcore:matrix.org)
- [Ripple firmware user guide](https://files.liamcottle.net/MeshCore/Documentation/Ripple_User_Guide.pdf)
- [Netherlands guide on how Meshcore routing works](https://www.localmesh.nl/en/meshcore-routing-algorithms/)

### Other software

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
