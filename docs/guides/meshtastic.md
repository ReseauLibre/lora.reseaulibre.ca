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

--8<-- "docs/references/hardware/.recommendations.md"

See also the [official hardware list](https://meshtastic.org/docs/hardware/devices/) and [our hardware review
notes](../references/hardware/index.md) for more options.

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

More [projects](../references/software/index.md) are also
documented in our [software index](../references/software/index.md).

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
    | [LoRa][]: [Ignore MQTT][]  | `true`      | this keeps traffic from the wider mesh from entering the network and reduces overall noise.                                     |
    | [LoRa][]: [Max hops][]     | 3           | default. you *can* raise this if you really think it might help you reach further, but we generally advise against it |
    | [Position][]: [GPS Mode][] | `DISABLE`   | or reduce the [Position precision][] in the [Channel configuration][], otherwise you leak your position to the network by default[^1] |
    | [User][]: "Short Name"     | (arbitrary) | only 4 characters, set to something easy to remember, this is what's visible on the map and chats                                 |
    | User: "Long Name"          | (arbitrary) | set to something useful, but not offensive, ham operators can set their call sign here                                            |

[^1]: Note that setting it to `NOT_PRESENT` will also improve boot time on devices without GPS.

 [Bluetooth]: https://meshtastic.org/docs/configuration/radio/bluetooth/
 [Channel configuration]: https://meshtastic.org/docs/configuration/radio/channels/#position-precision
 [Choosing The Right Device Role]: https://meshtastic.org/blog/choosing-the-right-device-role/
 [Device]: https://meshtastic.org/docs/configuration/radio/device/
 [LoRa]: https://meshtastic.org/docs/configuration/radio/lora/
 [Max hops]: https://meshtastic.org/docs/configuration/radio/lora/#max-hops
 [Position]: https://meshtastic.org/docs/configuration/radio/position/
 [Role]: https://meshtastic.org/docs/configuration/tips/#roles
 [User]: https://meshtastic.org/docs/configuration/radio/user/
 [default PIN]: https://meshtastic.org/docs/configuration/radio/bluetooth/#fixed-pin
 [Position precision]: https://meshtastic.org/docs/configuration/radio/channels/#position-precision
 [Ignore MQTT]: https://meshtastic.org/docs/configuration/radio/lora/#ignore-mqtt
[GPS Mode]: https://meshtastic.org/docs/configuration/radio/position/#gps-mode

## Advanced: batch configuration

If you feel adventurous and want to make the above configuration
easier, you can use the following YAML file -- let's call it
`minimal.yaml` -- for the minimal configuration:

```yaml
config:
  lora:
    region: US
    modemPreset: LONG_FAST
```

This can be loaded with:

    meshtastic --configure minimal.yaml

Then, the "recommended" settings (above) can be configured with the
`meshtastic` command again:

```
meshtastic --set bluetooth.fixedPin 123456
meshtastic --set bluetooth.mode FIXED_PIN
meshtastic --set lora.hopLimit 3
meshtastic --set lora.ignoreMqtt true
meshtastic --set position.gpsMode NOT_PRESENT
meshtastic --set device.role CLIENT
meshtastic --set-owner "you only live once"
meshtastic --set-owner-short yolo
```

!!! bug

    Note that the order of commands matter here. Some configuration,
    like `device.role CLIENT` will reboot the device, and will make
    further commands fail. That is why the setting is last here. Using
    a config file solves that problem entirely, as all settings are
    set at once.

!!! tip

    You should really set a random PIN here, not 123456, because that
    is the [stupidiest combination ever](https://www.youtube.com/watch?v=LcHnf7VQuhc). You can
    generate such a "random" pin with:
    
        shuf -i 100000-1000000 -n 1

    Also please change away from the "yolo" user above, otherwise
    we'll get confused quick as yo who "yolo" is.

This can of course also be done in a configuration file that we'll
call `recommended.yaml`:

```yaml
config:
  bluetooth:
    fixedPin: 123456
    mode: FIXED_PIN
  device:
    role: CLIENT
  lora:
    hopLimit: 3
    ignoreMqtt: true
  position:
    gpsMode: NOT_PRESENT
owner: you only live once
owner_short: yolo
```

!!! tip

    Note that you *can* set the `CLIENT_BASE` role as well but your `meshtastic`
    command might not know about it so you need to specify it as an
    magic number:

        meshtastic --set device.role 12

Once you're done, you might want to backup your configuration with:

    meshtastic --export-config > backup.yaml
