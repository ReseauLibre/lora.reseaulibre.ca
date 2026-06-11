# Tunneling Reticulum over Meshcore

Amazingly, because Reticulum can route over essentially anything, you
can route Reticulum traffic over Meshcore meshes.

!!! example "Advanced users only!"

    This is a particularly exotic Reticulum configuration. 
    
    We are not sure this is a good idea. It might flood the Meshcore
    mesh, for example. So far, there seems to be only moderate (2x)
    amplification in traffic so we're continuing to experiment. but we
    do not recommend people adopt this, generally.
    
    Meshcore people typically frown upon Meshcore being bridged across
    regions or with other networks, and might consider such use to be hostile.

    Finally, if you're just getting started with Reticulum, this one
    will be particularly confusing, just skip this section.

During the May 2026 mesh night at Foulab, we have successfully routed
Reticulum messages over a local LoRa link with two Meshcore companions
connected over serial.

We are using [this fork of the `RNS_Over_MeshCore` interface](https://github.com/slack-t/RNS_Over_MeshCore). To
install it, we clone it and deploy the file in place:

```
cd .reticulum/interfacse
git clone https://github.com/slack-t/RNS_Over_MeshCore
ln -s RNS_Over_MeshCore/Interface/MeshcoreInterface.py .
```

!!! note

    There is also this other implementation:
    [`scottrhoyt/rns-meshcore-interface`](https://github.com/scottrhoyt/rns-meshcore-interface)
    that has not been tested and is likely incompatible.


Then we add the interface to the RNS configuration file in
`~/.reticulum/config`:

```
[[MeshCore]]
   type = MeshcoreInterface
   interface_enabled = true

   # === Transport settings ===
   #transport = ble           # Options: ble | serial | tcp
   transport = serial
   #port = /dev/ttyUSB0       # Serial port if transport = serial
   #baudrate = 115200         # Serial baudrate
   #host = 127.0.0.1          # TCP host if transport = tcp
   #tcp_port = 4403           # TCP port if transport = tcp
   #ble_name = MeshCore-Obdolbus  # BLE device name (optional, auto-scan if empty)

   # === RNS channel settings ===
   # IMPORTANT: Change channel_secret to a unique value! The default is published
   # in the source code — anyone using it can read your traffic. Generate one with:
   #   python3 -c "import os; print(os.urandom(16).hex())"
   # Then set the SAME secret on ALL your RNS-over-MeshCore nodes.
   # channel_name = RNSTunnel
   # channel_secret = <your-unique-16-byte-hex-secret>
   # channel_idx =                                        # Leave empty to auto-select, fallback = 39
   channel_name = RNSTunnel
   # this is #RNSTunnel
   channel_secret = 04f6a140660d9836752cbbdb71bb601a

   # === Fragmentation / reliability ===
   #count_repeat = 1              # Number of full interleaved rounds to send all fragments
   #fragment_mtu = 100            # Max payload bytes per fragment (test higher values for speed)
   #fragment_delay = 3            # Starting delay between fragments (seconds), adapts automatically
   #fragment_delay_min = 1        # Minimum adaptive delay (seconds)
   #fragment_delay_max = 30       # Maximum adaptive delay (seconds)
   #delay_step_down = 0.5         # Seconds subtracted from delay on each successful send
   #delay_backoff_factor = 1.5    # Multiplier applied to delay on each failed send
   #fragment_timeout = 180        # Timeout for incomplete fragment reassembly (seconds)
   #bitrate = 2000                # Rate limiting in bytes/sec, 0 = unlimited
   #opportunistic_sending = false # Send next fragment as soon as previous completes
   #guard_delay = 0.3             # Minimum gap between sends in opportunistic mode (seconds)
   #flood_scope =                 # Limit propagation to repeaters allowing this scope (requires firmware >1.14)
```

Note that we use a hard coded `channel_secret` above, which upstream
[strongly warns against](https://github.com/slack-t/RNS_Over_MeshCore#channel-secret). We consider those concerns to be
unfounded since Reticulum encrypts traffic before injecting into the
transport. Instead, we favor instead broad compatibility across
clients, using a common, public channel.

!!! bug

    Pay close attention to the `type` line above. In the upstream
    documentation, it says to use:
    
        type = MeshCoreInterface
    
    But the filename is `MeshcoreInterface.py`, which will make
    loading file. This is case sensitive! So either rename the file or
    change the type to:
    
        type = MeshcoreInterface
    
    The above instructions are correct and should work, but you will
    fail if you copy directly from upstream.

In the above configuration, we connect RNS to a Meshcore companion
over "serial" (USB) and specify the given port. It *may* be
`/dev/ttyACM0` as well on some devices. It might be possible to make
this work with Bluetooth as well, but we found serial to be much
easier.

For this to work, you need to have a "companion" flashed with
Meshcore. You can follow our [Meshcore flashing guide](../meshcore.md#flash-the-firmware-on-the-device), just make
sure you pick "serial" and not "Bluetooth".

!!! bug

    Some applications like MeshChatX will fail to load the `meshcore`
    library because it cannot be found. This is often related to the
    sandboxing some of those applications.
    
    One workaround is to install the Debian package instead.
    
    Or it's also possible to hijack the load path inside the interface
    itself.
    
    We have had success adding something similar to this to the top of
    the interface Python file (`MeshcoreInterface.py`):
    
        import sys
        sys.path.insert(0, "/usr/lib/python3/dist-packages/")
        sys.path.insert(0, "/home/anarcat/.venvs/reticulum/lib/python3.13/site-packages/")

If both endpoints are configured this way, they should be able to send
an announce (see below), see each other, and exchange text messages
and so on.

## Other references

Two conversations about doing the reverse, that is routing Meshcore
over Reticulum:

- [RFC: Reticulum Network Stack as a Decentralized Backhaul Layer for
  MeshCore](https://github.com/meshcore-dev/MeshCore/discussions/1736)
- [MeshCore–Reticulum Bridge Node: Technical Specification v5](https://github.com/samuk/Reticulum/blob/master/docs/meshcore-bridge.md), the
  spec behind [`CoreNet`](https://github.com/artbotterell/CoreNet)
