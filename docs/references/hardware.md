# Hardware options

This page documents a certain number of LoRa and Meshtastic hardware
devices we have tested or somehow evaluated. It is of course not
exhaustive, and it is opinionated in the sense that it tries to guide
you towards specific purchases to simplify your life. 

Also, in the main [guide](../guides/meshtastic.md), we *recommend* specific devices, while
here we are more open to suggestions.

## How we classify devices

We have those categories:

!!! success

    Those devices were succesfully tested and used on a daily
    basis. Those devices typically end up on the [main guide](../guides/meshtastic.md).

!!! example "In testing"

    We have our hands on those devices and are testing them. So far,
    they work, but need more testing before they can be promoted to a
    full "success".

!!! question "Untested"

    Those devices are interesting, but we haven't lay our hands on
    them yet.

!!! warning

    We tested those devices, and there are serious caveats against
    using them. Do not order one unless you know what you read an
    understand the note on the device.

!!! failure "Not working"

    We tested those devices, and we recommend against using them entirely.

## Pocket-sized

Those are day-to-day use device, can you can easily carry in a pocket
or a pouch. Those generally have a battery.

!!! success

    - [Heltec v4 pre-built kit, 50-60USD](https://heltec.org/project/wifi-lora-32-v4-expansion-housing/), see also this [Aliexpress
      Heltec v4 kit, 43CAD](https://www.aliexpress.com/item/1005010640444191.html)
    - [WisMesh Pocket V2](https://store.rakwireless.com/products/wismesh-pocket): GNSS, 1.3" OLED, acceleration sensor, power
      button, 3200mAh battery, USB-C powered, 100$
    - [Lilygo T-Deck Plus](https://lilygo.cc/products/t-deck-plus-1) (80$): blackberry-like, standalone device
      with battery, keyboard, trackball, LCD display, 2000mAh battery,
      BLE, WiFi, GPS, MicroSD card reader, microphone/speaker

!!! example "In testing"

    - [XIAO ESP32S3 & Wio-SX1262 Kit](https://www.seeedstudio.com/XIAO-ESP32S3-for-Meshtastic-LoRa-with-3D-Printed-Enclosure-p-6314.html): tiny, cheap, - 40℃ ~ 100℃,
      WiFi 2.4GHz, BLE 5.0 / Mesh, reset/boot button, 22x23x57mm, 37g,
      exposed GPIO ports, no battery, 20$. Good candidate for the
      cheapest kit.
    - [T-Echo](https://lilygo.cc/products/t-echo-lilygo): 200x200 e-ink
      display, NRF52840, GPS, BT 5.0, no wifi, only two
      buttons, NFC, 850mAh battery, temperature/pressure sensor, 55$
    - Seeedstudio [XIAO ESP32S3 & Wio-SX1262 Kit](https://www.seeedstudio.com/XIAO-ESP32S3-for-Meshtastic-LoRa-with-3D-Printed-Enclosure-p-6314.html): tiny, - 40℃ ~
      100℃, WiFi 2.4GHz, BLE 5.0 / Mesh, reset/boot button, 22x23x57mm,
      37g, exposed GPIO ports, cheap (20$), does not ship with
      Meshtastic firmware, needs full erase before reflash or gets
      into a boot loop

!!! warning

    - [SenseCAP Card Tracker T1000-E](https://www.seeedstudio.com/SenseCAP-Card-Tracker-T1000-E-for-Meshtastic-p-5913.html) (40$USD)
      anarcat managed to brick this one, be careful when experimenting
      with it, it can be hard to recover, see [this note](https://anarc.at/services/meshtastic/#bricked).

!!! question "Untested"

    - [T-Deck Pro](https://lilygo.cc/products/t-deck-pro): 3.1" e-ink touch screen, 4G module, WiFi 2.4GHz,
      BLE 5, GPS, TF Card, mic, speaker, keypad, see also the [T5 e-paper
      s3 pro](https://lilygo.cc/products/t5-e-paper-s3-pro)
    - [Muzi](https://muzi.works/) has builds on top of the Heltec, e.g. [this H2T](https://muzi.works/products/h2t-complete-device-heltec-t114-with-gps-running-meshtastic)
      (137CAD) made with a Heltec T114, [this R1 Neo](https://muzi.works/products/r1-neo-complete-meshtastic-device) (123CAD) is
      similar to the WisMesh Pocket, but smaller, better sealed, but more
      expensive

<!-- !!! failure "Not working" -->

## Base stations and solar

Those are bulkier devices that are mounted on a mast or are used as a
back-haul, possibly with a special [antenna](#antennas). The devices may or
many not have batteries.

!!! success

    - [WishMesh Solar Repeater Mini](https://store.rakwireless.com/products/wishmesh-meshtastic-solar-repeater-mini): solar, battery, mast-mountable,
      cheaper than the full repeater below, 100$

!!! example "In testing"

    - [SenseCAP Solar Node P1](https://www.seeedstudio.com/SenseCAP-Solar-Node-P1-for-Meshtastic-LoRa-p-6425.html): 70$USD, outdoors solar-powered relay
      with 4x18650 batteries, nRF4840, BT 5.0, 3 power buttons, 5
      LEDs, USB-C for debug, [recommended by
      nyme.sh](https://nyme.sh/faq/). Note that the base kit doesn't
      ship with the actual batteries, or the GNSS device, for that you
      need the [Pro
      kit](https://www.seeedstudio.com/SenseCAP-Solar-Node-P1-Pro-for-Meshtastic-LoRa-p-6412.html)
      which is 20$ more. Needs to be tested through night and winter.
    - [WisMesh Solar Repeater](https://store.rakwireless.com/products/wismesh-meshtastic-solar-repeater): solar, battery, mast-mountable, unclear
      if it can be setup without solar and if it supports MQTT/ethernet,
      300$, SenseCAP Solar Node P1 might be sturdier and
      cheaper. Works through the night in summer time, needs testing
      through winter.

!!! question "Untested"

    - [WisMesh Ethernet Gateway](https://store.rakwireless.com/products/wismesh-ethernet-gateway): no battery, no solar ([might be
      convertible](https://forum.rakwireless.com/t/ethernet-gateway-with-batteries-solar/14601), but ethernet and PoE, note that [HTTP-based
      management not possible](https://github.com/meshtastic/firmware/issues/2908), so configuration still has to go
      through Bluetooth, but monitoring is possible over MQTT, and of
      course the gateway receives and relays messages over
      LoRa/Meshtastic!

## Development boards

Those are bare-bones circuit boards that *work* standalone but cannot
really be used in production as they lack a proper case.

The devices here generally do not have a battery.

!!! success

    - [HELTEC v4](https://heltec.org/project/wifi-lora-32-v4/) ([v3](https://heltec.org/project/wifi-lora-32-v3/)) is the cheapest option, 20$ with the case
      (but no battery, and battery doesn't fit in the case), they also
      have an [eink dev board](https://heltec.org/project/vision-master-e290/). one advantage Heltec has over the below
      RAK kits is that you can connect to them over wifi, the downside is
      they use more power because they are ESP32 based instead of NRF5280
    - the [RAK19003 base kit](https://store.rakwireless.com/products/wisblock-meshtastic-starter-kit?variant=43884035113158) (28$) is more expensive, but less
      power-hungry than the Heltec

!!! example "In testing"

    - [XIAO nRF52840 & Wio-SX1262 Kit](https://www.seeedstudio.com/XIAO-nRF52840-Wio-SX1262-Kit-for-Meshtastic-p-6400.html): even tinier, nRF52840,
      Semtech SX1262, NFC, BT, -40°C ~ 65°C, 22 x 21 x 17.8mm. Probably
      the smallest kit you can get. Reset button hard to reach.

!!! question "Untested"

    - [T-Beam Supreme](https://lilygo.cc/products/t-beam-supreme?variant=43067944173749): 1.3" OLED display, 18650 battery socket,
      magnetometer, 2.4GHz WiFi, BLE 5, GNSS, no case, 52$, the [T-Beam
      SoftRF](https://lilygo.cc/products/t-beam-softrf?variant=43170158477493) is similar but without a display and cheaper, 30$USD

### DIY build on top of the RAK kit

The RAK19003 base kit comes *without* a case, but one [can be
printed](https://www.printables.com/model/286664-rak19003-micro-case-for-meshtastic). It's tricky because there are many (83!) design files in
there.

On top of 3D-printing the case, you need to also buy:

 - 4 × M3x20mm socket head cap screws ([this kit](https://abra-electronics.com/hardware/metric-hardware-kits/nuts/sc-h-m-ss-kit-m2-m3-m4-stainless-steel-hex-socket-cap-head-screws-washers-nuts-assortment-kit-1080pcs.html) covers this and
   the nuts)
 - 4 × M3 nuts
 - 2 × M2.5 screws (*not* part of the above kit, [length unclear](https://www.printables.com/model/286664-rak19003-micro-case-for-meshtastic/comments/2516182),
   [here are M2.5x6mm](https://abra-electronics.com/hardware/metric-hardware-round-phillips-head-screws/1968p-machine-screw-m2.5-6mm-length-phillips-25-pack.html) or [this kit](https://abra-electronics.com/hardware/metric-hardware-kits/screws-bolts/repair-kit-for-eyeglasses-watches-screws-and-nuts-caps-m1m2m2.5-stainless.html))
 - 1 × battery ([Amazon](https://www.amazon.com/gp/product/B091FKGW8H), possibly the same as [Abra](https://abra-electronics.com/batteries-holders/batteries-polymer-lithium-ion/1578-ada-lithium-ion-polymer-battery-37v-500mah-1578-ada.html),
   optional?)
 - there's also an optional [battery cutoff switch](https://www.amazon.com/gp/product/B086L2GPGX), couldn't find
   an [equivalent on Abra](https://abra-electronics.com/electromechanical/switches/pushbutton-switches/)

## Power

Most devices listed here are powered over regular USB-C
cables. Similarly regular power supplies should generally
suffice. Some devices can be powered with [Power over Ethernet](https://en.wikipedia.org/wiki/Power_over_Ethernet) as
well.

### Solar power

Some nodes have their own solar panels, which are generally preferable
for simplicity reasons, see the above [base stations and solar
section](#base-stations-and-solar) for more options.

The configuration of a separate solar power system is considered out
of scope here for the moment, but our previous wiki had [some
documentation about power generation](https://wiki.reseaulibre.ca/documentation/power/) but consider that the
information provided there is over 10 years old and [things have
changed significantly in that space since then](https://www.newyorker.com/news/annals-of-a-warming-planet/46-billion-years-on-the-sun-is-having-a-moment). We'd welcome a
guide on various solar panel setups that could accommodate various
setups, from a small base station to a full house.

## Batteries

Battery setups depends on the particular device. The [Heltec v4
pre-built kit](https://heltec.org/project/wifi-lora-32-v4-expansion-housing/), for example, uses [18650 battery cells](https://en.wikipedia.org/wiki/18650_battery). Those
cells need to be handled with care, see [this discussion about those
batteries](https://wiki.why2025.org/Badge/Fire_hazard), for example.

It's best to buy "protected" cells, which are typically sold in ["vape
shops"](https://www.openstreetmap.org/search?query=vape+shop&zoom=12&minlon=-74.07085418701173&minlat=45.36975515764875&maxlon=-73.19263458251955&maxlat=45.662286836234586#map=12/45.4999/-73.5775).

## Antennas

We have experience with this:

- [SYMITANT58](https://www.amazon.ca/Fiberglass-Antenna-Hotspot-Directional-Sensecap/dp/B09F31P1PL) (25$CAD Amazon), a similar (and currently cheaper)
  model is this [RF Explorer](https://www.seeedstudio.com/RF-Explorer-LoRa-Fiberglass-Antenna-Kit-902-930MHz-5-8dBi-800mm-p-5275.html) (10$USD from from Seeed Studio)

  Note that, to connect those to (say) a Heltec, you will need
  adapters:

        N (Antenna) --(cable)--> RP-SMA --(adaptor)--> SMA --(pigtail)--> IPEX U.FL (Heltec v4)

See also [this connector guide](https://pole1.co.uk/blog/5/) for recognizing those N, RP-SMA,
SMA and IPEX connectors. And yes, in the above setup, we essentially
touch on *all* the connectors from the guide.

Other lists include:

- [Official Meshtastic guide](https://meshtastic.org/docs/hardware/antennas/)[^1], which also refers to a [series of
  antenna reports](https://github.com/meshtastic/antenna-reports)
- [nyme.sh recommendations](https://nyme.sh/faq/#what-antenna)

[^1]:

    Note that the "Alfa AOA-915-5ACM" recommended for "Base station /
    repeater" in that guide falls short of the advertised +5dBi gain
    in [this technical review](https://antennatestlab.com/helium-network-antenna-reviews/alpha-network-ada-915-5acm-helium-antenna-5dbi).

### Picking the right antenna

#### For a roof or attic antenna

In the **typical case**, use a regular, omnidirectional antenna.  The
longest the antenna is, the better the gain, and gain improves
transmission power, essentially.

For a remote node, far from most other nodes, a directional antennas
is best: aim it at the nearest node nearby.  It improves gain in one
direction and reject noise from other directions. Either:

 * A [Yagi](https://en.wikipedia.org/wiki/Yagi%E2%80%93Uda_antenna) (better for outdoors) 
 * A panel (probably simpler for indoors, you can hang it from the
   ceiling in any orientation from two strings going to the top
   corners to orient it correctly)

#### For a window

In general, just use small antenna that came with your hardware.

If the building is large enough, you may get better results with a
flat panel[^2] in the window, as it would reject noise from other devices
in the back where you probably can't hear anything interesting through
the building anyway, and improve contact with nodes on the window
side.

[^2]:
   Unfortunately there doesn't seem to be many affordable low gain
   panels on the market (such panels are typically sold as sector
   antennas, but not always flat). A normal flat panel like the
   [ARC-PD0913C01](https://www.streakwave.com/arc-wireless-arc-pd0913c01-arc-dual-pol-panel-ant-900mhz) has 13 dBi of gain and a half power beamwidth of
   38 degrees which isn't ideal for this application.  Still, to
   perform worse than a <3bDi small atennas, you'd need to be at leass
   than 1/8 power beamwidth, which is probably around 150 degrees.  So
   worth a try.

In any case, for smaller setups, it's all a matter of having the best
[impedance match](https://en.wikipedia.org/wiki/Impedance_matching), which can be tested with a device called a
[Vector Network Analyzer](https://en.wikipedia.org/wiki/Network_analyzer_(electrical)), like the [NanoVNA](https://nanovna.com/), essentially an
antenna tester.

Longer cables will yield more power loss and lesser transmissions as
well.

### Theory and testing

!!! abstract

    This is a rather theoretical section about antenna
    design. You probably don't need to know about this: just use the
    antenna that ships with your device or buy a more powerful antenna
    from the recommended list and you'll be fine.

Note that there is an antenna is "tuned" to a specific frequency, or
more precisely to the "wavelength" of the frequency, which is an
inverse function of the frequency. So any antenna is *tuned* to a
specific wavelength, typically half or a quarter of the wavelength.

To compute the wavelength of a frequency, you take the speed of light:

    c = 299 792 458 m/s

... and divide it by the frequency in Hertz, in our case about 900MHz:

    c/915MHz = c/915 000 000 Hz ≈ 0.327 642 m ≈ 32.8 cm

So a correctly sized 915MHz antenna is about 33cm long. Note that
900MHz is relatively similar, about 4 mm longer:

    c/900MHz ≈ 33.3 cm

For all intents and purposes, we often consider an antenna tuned for
the *middle* of the frequency to be correct enough.

But all those stub antennas are not 30cm long, are they? That's
because you can have antennas that are only a *fraction* of the
wavelength, typically a half or quarter of the length, which makes
antennas that are 16 cm or 8 cm long.

You can also have *longer* antennas. [This blog post explains collinear
antennas](https://www.antennaexperts.co/blog/everything-you-need-to-know-about-collinear-antenna), which are omnidirectional antennas that are physically
*longer* than the wavelength of the frequency we operate on, which
improves the gain as well.

See also [this guide that shows tests on various antennas](https://medium.com/home-wireless/testing-and-reviewing-lora-antennas-5b37dfa594a3) to get a
better idea on how to test antennas.

## Hacks

- [Lamp hack](https://hackaday.io/project/194509-harbor-breeze-meshtastic-hack)

## Other documentation

- [Connector types overview](https://pole1.co.uk/blog/5/)
