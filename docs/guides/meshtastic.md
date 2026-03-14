---
tags:
  - traduction/complète
---

# Premiers pas avec Meshtastic

Getting started with running a Meshtastic relay is easy. You need to
buy some hardware, install an app, and tweak some settings.

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

Tous ces appareils nécessitent un téléphone équipé de l'application Meshtastic pour fonctionner :

- **Le moins cher** : [Heltec v3](https://heltec.org/project/wifi-lora-32-v3/), assurez-vous d'acheter une
  boîtier et le 902-928 MHz, vous devez fournir l'alimentation via
  USB, n'importe quel chargeur USB-C conviendra, 20 $ US, a besoin
  d'une app, par exemple sur votre téléphone
- **Plus efficace** : [WisBlock RAK4631](https://store.rakwireless.com/products/wisblock-meshtastic-starter-kit?variant=43884035113158), meilleure durée de vie
  sur batterie que le Heltec, 25 $ USD, [90 $ avec boîtier et
  batterie](https://store.rakwireless.com/products/wismesh-pocket), a également besoin d'un téléphone
- **Autonome** : [T-Deck plus](https://lilygo.cc/products/t-deck-plus-1), a un écran et un clavier (oui, ça
  ressemble à un [BlackBerry](https://en.wikipedia.org/wiki/BlackBerry)), utile si vous ne voulez pas
  utiliser votre téléphone, 80 $
- **Relais solaire** : [WishMesh Solar Repeater Mini](https://store.rakwireless.com/products/wishmesh-meshtastic-solar-repeater-mini), 100$USD, à
  mettre sur son toit ou dans un arbre, considérer égalment le
  (non-testé) [SenseCAP Solar Node P1](https://www.seeedstudio.com/SenseCAP-Solar-Node-P1-for-Meshtastic-LoRa-p-6425.html) 90 $ USD

[Faites-nous](../contact.md) savoir si vous souhaitez en acheter en grande
quantité afin que nous puissions nous organiser.

Voir également la [liste officielle du matériel](https://meshtastic.org/docs/hardware/devices/) et [l'avis d'anarcat](https://anarc.at/services/meshtastic/#hardware).

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

Anarcat a écrit un [outil avancé de flashage par lots](https://gitlab.com/anarcat/scripts/-/blob/846a0f46978ae7ebb726004b2653e9a25a5e955c/reflashtic.py) si vous avez besoin de
flasher plusieurs appareils, à utiliser à vos propres risques.

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

    | Paramètre                    | Valeur       | Remarque                                                                                                                              |
    |----------------------------|-------------|---------------------------------------- -------------------------------------------------------------------------------------------|
    | [Bluetooth][] : PIN         | (aléatoire)    | remplacez le [PIN par défaut][] par une valeur aléatoire et conservez-la dans votre gestionnaire de mots de passe                                              |
    | [Appareil][] :  [Rôle][]      | `CLIENT`    | envisagez `CLIENT_BASE` si vous utilisez un relais, ne modifiez pas le rôle sans avoir lu le guide [Choisir le bon rôle pour votre appareil][]     |
    | [LoRa][]: [Ignorer MQTT][]  | `true`      | cela empêche le trafic provenant du maillage plus large d'entrer dans le   réseau et réduit le bruit global.                                     |
    | [Position][]: [Mode GPS][] | `DISABLE`   | ou réduisez la [Précision de la position][] dans la [Configuration du canal][], sinon vous divulguez votre position au réseau par défaut |
    | [Utilisateur][] : « Nom court »     | (arbitraire) | 4 caractères maximum, choisissez un nom facile à retenir, c'est ce qui sera visible sur la carte et dans les chats                                 |
    | Utilisateur : « Nom long »          | (arbitraire) | choisissez un nom utile, mais pas offensant, les opérateurs radioamateurs peuvent définir leur indicatif d'appel ici                                            |
    
     [Bluetooth]: https://meshtastic.org/docs/configuration/radio/bluetooth/
     [Configuration des canaux]: https://meshtastic.org/docs/configuration/radio/channels/#position-precision
     [Choisir le bon rôle pour votre appareil]: https://meshtastic.org/blog/choosing-the-right-device-role/
     [Appareil]: https://meshtastic.org/docs/configuration/radio/device/
     [LoRa]: https://meshtastic.org/docs/configuration/radio/lora/
     [Position]: https://meshtastic.org/docs/configuration/radio/position/
     [Rôle]: https://meshtastic.org/docs/configuration/tips/#roles
     [Utilisateur]: https://meshtastic.org/docs/configuration/radio/user/
     [Code PIN par défaut]: https://meshtastic.org/docs/configuration/radio/bluetooth/#fixed-pin
     [Précision de la position]: https://meshtastic.org/docs/configuration/radio/channels/#position-precision
     [Ignorer MQTT]: https://meshtastic.org/docs/configuration/radio/lora/#ignore-mqtt
     [Mode GPS]: https://meshtastic.org/docs/configuration/radio/position/#gps-mode
