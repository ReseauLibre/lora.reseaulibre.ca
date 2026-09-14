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
05-10:33:52.344 [---] Provisioning::clear_storage()
00:00:03.605 [---] 
00:00:03.605 [---] Initializing filesystem...
00:00:03.606 [---] Looking for RAK15001 flash...
00:00:03.607 [---] Using internal flash...
00:00:04.132 [---] Initialized internal flash
00:00:04.415 [---] Registering filesystem...
00:00:04.415 [---] Listing filesystem...
00:00:04.418 [---]   eeprom
00:00:04.420 [---]   adafruit:
00:00:04.425 [---]     bond_prph:
00:00:04.430 [---]     bond_cntr:
00:00:04.435 [---]   config:
00:00:04.440 [---]     ns1.msgpack
00:00:04.444 [---]   transport_identity
00:00:04.449 [---]   path_store:
00:00:04.456 [---]     index.dat
00:00:04.460 [---]     seg0.dat
00:00:04.467 [---]   known_store:
00:00:04.477 [---]     index.dat
00:00:04.483 [---]     seg0.dat
00:00:04.490 [---]   hashlist_store:
00:00:04.500 [---]     seg0.dat
00:00:04.507 [---]     seg1.dat
00:00:04.515 [---]     index.dat
00:00:04.521 [---]   time_offset
00:00:04.522 [---] 
00:00:04.522 [---] Initializing Provisioning subsystem...
00:00:05.016 [VRB] 
00:00:05.017 [VRB] Starting RNS...
00:00:05.017 [---] 
00:00:05.017 [---] Registering LoRA Interface...
00:00:05.025 [---] Transport: Registering interface 337b0aea851f05a0ba0e7c2f9b2fdd1c38b74b2fa290b8ef05b11518a4625485 Interface[LoRaInterface]
00:00:05.039 [---] LoRaInterface hash: 337b0aea851f05a0ba0e7c2f9b2fdd1c38b74b2fa290b8ef05b11518a4625485
00:00:05.041 [---] 
00:00:05.041 [---] Creating Reticulum instance...
00:00:05.042 [---] Initializing RNG...
00:00:05.047 [---] RNG initial random value: 4227595259
00:00:05.048 [INF] Total SRAM: 188464 bytes
00:00:05.048 [INF] Free SRAM: 35568 bytes
00:00:05.049 [INF] Total flash: 28672 bytes
00:00:05.053 [INF] Free flash: 18944 bytes
00:00:05.066 [DBG] Read time offset of 469701449 from file
05-10:28:26.517 [DBG] Writing time offset of 469706517 to file ./time_offset
05-10:28:27.040 [INF] Starting Provisioning...
05-10:28:27.040 [INF] Starting Transport...
05-10:28:27.041 [INF] Transport starting...
05-10:28:27.043 [VRB] No cache directory, creating...
05-10:28:27.301 [DBG] Checking for transport identity...
05-10:28:27.304 [---] Reading identity key from storage...
05-10:28:27.536 [---] Identity::update_hashes: hash: a6762dc46c4ea9391819670c526559cb
05-10:28:27.539 [VRB] Loaded Transport Identity from storage
05-10:28:27.555 [---] Destination::Destination: hash: 6b9f66014d9853faab220fba47d02761
05-10:28:27.565 [---] Transport: Registering destination {Destination:6b9f66014d9853faab220fba47d02761}
05-10:28:27.569 [DBG] Created transport-specific path request destination 6b9f66014d9853faab220fba47d02761
05-10:28:27.588 [---] Destination::Destination: hash: 91bf0910267b59b0e864e0d4c91602ca
05-10:28:27.598 [---] Transport: Registering destination {Destination:91bf0910267b59b0e864e0d4c91602ca}
05-10:28:27.603 [DBG] Created transport-specific tunnel synthesize destination 91bf0910267b59b0e864e0d4c91602ca
05-10:28:27.624 [---] Destination::Destination: hash: 262a240ac31073c84da930f1e27299a8
05-10:28:27.635 [---] Transport: Registering destination {Destination:262a240ac31073c84da930f1e27299a8}
05-10:28:27.672 [NOT] Enabled remote management on <{Destination:262a240ac31073c84da930f1e27299a8}>
05-10:28:27.675 [NOT] Enabled remote provisioning on <{Destination:262a240ac31073c84da930f1e27299a8}>
05-10:28:27.679 [INF] Transport mode is enabled
05-10:28:27.682 [INF] FileSystem available: 18688 bytes
05-10:28:27.683 [---] Initializing path table store...
05-10:28:27.719 [---] Initializing known destinations store...
05-10:28:27.764 [---] Initializing packet hashlist store...
05-10:28:28.720 [DBG] Transport::read_tunnel_table
05-10:28:28.741 [---] Destination::Destination: hash: 9ad54088c8f19b2782fda5f63057b378
05-10:28:28.752 [---] Transport: Registering destination {Destination:9ad54088c8f19b2782fda5f63057b378}
05-10:28:28.756 [DBG] Created probe responder destination 9ad54088c8f19b2782fda5f63057b378
05-10:28:28.760 [NOT] Transport instance will respond to probe requests on <9ad54088c8f19b2782fda5f63057b378>
05-10:28:28.763 [VRB] Transport instance {Identity:a6762dc46c4ea9391819670c526559cb} started
05-10:28:28.785 [---] Destination::Destination: hash: ada18160d14a8224b8cbfe320957789e
05-10:28:28.796 [---] Transport: Registering destination {Destination:ada18160d14a8224b8cbfe320957789e}
05-10:28:28.834 [NOT] Announcing NomadNet site "microReticulum Node [65C7C15AC9C4]" at destination <ada18160d14a8224b8cbfe320957789e>
05-10:28:28.838 [---] Destination::announce: announcing destination...
05-10:28:29.001 [---] Destination::announce: sending announce packet...
05-10:28:29.002 [---] Packet::send: sending packet...
05-10:28:29.002 [---] Packet::pack: packing packet...
05-10:28:29.008 [---] Packet::pack: destination hash: ada18160d14a8224b8cbfe320957789e
05-10:28:29.022 [---] Packet::pack: packed packet of size 201 bytes
05-10:28:29.023 [---] Transport::outbound()
05-10:28:29.025 [---] Transport::outbound: destination=ada18160d14a8224b8cbfe320957789e hops=0
05-10:28:29.029 [---] Transport::outbound: Path to destination is unknown
05-10:28:29.031 [---] Transport::outbound: Checking interface Interface[LoRaInterface]
05-10:28:29.032 [---] Transport::outbound: Packet has no attached interface
05-10:28:29.033 [---] Transport::outbound: Packet transmission allowed
05-10:28:29.551 [---] Transport::transmit()
05-10:28:29.556 [---] LoRaInterface.send_outgoing: (201 bytes) data: 0100ada18160d14a8224b8cbfe320957789e009b3dc93e8a8bbfdf71185e1a72b1b4e56fc81d399c87712c5090f45730bd8d34ddea2439ef235181ad69ea8718deff656be0ac734d0c3e873ec084fb9f7ecef6213e6311bcec54ab4fde
05-10:28:29.560 [---] LoRaInterface.send_outgoing: adding packet to outgoing queue...
05-10:28:29.561 [---] Packet::send: successfully sent packet!!!
05-10:28:29.562 [---] 
05-10:28:29.563 [---] RNS is READY!
05-10:28:29.563 [---] 
05-10:28:29.564 [---] RNS transport mode is ENABLED
05-10:28:29.565 [---] Frequency: 914875000 Hz
05-10:28:29.565 [---] Bandwidth: 125000 Hz
05-10:28:29.566 [---] Spreading Factor: 9
05-10:28:29.567 [---] Coding Rate: 7
05-10:28:29.567 [---] TX Power: 17 dBm
05-10:28:29.568 [---] 
05-10:28:29.569 [---] RNS Transport is READY!
05-10:28:29.569 [---] Sending management announces...
05-10:28:29.570 [---] Destination::announce: announcing destination...
05-10:28:29.731 [---] Destination::announce: sending announce packet...
05-10:28:29.732 [---] Packet::send: sending packet...
05-10:28:29.733 [---] Packet::pack: packing packet...
05-10:28:29.739 [---] Packet::pack: destination hash: 262a240ac31073c84da930f1e27299a8
05-10:28:29.752 [---] Packet::pack: packed packet of size 167 bytes
05-10:28:29.753 [---] Transport::outbound()
05-10:28:29.755 [---] Transport::outbound: destination=262a240ac31073c84da930f1e27299a8 hops=0
05-10:28:29.759 [---] Transport::outbound: Path to destination is unknown
05-10:28:29.761 [---] Transport::outbound: Checking interface Interface[LoRaInterface]
05-10:28:29.762 [---] Transport::outbound: Packet has no attached interface
05-10:28:29.763 [---] Transport::outbound: Packet transmission allowed
05-10:28:30.282 [---] Transport::transmit()
05-10:28:30.286 [---] LoRaInterface.send_outgoing: (167 bytes) data: 0100262a240ac31073c84da930f1e27299a8009b3dc93e8a8bbfdf71185e1a72b1b4e56fc81d399c87712c5090f45730bd8d34ddea2439ef235181ad69ea8718deff656be0ac734d0c3e873ec084fb9f7ecef64848a053c16415bed6c8
05-10:28:30.290 [---] LoRaInterface.send_outgoing: adding packet to outgoing queue...
05-10:28:30.291 [---] Packet::send: successfully sent packet!!!
05-10:28:30.292 [---] Destination::announce: announcing destination...
05-10:28:30.453 [---] Destination::announce: sending announce packet...
05-10:28:30.454 [---] Packet::send: sending packet...
05-10:28:30.455 [---] Packet::pack: packing packet...
05-10:28:30.461 [---] Packet::pack: destination hash: 9ad54088c8f19b2782fda5f63057b378
05-10:28:30.475 [---] Packet::pack: packed packet of size 167 bytes
05-10:28:30.476 [---] Transport::outbound()
05-10:28:30.478 [---] Transport::outbound: destination=9ad54088c8f19b2782fda5f63057b378 hops=0
05-10:28:30.482 [---] Transport::outbound: Path to destination is unknown
05-10:28:30.484 [---] Transport::outbound: Checking interface Interface[LoRaInterface]
05-10:28:30.485 [---] Transport::outbound: Packet has no attached interface
05-10:28:30.486 [---] Transport::outbound: Packet transmission allowed
05-10:28:31.004 [---] Transport::transmit()
05-10:28:31.009 [---] LoRaInterface.send_outgoing: (167 bytes) data: 01009ad54088c8f19b2782fda5f63057b378009b3dc93e8a8bbfdf71185e1a72b1b4e56fc81d399c87712c5090f45730bd8d34ddea2439ef235181ad69ea8718deff656be0ac734d0c3e873ec084fb9f7ecef6fd68805f2ea383c8d6f6
05-10:28:31.013 [---] LoRaInterface.send_outgoing: adding packet to outgoing queue...
05-10:28:31.014 [---] Packet::send: successfully sent packet!!!
```

Then I added my primary and LXMF Nomadnet identities as "Remote
Management Allowed" through the `console.html` in Transport Config,
uReticulum General Config. I am not sure which one grants me access,
but it's read-only anyways for now so it does not matter much. There
is some [API contraption](https://github.com/attermann/ReticulumAPI) that allows one to glue the HTML console
with LoRa but I haven't tested it.

To save changes, the "save namespace" is at the top, then "commit
all", then reboot.

I have mistakenly "cleared provisionning" instead of saving, that's
not the right button.

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
