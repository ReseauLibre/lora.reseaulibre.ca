# Guides
# Getting started with Meshtastic

## Hardware

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

## Software

Once you have some hardware, you need to operate it. Typically, you
[download an app on your phone](https://meshtastic.org/downloads/) ([Android](https://meshtastic.org/docs/software/android/installation/), [iOS](https://meshtastic.org/docs/software/apple/installation/)) and
control the device over Bluetooth. There is also a [command line
client](https://meshtastic.org/docs/software/python/cli/), a [web client](https://meshtastic.org/docs/software/web-client/), and [lots more](https://meshtastic.org/docs/software/).

You might need to [flash firmware](https://flasher.meshtastic.org/) on the device, which requires
connecting the device to your computer (or phone?) and running a
Chrome-derived web browser.

Anarcat wrote an [advanced batch-flashing tool](https://gitlab.com/anarcat/scripts/-/blob/846a0f46978ae7ebb726004b2653e9a25a5e955c/reflashtic.py) if you need to
flash multiple devices, use at your own risk.

## Settings

Those "settings" are crucial to connect to the mesh and *may change in
the future* to adjust with the network conditions:

- In the [LoRa](https://meshtastic.org/docs/configuration/radio/lora/) section of the Meshtastic app:
  - [preset](https://meshtastic.org/docs/overview/radio-settings/#presets): `LongFast` (default, don't change it)
  - [Region](https://meshtastic.org/docs/configuration/radio/lora/#region): `US`, even though we're in Canada, pick the US preset
    because those are the frequencies (902.0 - 928.0 MHz) that apply
    here as well

You should also review those settings:

- [Bluetooth](https://meshtastic.org/docs/configuration/radio/bluetooth/): change the [default PIN](https://meshtastic.org/docs/configuration/radio/bluetooth/#fixed-pin) to some random value and
  keep it in your password manager
- [Device](https://meshtastic.org/docs/configuration/radio/device/): generally do *not* change the [Role](https://meshtastic.org/docs/configuration/tips/#roles): `CLIENT` is
  fine, consider `CLIENT_BASE` if you run a relay, don't change the
  role without reading the [Choosing The Right Device Role](https://meshtastic.org/blog/choosing-the-right-device-role/) guide
- [LoRa](https://meshtastic.org/docs/configuration/radio/lora/)
  - set [Ignore MQTT](https://meshtastic.org/docs/configuration/radio/lora/#ignore-mqtt) to `false`, keep "OK to MQTT" to
    `false`. This keeps traffic from the wider mesh from entering the
    network and reduces overall noise.
- [Position](https://meshtastic.org/docs/configuration/radio/position/): set GPS Mode to `DISABLE`! or [reduce precision](https://meshtastic.org/docs/configuration/radio/channels/#position-precision)
  in the [Channel configuration](https://meshtastic.org/docs/configuration/radio/channels/#position-precision), otherwise you leak your position
  to the network by default
- [User](https://meshtastic.org/docs/configuration/radio/user/):
  - set the "Short Name" to something easy to remember, this is what's
    visible on the map and chats
  - set the "Long Name" to something useful, but not offensive, ham
    operators can set their call sign here

# Other guides

The above is only a primer. Anarcat wrote a [lot more](https://anarc.at/services/meshtastic/) that should
probably be progressively migrated here.
