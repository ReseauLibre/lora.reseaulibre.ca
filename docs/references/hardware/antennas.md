# Antennas

We have experience with this:

- [`SYMITANT58`](https://www.amazon.ca/Fiberglass-Antenna-Hotspot-Directional-Sensecap/dp/B09F31P1PL) (25$CAD Amazon)

- a similar (and currently cheaper) model is this [RF Explorer](https://www.seeedstudio.com/RF-Explorer-LoRa-Fiberglass-Antenna-Kit-902-930MHz-5-8dBi-800mm-p-5275.html)
  (10$USD from from Seeed Studio)
  
!!! warning

    The [antenna reports project](https://github.com/meshtastic/antenna-reports) warns against using a Seeed Studio
    antenna, particularly for non-US frequencies. It's unclear if it is
    the same antenna as the above RF Explorer, further testing necessary.

Note that, to connect those to (say) a Heltec, you will need
adapters:

    N (Antenna) --(cable)--> RP-SMA --(adaptor)--> SMA --(pigtail)--> IPEX U.FL (Heltec v4)

[Nooelec has a kit](https://www.nooelec.com/store/sdr/sdr-adapters-and-cables/sma-adapter-connectivity-kit.html).

See also [this connector guide](https://pole1.co.uk/blog/5/) for recognizing those N, RP-SMA,
SMA and IPEX connectors. And yes, in the above setup, we essentially
touch on *all* the connectors from the guide.

Other lists include:

- [Official Meshtastic guide](https://meshtastic.org/docs/hardware/antennas/)[^1], which also refers to a [series of
  antenna reports](https://github.com/meshtastic/antenna-reports)
- [`nyme.sh` recommendations](https://nyme.sh/faq/#what-antenna)

[^1]:

    Note that the "Alfa AOA-915-5ACM" recommended for "Base station /
    repeater" in that guide falls short of the advertised +5dBi gain
    in [this technical review](https://antennatestlab.com/helium-network-antenna-reviews/alpha-network-ada-915-5acm-helium-antenna-5dbi).

## Picking the right antenna

### For a roof or attic antenna

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

### For a window

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
   [ARC-PD0913C01](https://www.streakwave.com/arc-wireless-arc-pd0913c01-arc-dual-pol-panel-ant-900mhz) has 13 dBi of gain and a half power beam width of
   38 degrees which isn't ideal for this application.  Still, to
   perform worse than a <3dBi small antennas, you'd need to be at least
   than 1/8 power beam width, which is probably around 150 degrees.  So
   worth a try.

In any case, for smaller setups, it's all a matter of having the best
[impedance match](https://en.wikipedia.org/wiki/Impedance_matching), which can be tested with a device called a
[Vector Network Analyzer](https://en.wikipedia.org/wiki/Network_analyzer_(electrical)), like the [NanoVNA](https://nanovna.com/), essentially an
antenna tester.

Longer cables will yield more power loss and lesser transmissions as
well.

## Theory and testing

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

## NanoVNA crash course

As mentioned above, a good antenna tester is the [NanoVNA](https://nanovna.com/) which
you can [order from nooelec](https://www.nooelec.com/store/test-equipment/analyzers/nanovna-h4-bundle.html). Make sure you get a kit that covers
the 915MHz range, which is not necessarily the case: some kits *stop*
at 900MHz! Also get a closed case, some are more "bare boards" types
of things. [This link](https://www.nooelec.com/store/test-equipment/analyzers/nanovna-h4-bundle.html) should be fine.

To test an antenna, it needs to be a [SMA](https://en.wikipedia.org/wiki/SMA_connector) antenna. But lots of
LoRa antennas are actually [RP-SMA](https://en.wikipedia.org/wiki/SMA_connector#Reverse_polarity), so you will need a [RP-SMA
female to SMA male adapter](https://mgs4u.com/product/rp-sma-female-to-sma-male-adapter-8503/) which Nooelec oddly doesn't sell
individually, but they do have a [good connector kit](https://www.nooelec.com/store/sma-adapter-connectivity-kit.html) which is
useful to connect *other* random stuff you might get your hands on.

When you plug in the antenna, you will likely see one or a couple of
"dips" in the yellow line: those are where the antenna is "tuned",
where it will transmit better. By moving the cursor (with the little
button) you can see which frequency those are.

If you are a radio wizard, you can also read the [Smith chart](https://en.wikipedia.org/wiki/Smith_chart) in
green to figure out the [SWR](https://en.wikipedia.org/wiki/Standing_wave_ratio) (which you generally want to be below
2). But if, like me, you barely understand all of this, you might want
to change one of the traces (say the cyan one) by going into "Display"
and set it to "SWR".

Typically, you also want to calibrate the device before doing any test
beyond a quick checkup. For this, the NanoVNA normally ships with
three little adapters that look like [this image from
Nooelect](https://www.nooelec.com/store/media/catalog/product/cache/1/image/1200x/040ec09b1e35df139433887a97daa66f/i/m/img_7392_v3_1.jpg). Two have little conductor pins sticking out in the
middle, one doesn't, one has a longer stub, and one is gray. The
[calibration guide](https://nanovna.com/?page_id=2) will tell you to connect those in order:
"OPEN", "SHORT", and "LOAD" or sometimes called "LONG". This is how
you identify those:

- "OPEN": the one without a pin, think "open electric circuit",
  because the pin doesn't connect because it's not there!

- "SHORT": with a pin, short stub, same color (golden) as the
  "OPEN"

- "LOAD": with a pin, longest stub, different color (gray, stainless)

You connect those in order and hit the "calibrate" menus in
order. Yes, this is annoying, and yes, it's often necessary, otherwise
you'll get inaccurate or useless results.

