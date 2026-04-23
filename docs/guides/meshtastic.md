---
tags:
  - traduction/complète
---

# Premiers pas avec Meshtastic

Getting started with running a Meshtastic relay is easy. You need to
buy some hardware, install an app, and tweak some settings.

!!! question

    We are currently reconsidering the use of Meshtastic across the
    Montreal mesh. Right now, there are dozens if not hundreds of
    devices, but no one can seem to speak with anyone. There's mostly
    noise, and some believe we have grown past the scalability of
    Meshtastic.
    
    We are now focusing on building Meshcore infrastructure, see our
    [Getting started with Meshcore](meshcore.md) guide instead.

You can expect to communicate through text with other relays within a
few kilometres without even setting up a special antenna or location.

!!! avertissement

    Meshtastic expose votre position par défaut sur les appareils
    ayant une composante GPS ! Assurez vous que la
    [précision de la position][] est réduite ou réglez le [mode GPS][] sur `DISABLED`.

!!! tip

    Also keep in mind that the hardware address of devices is used
    routing in Meshtastic. Every message from a device includes that
    address which is unique and cannot be changed, see [this feature
    request][] for details. This is a bit like [IMEI identifiers on
    phones][]. Meshcore and Reticulum do not suffer from this issue.

[this feature request]: https://github.com/meshtastic/firmware/discussions/5007
[IMEI identifiers on phones]: https://en.wikipedia.org/wiki/International_Mobile_Equipment_Identity

### Matériel

Choisissez un appareil dans [notre liste d'appareils](../references/hardware/index.md) ou la
[list officielle](https://meshtastic.org/docs/hardware/devices/).

C'est pas cher! Attendez vous à payer 50$CAD pour un kit de base, et
150$CAD pour un relai solaire.

!!! Conseil

    Si l'appareil que vous avez choisi est équipé d'une antenne amovible, veillez à
    la connecter avant de mettre l'appareil sous tension. Une radio
    qui émet sans antenne peut s'endommager !

### Logiciel

Une fois que vous disposez du matériel, vous devez le faire fonctionner. En général, vous
[téléchargez une application sur votre téléphone](https://meshtastic.org/downloads/) ([Android](https://meshtastic.org/docs/software/android/installation/), [iOS](https://meshtastic.org/docs/software/apple/installation/)) et
contrôlez l'appareil via Bluetooth. Il existe également un [client en ligne de commande
](https://meshtastic.org/docs/software/python/cli/), un [client web](https://meshtastic.org/docs/software/web-client/) et [bien d'autres encore](https://meshtastic.org/docs/software/).

Vous devrez peut-être [flasher le micrologiciel](https://flasher.meshtastic.org/) sur l'appareil, ce qui nécessite de
connecter l'appareil à votre ordinateur (ou téléphone ?) et d'utiliser un
navigateur web dérivé de Chrome.

D'autres [projets](../references/software/index.md) sont également documentés dans notre [index logiciel](../references/software/index.md).

### Paramètres

Cette section décrit les différents paramètres que nous recommandons dans l'application Meshtastic.

!!! info

    Les deux paramètres ci-dessous sont essentiels pour se connecter au réseau maillé. Si
    ils ne sont pas configurés correctement, vous ne pourrez rien voir.

| Paramètre          | Valeur       | Remarque                                                                                                                          |
|------------------|-------------|------------------------------------------------------------------ -------------------------------------------------------------|
| [Préréglage du modem][] | `LONG_FAST` | par défaut, ne le modifiez pas (pour l'instant)                                                                                            |
| [Région][]       | `US`        | même si nous sommes au Canada, choisissez le préréglage US car ce sont les fréquences (902,0 - 928,0 MHz) qui s'appliquent ici également |

 [Région]: https://meshtastic.org/docs/configuration/radio/lora/#region
 [Préréglage du modem]: https://meshtastic.org/docs/overview/radio-settings/#presets

!!! note "Optionnel"

    Ces paramètres sont facultatifs, mais recommandés.

    | Setting                    | Value       | Note                                                                                                                              |
    |----------------------------|-------------|-----------------------------------------------------------------------------------------------------------------------------------|
    | [Bluetooth][]: PIN         | (aléatoire)    | remplacez le [PIN par défaut][] par une valeur aléatoire et conservez-la dans votre gestionnaire de mots de passe                                              |
    | [Device][]:  [Role][]      | `CLIENT`    | envisagez `CLIENT_BASE` si vous utilisez un relais, ne modifiez pas le rôle sans avoir lu le guide [Choisir le bon rôle pour votre appareil][]     |
    | [LoRa][]: [Ignore MQTT][]  | `true`      |  cela empêche le trafic provenant du maillage plus large d'entrer dans le   réseau et réduit le bruit global.                                     |
    | [LoRa][]: [Max hops][]     | 3           | default. you *can* raise this if you really think it might help you reach further, but we generally advise against it |
    | [Position][]: [GPS Mode][] | `DISABLE`   | ou réduisez la [Précision de la position][] dans la [Configuration du canal][], sinon vous divulguez votre position au réseau par défaut[^1] |
    | [User][]: "Short Name"     | (arbitraire) |  4 caractères maximum, choisissez un nom facile à retenir, c'est ce qui sera visible sur la carte et dans les chats                                 |
    | User: "Long Name"          | (arbitraire) | choisissez un nom utile, mais pas offensant, les opérateurs radioamateurs peuvent définir leur indicatif d'appel ici                                            |

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
