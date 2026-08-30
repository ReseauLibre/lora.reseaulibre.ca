# Transport nodes

All of the above is about "clients", in the sense that most of the
software is geared towards new users, and rightly so.

But we did not talk much about routing, which is a core tenant of mesh
networks of course. That's because there is a separate feature to
enable on a RNode to enable that, it's called a "transport".

Because the devices we have setup, so far, all require a client like a
computer, it makes this all inconvenient to host on your rooftop.

Thankfully people figured out a solution to this problem and starting
expanding RNode to support routing, into something called an RTNode,
for "Reticulum Transport Node".

What follows is a shorter version of Cleeyv's [excellent guide on how
to setup the RTNode firmware on Heltec device](https://rns.recipes/forum/build-guides/how-to-install-and-test-the-rtnode-firmware), which we revise
here to include other devices. The following procedure was tested on a
[RAK WisMesh Repeater Mini](https://store.rakwireless.com/products/wishmesh-meshtastic-solar-repeater-mini).

## Installation

You will be installing the [`attermann/microReticulum_firmware`](https://github.com/attermann/microReticulum_Firmware/)
from GitHub. This assumes you already have [RNS](rns.md) installed on a
Linux computer and are familiar with the command-line. 

Then follow those steps:

 1. connect the device with a USB cable to the computer
 
 2. if you have data on the device, [perform a backup](meshcore/companion.md#backing-up-before-flashing)

 2. deploy the firmware with:

        rnodeconf --clear-cache
        rnodeconf --autoinstall --fw-url https://github.com/attermann/microReticulum_Firmware/releases/

    The `rnodeconf --clear-cache` is optional and required only if you
    have previously installed another RNode firmware with the same name.

    The `--autoinstall` process is similar to the one we have
    documented in the [RNS documentation](#rnode) in that it will walk you
    through a series of prompts before flashing the firmware. Make
    sure you pick the right frequency band (currently 915MHz).

 3. At this point, the firmware in place is only like a normal RNode
    in that it's essentially a modem, and does not yet relay
    packets. For that, you need to switch it to "Transport mode".

        rnodeconf --tnc --freq 914875000 --bw 125000 --sf 9 --cr 7 --txp 17 /dev/ttyACM0

    If you get an error like:
    
        [22:30:19] [Errno 2] could not open port /dev/ttyACM0: [Errno 2] No such file or directory: '/dev/ttyACM0'

    It's possible the device reconnected under a different serial
    port, try changing to, say, `/dev/ttyACM1` You can list your
    terminal devices with:
    
        ls /dev/tty*

    Another possibility is `/dev/ttyUSB0`, for example. It is *not*
    `/dev/ttyS0` or `/dev/tty0`, those are internal ports in Linux
    that are not your external serial ports, ignore those.
    
    If you can't find the port, it's possible the device is
    disconnected somehow, but that would be surprising if the
    `--autoinstall` step succeeded.

 4. reboot the device, by pushing the reset pin

## Testing

To see if the node works, you must connect to it over serial with [`tio`](https://github.com/tio/tio):

    tio /dev/ttyACM0 -t | stdbuf -i0 -o0 -e0 strings -w | awk '{print $0"\r"}'

This will show a series of cryptic messages, look for one like:

```
00:10:56.503 [NOT] Transport instance will respond to probe requests on <9ad54088c8f19b2782fda5f63057b378>
```

Save this line so that the hash can be referred back to later in the test. Then make sure to close the tio session by typing <kbd>ctrl-t</kbd> and then <kbd>q</kbd> because leaving it open can cause problems later.

Then you will need another Reticulum device to probe the above to see
if it really responds. For this, we will use another computer with
[RNS](rns.md) installed. You *could* use the same device, but make sur
`rnsd` is started with the right port, which will be different than
the one used for the RTNode!

Run this command to confirm a Reticulum connection over LoRa between RNS on your computer with an RNode interface to the RTNode and back:

```
rnprobe rnstransport.probe 9ad54088c8f19b2782fda5f63057b378
```

The positive result should say Valid Reply and then info on the LoRa connection, like this:

```
Round-trip time is 877.41 milliseconds over 1 hop [RSSI -46 dBm] [SNR 10.25 dB] [Link Quality 100.0%]
```

If it fails, you will see:

    Path request timed out

Unless the two devices are extremely far away (think "kilometers") or
close (think "on top of each other"), this is most likely due to a
mismatch in the LoRa parameters. Check both sides to see if they use
the same parameters, they will both display their settings on boot.

!!! tip

    Upstream provides a `console.html` file that can be loaded in a
    browser with the [Web Serial API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Serial_API#browser_compatibility)
    (e.g. Chrome, Firefox 151 or later) to provide a more complete and
    intuitive interface to the device, undocumented here for now.
    
    It is also possible to remotely manage the device *over LoRa* (!)
    through that console file.

## Future work

We do not have a good procedure for testing the actual "transport"
part of the transport node here. All we did is test that the device
responds to probe, but that does not mean it is correctly relaying
packets, which is not necessarily a given.

[Cleeyv's guide](https://rns.recipes/forum/build-guides/how-to-install-and-test-the-rtnode-firmware) provides a [transport test](https://rns.recipes/forum/build-guides/how-to-install-and-test-the-rtnode-firmware#post-124) which you should
try for now.

## Other firmware

Those are the transport firmware projects we are currently aware of:

- [`attermann/microReticulum_Firmware`](https://github.com/attermann/microReticulum_Firmware): RNode firmware integrating
  the [microReticulum](https://github.com/attermann/microReticulum) stack which implements a full transport node
  (documented above), see also the [Ratspeak fork](https://github.com/ratspeak/microReticulum)
- [`RatTunnel`](https://github.com/hipstereclipse/rns-transport-wisblock1w) - used on the west coast on RAK solar nodes, with
  console commands, 200 entry routing table with SNR tracking,
  integration with [`Rathole`](https://github.com/ratspeak/rathole)
- [untested Ethernet gateway firmware](https://rns.recipes/forum/showcase/rnode-over-ethernet-rak4631-rak13800-ethernet-module)
