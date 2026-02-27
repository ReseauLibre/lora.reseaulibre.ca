# Guides
## Getting started with Meshtastic

!!! warning

    Meshtastic exposes your location by default! At least reduce the
    [Position precision][] or set the [GPS Mode][] to `DISABLED`.

### Hardware

Those all require a phone with the Meshtastic app to operate:

- **Cheapest**: [Heltec v3](https://heltec.org/project/wifi-lora-32-v3/), make sure to get a case and the
  902-928MHz, you need to provide power over USB, any USB-C charger
  will do (v4 untested and out of stock as of 2026-02-26, v3 common),
  20$USD
- **Next best**: [WisBlock RAK4631](https://store.rakwireless.com/products/wisblock-meshtastic-starter-kit?variant=43884035113158), doesn't ship with a case,
  25$USD, [90$ with a case and battery](https://store.rakwireless.com/products/wismesh-pocket)
- **Standalone**: [T-Deck plus](https://lilygo.cc/products/t-deck-plus-1), looks like a blackberry, 80$
- **Solar relay**: [SenseCAP Solar Node P1](https://www.seeedstudio.com/SenseCAP-Solar-Node-P1-for-Meshtastic-LoRa-p-6425.html): 90$USD, untested

Those are not formally recommended, but should give you a good
start. Let us know if you want to buy a lot so we can organize.

See also the [official hardware list](https://meshtastic.org/docs/hardware/devices/) and [anarcat's review](https://anarc.at/services/meshtastic/#hardware).

!!! tip

    If the device you pickd comes with a removeable antenna, make sure
    you connect the antenna before powering up the device. A radio
    that transmits without an antenna can damage itself!

### Software

Once you have some hardware, you need to operate it. Typically, you
[download an app on your phone](https://meshtastic.org/downloads/) ([Android](https://meshtastic.org/docs/software/android/installation/), [iOS](https://meshtastic.org/docs/software/apple/installation/)) and
control the device over Bluetooth. There is also a [command line
client](https://meshtastic.org/docs/software/python/cli/), a [web client](https://meshtastic.org/docs/software/web-client/), and [lots more](https://meshtastic.org/docs/software/).

You might need to [flash firmware](https://flasher.meshtastic.org/) on the device, which requires
connecting the device to your computer (or phone?) and running a
Chrome-derived web browser.

Anarcat wrote an [advanced batch-flashing tool](https://gitlab.com/anarcat/scripts/-/blob/846a0f46978ae7ebb726004b2653e9a25a5e955c/reflashtic.py) if you need to
flash multiple devices, use at your own risk.

### Settings

This section describes various settings we advise in the Meshtastic
app.

!!! info

    The two settings below are crucial to connect to the mesh. If
    those are not configured properly, you will not be able to see anything.

| Setting          | Value       | Note                                                                                                                          |
|------------------|-------------|-------------------------------------------------------------------------------------------------------------------------------|
| [Modem preset][] | `LONG_FAST` | default, don't change it (for now)                                                                                            |
| [Region][]       | `US`        | even though we're in Canada, pick the US preset because those are the frequencies (902.0 - 928.0 MHz) that apply here as well |

 [Region]: https://meshtastic.org/docs/configuration/radio/lora/#region
 [Modem preset]: https://meshtastic.org/docs/overview/radio-settings/#presets

!!! note

    Those settings are optional, but recommended.

| Setting                    | Value       | Note                                                                                                                                  |
|----------------------------|-------------|---------------------------------------------------------------------------------------------------------------------------------------|
| [Bluetooth][]: PIN         | (random)    | change the [default PIN][] to some random value and keep it in your password manager                                                  |
| [Device][]:  [Role][]      | `CLIENT`    | consider `CLIENT_BASE` if you run a relay, don't change the role without reading the [Choosing The Right Device Role][] guide         |
| [LoRa][]: [Ignore MQTT][]  | `false`     | also keep keep "OK to MQTT" to `false`. This keeps traffic from the wider mesh from entering the   network and reduces overall noise. |
| [Position][]: [GPS Mode][] | `DISABLE`   | or reduce the [Position precision][] in the [Channel configuration][], otherwise you leak your position to the network by default     |
| [User][]: "Short Name"     | (arbitrary) | only 4 characters, set to something easy to remember, this is what's visible on the map and chats                                     |
| User: "Long Name"          | (arbitrary) | set to something useful, but not offensive, ham operators can set their call sign here                                                |

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

## Other guides

The above is only a primer. Anarcat wrote a [lot more](https://anarc.at/services/meshtastic/) that should
probably be progressively migrated here.
