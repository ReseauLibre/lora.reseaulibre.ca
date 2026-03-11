# Getting started with Meshtastic

Getting started with running a Meshtastic relay is easy. You need to
buy some hardware, install an app, and tweak some settings.

You can expect to communicate through text with other relays within a
few kilometres without even setting up a special antenna or location.

!!! warning

    Meshtastic exposes your location by default on devices which have
    a GPS device! Make sure the [Position precision][] is reduced or
    set the [GPS Mode][] to `DISABLED`.

!!! tip

    Also keep in mind that the hardware address of devices is used
    routing in Meshtastic. Every message from a device includes that
    address which is unique and cannot be changed, see [this feature
    request][] for details. This is a bit like [IMEI identifiers on
    phones][]. Meshcore and Reticulum do not suffer from this issue.

[this feature request]: https://github.com/meshtastic/firmware/discussions/5007
[IMEI identifiers on phones]: https://en.wikipedia.org/wiki/International_Mobile_Equipment_Identity

## Hardware

We have hands-on experience with those devices and recommend them for
use:

- **Cheapest**: [HELTEC v4](https://heltec.org/project/wifi-lora-32-v4/), make sure to get a case and the
  902-928MHz, you need to provide power over USB, any USB-C charger
  will do, 20$USD, needs a separate app, for example on your phone
- **Low-power**: [WisBlock RAK4631](https://store.rakwireless.com/products/wisblock-meshtastic-starter-kit?variant=43884035113158), longer battery life than
  HELTEC, 25$USD, [90$ with a case and battery](https://store.rakwireless.com/products/wismesh-pocket), also needs a phone
- **Standalone**: [T-Deck plus](https://lilygo.cc/products/t-deck-plus-1), has keyboard and screen (yes, like
  a [BlackBerry](https://en.wikipedia.org/wiki/BlackBerry)), useful if you don't want to use your phone, 80$
- **Solar relay**: [WishMesh Solar Repeater Mini](https://store.rakwireless.com/products/wishmesh-meshtastic-solar-repeater-mini), 100$USD, to put
  on your roof or in a tree, also consider the (untested) [SenseCAP
  Solar Node P1](https://www.seeedstudio.com/SenseCAP-Solar-Node-P1-for-Meshtastic-LoRa-p-6425.html)

[Let us know](../contact.md) if you want to buy a lot so we can organize.

See also the [official hardware list](https://meshtastic.org/docs/hardware/devices/) and [our hardware review
notes](hardware.md) for more options.

!!! tip

    If the device you picked comes with a removable antenna, make sure
    you connect the antenna before powering up the device. A radio
    that transmits without an antenna can damage itself!

## Software

Once you have some hardware, you need to operate it. Typically, you
[download an app on your phone](https://meshtastic.org/downloads/) ([Android](https://meshtastic.org/docs/software/android/installation/), [iOS](https://meshtastic.org/docs/software/apple/installation/)) and
control the device over Bluetooth or a USB cable. Some devices can
also be controlled over WiFi or wired network. There is also a
[command line client](https://meshtastic.org/docs/software/python/cli/), a [web client](https://meshtastic.org/docs/software/web-client/), and [lots more](https://meshtastic.org/docs/software/).

You might need to [flash firmware](https://flasher.meshtastic.org/) on the device, which requires
connecting the device to your computer (or phone?) and running a
Chrome-derived web browser.

Anarcat wrote an [advanced batch-flashing tool](https://gitlab.com/anarcat/scripts/-/blob/846a0f46978ae7ebb726004b2653e9a25a5e955c/reflashtic.py) if you need to
flash multiple devices, use at your own risk.

## Settings

This section describes various settings we advise in the Meshtastic
app.

!!! info

    The two settings below are crucial to connect to the mesh. If
    those are not configured properly, you will not be able to talk to
    anyone else.

| Setting          | Value       | Note                                                                                                                          |
|------------------|-------------|-------------------------------------------------------------------------------------------------------------------------------|
| [Modem preset][] | `LONG_FAST` | default, don't change it (for now)                                                                                            |
| [Region][]       | `US`        | even though we're in Canada, pick the US preset because those are the frequencies (902.0 - 928.0 MHz) that apply here as well |

 [Region]: https://meshtastic.org/docs/configuration/radio/lora/#region
 [Modem preset]: https://meshtastic.org/docs/overview/radio-settings/#presets

!!! note "Optional"

    Those settings are optional, but recommended.

    | Setting                    | Value       | Note                                                                                                                              |
    |----------------------------|-------------|-----------------------------------------------------------------------------------------------------------------------------------|
    | [Bluetooth][]: PIN         | (random)    | change the [default PIN][] to some random value and keep it in your password manager                                              |
    | [Device][]:  [Role][]      | `CLIENT`    | consider `CLIENT_BASE` if you run a relay, don't change the role without reading the [Choosing The Right Device Role][] guide     |
    | [LoRa][]: [Ignore MQTT][]  | `true`      | this keeps traffic from the wider mesh from entering the   network and reduces overall noise.                                     |
    | [Position][]: [GPS Mode][] | `DISABLE`   | or reduce the [Position precision][] in the [Channel configuration][], otherwise you leak your position to the network by default |
    | [User][]: "Short Name"     | (arbitrary) | only 4 characters, set to something easy to remember, this is what's visible on the map and chats                                 |
    | User: "Long Name"          | (arbitrary) | set to something useful, but not offensive, ham operators can set their call sign here                                            |

 [Bluetooth]: https://meshtastic.org/docs/configuration/radio/bluetooth/
 [Channel configuration]: https://meshtastic.org/docs/configuration/radio/channels/#position-precision
 [Choosing The Right Device Role]: https://meshtastic.org/blog/choosing-the-right-device-role/
 [Device]: https://meshtastic.org/docs/configuration/radio/device/
 [LoRa]: https://meshtastic.org/docs/configuration/radio/lora/
 [Position]: https://meshtastic.org/docs/configuration/radio/position/
 [Role]: https://meshtastic.org/docs/configuration/tips/#roles
 [User]: https://meshtastic.org/docs/configuration/radio/user/
 [default PIN]: https://meshtastic.org/docs/configuration/radio/bluetooth/#fixed-pin
 [Position precision]: https://meshtastic.org/docs/configuration/radio/channels/#position-precision
 [Ignore MQTT]: https://meshtastic.org/docs/configuration/radio/lora/#ignore-mqtt
[GPS Mode]: https://meshtastic.org/docs/configuration/radio/position/#gps-mode

