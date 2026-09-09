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
 
 2. if you have data on the device, [perform a backup](../meshcore/companion.md#backing-up-before-flashing)

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
Valid reply from <9ad54088c8f19b2782fda5f63057b378>
Round-trip time is 877.41 milliseconds over 1 hop [RSSI -46 dBm] [SNR 10.25 dB] [Link Quality 100.0%]

Sent 1, received 1, packet loss 0.0%
```

If it fails, you will see:

    Path request timed out

or:

    Probe timed out

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

### Details of the probe mechanism

When you run `rnsprobe`, it first writes:

    Path to <9ad54088c8f19b2782fda5f63057b378> requested ⢁

That last funny rune is a little spinner that animates for a while. In
this step, RNS tried to figure out the path to the destination. If
this is a fresh new probe, it doesn't actually know where to send the
packets, and will not actually send the probe until it figures that
out (and, yes, even if you have only a single interface).

If path discovery fails, you will see:

    Path request timed out

If the remote confirms its presence, then `rnsprobe` will switch to
actually sending the probe packet, at which point it will show:

    Sent probe 1 (16 bytes) to <9ad54088c8f19b2782fda5f63057b378>

If it fails at that point, it will show:

    Probe timed out
    Sent 1, received 0, packet loss 100.0%

This can happen if a device that was previously reachable (so path
discovery succeeded in the past) became unreachable. This can happen
if the device moved out of range or is somehow disabled, for example.

### Console output example

This is the output on my repeater, when booting:

```
anarcat@dorothea:~$ tio -a latest  -e -t | stdbuf -i0 -o0 -e0 strings -w | awk '{print $0"\r"}'
[22:56:24.175] tio 3.9
[22:56:24.175] Press ctrl-t q to quit
[22:56:24.292] Connected to /dev/ttyACM0
[22:56:24.425] 
00:00:05.507 [---] Registering filesystem...
00:00:05.507 [---] Listing filesystem...
00:00:05.510 [---]   eeprom
00:00:05.512 [---]   adafruit:
00:00:05.515 [---]     bond_prph:
00:00:05.519 [---]     bond_cntr:
00:00:05.523 [---]   config:
00:00:05.527 [---]   transport_identity
00:00:05.531 [---]   path_store:
00:00:05.538 [---]     index.dat
00:00:05.542 [---]     seg0.dat
00:00:05.548 [---]   known_store:
00:00:05.556 [---]     index.dat
00:00:05.562 [---]     seg0.dat
00:00:05.568 [---]   hashlist_store:
00:00:05.576 [---]     index.dat
00:00:05.582 [---]     seg0.dat
00:00:05.586 [---]   time_offset
00:00:05.588 [---] 
00:00:05.588 [---] Initializing Provisioning subsystem...
00:00:06.040 [VRB] 
00:00:06.041 [VRB] Starting RNS...
[22:56:24.959] 
00:00:06.041 [---] 
00:00:06.041 [---] Registering LoRA Interface...
00:00:06.049 [---] Transport: Registering interface 337b0aea851f05a0ba0e7c2f9b2fdd1c38b74b2fa290b8ef05b11518a4625485 Interface[LoRaInterface]
00:00:06.063 [---] LoRaInterface hash: 337b0aea851f05a0ba0e7c2f9b2fdd1c38b74b2fa290b8ef05b11518a4625485
00:00:06.064 [---] 
00:00:06.065 [---] Creating Reticulum instance...
00:00:06.067 [---] Initializing RNG...
00:00:06.072 [---] RNG initial random value: 1145324612
00:00:06.073 [INF] Total SRAM: 188464 bytes
00:00:06.074 [INF] Free SRAM: 35568 bytes
00:00:06.074 [INF] Total flash: 28672 bytes
00:00:06.077 [INF] Free flash: 24576 bytes
00:00:06.089 [DBG] Read time offset of 655458 from file
00:11:01.549 [DBG] Writing time offset of 661549 to file ./time_offset
00:11:01.944 [INF] Starting Provisioning...
00:11:01.944 [INF] Starting Transport...
00:11:01.945 [INF] Transport starting...
00:11:01.947 [VRB] No cache directory, creating...
00:11:02.078 [DBG] Checking for transport identity...
00:11:02.081 [---] Reading identity key from storage...
00:11:02.312 [---] Identity::update_hashes: hash: a6762dc46c4ea9391819670c526559cb
00:11:02.314 [VRB] Loaded Transport Identity from storage
00:11:02.331 [---] Destination::Destination: hash: 6b9f66014d9853faab220fba47d02761
00:11:02.339 [---] Transport: Registering destination {Destination:6b9f66014d9853faab220fba47d02761}
00:11:02.344 [DBG] Created transport-specific path request destination 6b9f66014d9853faab220fba47d02761
00:11:02.363 [---] Destination::Destination: hash: 91bf0910267b59b0e864e0d4c91602ca
00:11:02.373 [---] Transport: Registering destination {Destination:91bf0910267b59b0e864e0d4c91602ca}
00:11:02.377 [DBG] Created transport-specific tunnel synthesize destination 91bf0910267b59b0e864e0d4c91602ca
00:11:02.399 [---] Destination::Destination: hash: 262a240ac31073c84da930f1e27299a8
00:11:02.409 [---] Transport: Registering destination {Destination:262a240ac31073c84da930f1e27299a8}
00:11:02.434 [NOT] Enabled remote management on <{Destination:262a240ac31073c84da930f1e27299a8}>
00:11:02.437 [NOT] Enabled remote provisioning on <{Destination:262a240ac31073c84da930f1e27299a8}>
00:11:02.440 [INF] Transport mode is enabled
00:11:02.443 [INF] FileSystem available: 24320 bytes
00:11:02.444 [---] Initializing path table store...
00:11:02.475 [---] Initializing known destinations store...
00:11:02.517 [---] Initializing packet hashlist store...
00:11:02.555 [DBG] Transport::read_tunnel_table
00:11:02.576 [---] Destination::Destination: hash: 9ad54088c8f19b2782fda5f63057b378
00:11:02.586 [---] Transport: Registering destination {Destination:9ad54088c8f19b2782fda5f63057b378}
00:11:02.589 [DBG] Created probe responder destination 9ad54088c8f19b2782fda5f63057b378
00:11:02.593 [NOT] Transport instance will respond to probe requests on <9ad54088c8f19b2782fda5f63057b378>
00:11:02.596 [VRB] Transport instance {Identity:a6762dc46c4ea9391819670c526559cb} started
00:11:02.617 [---] Destination::Destination: hash: ada18160d14a8224b8cbfe320957789e
00:11:02.626 [---] Transport: Registering destination {Destination:ada18160d14a8224b8cbfe320957789e}
00:11:02.653 [NOT] Announcing NomadNet site "microReticulum Node [65C7C15AC9C4]" at destination <ada18160d14a8224b8cbfe320957789e>
00:11:02.657 [---] Destination::announce: announcing destination...
00:11:02.817 [---] Destination::announce: sending announce packet...
00:11:02.818 [---] Packet::send: sending packet...
00:11:02.819 [---] Packet::pack: packing packet...
00:11:02.824 [---] Packet::pack: destination hash: ada18160d14a8224b8cbfe320957789e
00:11:02.836 [---] Packet::pack: packed packet of size 201 bytes
00:11:02.837 [---] Transport::outbound()
00:11:02.839 [---] Transport::outbound: destination=ada18160d14a8224b8cbfe320957789e hops=0
00:11:02.843 [---] Transport::outbound: Path to destination is unknown
00:11:02.845 [---] Transport::outbound: Checking interface Interface[LoRaInterface]
00:11:02.846 [---] Transport::outbound: Packet has no attached interface
00:11:02.847 [---] Transport::outbound: Packet transmission allowed
00:11:03.365 [---] Transport::transmit()
00:11:03.370 [---] LoRaInterface.send_outgoing: (201 bytes) data: 0100ada18160d14a8224b8cbfe320957789e009b3dc93e8a8bbfdf71185e1a72b1b4e56fc81d399c87712c5090f45730bd8d34ddea2439ef235181ad69ea8718deff656be0ac734d0c3e873ec084fb9f7ecef6213e6311bcec54ab4fde4dc
00:11:03.373 [---] LoRaInterface.send_outgoing: adding packet to outgoing queue...
00:11:03.374 [---] Packet::send: successfully sent packet!!!
00:11:03.375 [---] 
00:11:03.375 [---] RNS is READY!
00:11:03.375 [---] 
00:11:03.376 [---] RNS transport mode is ENABLED
00:11:03.376 [---] Frequency: 914875000 Hz
00:11:03.377 [---] Bandwidth: 125000 Hz
00:11:03.378 [---] Spreading Factor: 9
00:11:03.378 [---] Coding Rate: 7
00:11:03.379 [---] TX Power: 17 dBm
00:11:03.380 [---] 
00:11:03.380 [---] RNS Transport is READY!
```

## Known issues

- for RAK 4631 boards, the battery voltage readings are always
  reported as zero, so you do not get to monitor battery levels

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
- [`PRNS`](https://reticulum.rs/) - Rust-based rewrite, LLM-coded, human-reviewed
