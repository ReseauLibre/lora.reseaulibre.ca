# Repeater guide

This guide should help you configure a Meshcore "repeater", which
makes the mesh grow. You might not need a repeater, look at the
[coverage map](../../references/maps.md) to see if there's coverage in your area.

If there's a nearby repeater and you don't see it with your companion,
a repeater on your roof or window could! Give it a try.

See also the question [Should I install a relay?](../faq.md#should-i-install-a-relay) in the FAQ.

## Hardware

Pick a device in [our hardware review notes](../../references/hardware/index.md) or the [Meshtastic
hardware list](https://meshtastic.org/docs/hardware/devices/)[^1].

[^1]: Meshtastic-supported device are *often* (but not always!) also
      working under Meshcore.

It's cheap! Expect to pay 50$CAD for a development kit, 150$CAD for a
decent solar relay.

!!! tip

    If the device you picked comes with a removable antenna, make sure
    you connect the antenna before powering up the device. A radio
    that transmits without an antenna can damage itself!

## Software

<!-- note that this paragraph is a copy of the companion.md page, -->
<!-- update both at once -->

Now you own a [LoRa](https://en.wikipedia.org/wiki/LoRa) transceiver, congratulations! The next step is
to make sure it runs Meshcore by installing firmware on it, and that
you can talk to the device, typically by installing an app on your
phone.

### Flash the firmware on the device

<!-- note that this section is a copy of the companion.md page, -->
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

During first boot, the device will display the message, if it has a display:

    Loading...

... for a solid minute, that is normal. If it doesn't have a display,
think about how it will stall for a minute.

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

See [upgrades](upgrades.md).

### Backing up before flashing

You *might* want to backup the router configuration before flashing,
but this is less critical than the companion as there's less
configurations (e.g. channels, contacts, are not present) than on
companions.

Still, keeping a backup of the repeater key is a good idea, you can
follow the [companion backup
procedure](companion.md#backing-up-before-flashing).

## Configuration

A repeater is configured through a [web interface](https://config.meshcore.io/). *Some* settings
can be performed over Bluetooth later.

!!! warning

    Some Meshcore configurations exposes your location by default on devices which have
    a GPS device! To work around this problem, you can disable the GPS
    or reduce the [coordinates
    precision](https://wiki.openstreetmap.org/wiki/Precision_of_coordinates),
    we recommend two digits (~1km) for clients and 3 digits (~100m)
    for repeaters.

You need to at least:

- **Radio settings**: "recommended USA / Canada"
- **Display name**: your name,  `YUL-Area` for a repeater, for example
  `YUL-Villeray`, `YUL-Parc-Extension`, etc
- **Region**: do *not* set a region, as we currently do not use one,
  and it will interfere with routing
- **Admin password**: set a [strong password](https://anarc.at/blog/2017-02-18-passwords-entropy/) and save it to your
  password manager for remote administration
- **Path hash mode**: pick `3-byte (2)`, see [multi-byte path
  routing](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#39-q-what-is-multibyte-support-what-do-1-byte-2-byte-3-byte-adverts-and-messages-mean) for details
- **Send an advert!** by default, repeaters do automatically send
  adverts, but it can take *hours*, during which time your companion
  won't see the repeater! so do send one manually

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

The "recommended USA / Canada" preset is, at the time of writing, the
following settings:

- **Frequency**: 910.525 MHz
- **Bandwidth**: 62.5 kHz
- **Spreading Factor** (`SF`): 7 or `SF7`
- **Coding Rate** (`CR`): 5 or `CR5`

But you shouldn't need to write those down by hands, generally. Just
pick the recommended preset. See [the frequencies question](../faq.md#which-radio-frequencies-are-you-using) for
details.

!!! tip

    You can also perform this configuration over the command line:
    
    ```
    set freq 910.525
    set bw 62.5
    set sf 7
    set cr 5
    set name YUL-Area
    set path.hash.mode 2
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

At this point, your repeater should be properly configured.

Try to connect to the repeater from your companion to "administer"
it. If you don't see the repeater, try connecting it to the
configuration interface again and send an advert.

Send a message from your companion, which should go through the
mesh. Maybe you'll get better (or worse!) reliability and coverage!

After a while, you should see also some neighbors and improve the
range and health of the mesh!

Even if you don't see anything yet, wait a while, you might be a trail
blazer!
