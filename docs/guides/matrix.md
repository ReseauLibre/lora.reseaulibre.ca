# Matrix guides

## How do I join the Matrix room?

Let's say that, after [reading the FAQ](faq.md#why-matrix) you're convinced that
Matrix is good enough and you want to try it out. How do you actually
join?

There are many guides for this, but the [`joinmatrix.org` guide is
pretty good](https://joinmatrix.org/). Essentially, it is:

 1. Register on a home server
 2. Download a client, app, or use a web client
 3. Join the room

### Picking a home server

Here are home servers we recommend:

- **Matrix.org**: even though they do not recommend you create an account
  there because their server is busy, it's still possible to create a
  `matrix.org` account on [`app.element.io`](https://app.element.io/)

- **Mozilla.org**: the people who make the Firefox web browser. Go to
  [chat.mozilla.org](https://chat.mozilla.org/) (which also serves as web client) and click on
  "Continue with...", you can sign up with an already existing Mozilla
  Accounts, GitHub, or Google account

- **FSFE**: the European Free Software Foundation [runs a Matrix
  server for its members](https://docs.fsfe.org/en/techdocs/matrix), requires a donation, see
  [`chat.fsfe.org`](https://chat.fsfe.org/)

- Linux distributions:

  - **Debian**: people with an account on the [Debian GitLab server](https://salsa.debian.org/)
    ("salsa") can access the [`debian.social`](https://element.debian.social/) home server

  - **Ubuntu**: members can use [register on the `ubuntu.com` home
    server](https://ubuntu.com/community/docs/communications/matrix/register-ubuntu-com)

  - **Fedora**: people with a [Fedora account](https://accounts.fedoraproject.org/) can use the
    [`fedora.im` home server](https://chat.fedoraproject.org/)

  - **Arch**: team members can [use the `archlinux.org` home server](https://github.com/archlinux/infrastructure/blob/master/docs/matrix.md)

There is also [this partial list of public home servers](https://servers.joinmatrix.org/).

### Picking an app

We recommend those:

- [Element X](https://matrix.org/ecosystem/clients/element-x/): flagship mobile app
- [Element](https://matrix.org/ecosystem/clients/element/): flagship desktop app
- [FluffyChat](https://matrix.org/ecosystem/clients/fluffychat/): good mobile, desktop app
- [Cinny](https://cinny.in/): good desktop, minimalist, desktop app

If you want to use the web interface, your home server provider likely
provides one (above), otherwise use the official instance at
[`app.element.io`](https://app.element.io).

### Joining the room

Normally, clicking the [`#reseaulibre:matrix.org` Matrix room](https://matrix.to/#/#reseaulibre:matrix.org) from
your browser should work, by opening the desktop client. 

If not, you can type `/join #reseaulibre:matrix.org` in any chat
window, or enter the `#reseaulibre:matrix.org` URL in the "join" (in
element it's "Search") interface of your client.

## Bridging Matrix and Meshtastic

A Matrix bridge is in operation on the LongFast channel and can be
used for a variety of things.

### Usage

Messages sent in the bridged room
([`#reseaulibre-meshtastic-bridge:matrix.org`](https://matrix.to/#/#reseaulibre-meshtastic-bridge:matrix.org))
will be sent to the Meshtastic "LongFast" channel and vice versa. It
is named `rl-mmrelay-litlitaly` on both sides. On Meshtastic, its
short name is `litl`.

The bridge also replies to direct messages.

It will show up like this in your device listing in the Android app:

<figure markdown="span">
![Card for the Matrix bot](matrix-bot-screenshot.jpg)
  <figcaption>A sighting of the Matrix bot in the Meshtastic Android
  app, with the bot marked as favourite and a surprisingly Good signal.</figcaption>
</figure>

There are [plugins](https://github.com/jeremiah-k/meshtastic-matrix-relay/wiki/Core-Plugins) that allow for some fancier operations:

- `!ping` - send this to the channel from Meshtastic or Matrix to
  generate a response, useful to test reachability[^1]

[^1]: The bot is currently in Little Italy, with a poor antenna, so
don't be surprised if you don't hear it. It will be improved this
summer.

- `!health` - gives a series of stats about the health of the relay
  and network (Matrix-only), example:

        Nodes: 31
         Battery: 100.7% / 101.0% (avg / median)
         Nodes with Low Battery (<= 10): 0
         Air Util: 1.28 / 1.03 (avg / median)
         SNR: 3.93 / 6.00 (avg / median)

- `!weather` - gives a basic weather report (Meshtastic-only),
  example:
  
        Now: 🌙☁️ Overcast - -2.5°C | Humidity 82% | Wind 15.9km/h 51° | Precip 14%

    Use `location=` to change the location.

- `!airUtilTx` - shows channel utilization graph for the last 24h
  (Matrix-only), the `!batteryLevel` and `!voltage` give similar
  graphs, but currently useless as the device is powered over USB

- `!nodes` - shows the list of known nodes (Matrix-only)

- `!map zoom=12` - show a map of the network (Matrix-only), note that
  the default `zoom=8` is far too large for the current mesh size
### Configuration

There is now a [Matrix](https://matrix.org) bridge setup in the little Italy
neighbourhood. I essentially followed [this quick start guide](https://github.com/jeremiah-k/meshtastic-matrix-relay/wiki/Getting-Started-With-Matrix-&-MM-Relay) and
this [Docker guide](https://github.com/jeremiah-k/meshtastic-matrix-relay/blob/main/docs/DOCKER.md).

!!! warning

    Do *not* naively follow this guide! If you add another relay that
    join the *same* room, you are likely going to create loops and
    extra traffic to the mesh. Make your own room for your own bot!

I first created a room in the Matrix space, then created a new account
and invited it to the room. The room is currently fully open to the
public but might be locked down if there's abuse, either by making the
room non-writable by Matrix users or invite-only.

Then I setup the container with the following `docker-compose.yml`
file:

```yaml
volumes:
  mmrelay-data:
  mmrelay-cache:

services:
  mmrelay:
    image: ghcr.io/jeremiah-k/mmrelay:latest
    container_name: meshtastic-matrix-relay
    restart: unless-stopped
    stop_grace_period: 30s
    user: "1337:20"
    environment:
      - MMRELAY_HOME=/data
      - MMRELAY_READY_FILE=/tmp/mmrelay-ready
      - TZ=UTC # Set timezone (PYTHONUNBUFFERED and MPLCONFIGDIR are set in Dockerfile)

    devices:
      - /dev/ttyACM0
    volumes:
      - mmrelay-data:/data
      - mmrelay-data:/.cache
```

Before starting the container, I created a user and group for it:

```
addgroup --system --gid 1337 mmrelay
adduser --system --uid 1337 --gid 1337 mmrelay
adduser mmrelay dialout
```

I am not sure if it was necessary, but I also fixed the perms on
there:

```
chown mmrelay:mmrelay /var/lib/docker/volumes/mmrelay_mmrelay-data/_data/
```

I could have used `mmrelay config generate` to create a sample configuration
file, but instead I used:

    curl -Lo /var/lib/docker/volumes/mmrelay_mmrelay-data/_data/config.yaml https://raw.githubusercontent.com/jeremiah-k/meshtastic-matrix-relay/main/src/mmrelay/tools/sample_config.yaml

Then edited the configuration:

```diff
--- sample_config.yaml	2026-03-15 20:01:08.939719431 -0400
+++ /var/lib/docker/volumes/mmrelay_mmrelay-data/_data/confia/config.yaml	2026-03-15 21:40:59.802696541 -0400
@@ -44,27 +44,25 @@
   # 4. For interactive setup, use: mmrelay auth login
   #
   e2ee:
-    enabled: true
+    enabled: false
 
   # Message prefix customization (Meshtastic → Matrix direction)
   #prefix_enabled: true # Enable prefixes on messages from mesh (e.g., "[Alice/MyMesh]: message")
   #prefix_format: "[{long}/{mesh}]: " # Default format. Variables: {long1-20}, {long}, {short}, {mesh1-20}, {mesh}
 
 matrix_rooms: # Needs at least 1 room & channel, but supports all Meshtastic channels
-  - id: "#someroomalias:example.matrix.org" # Matrix room aliases & IDs supported
+  - id: "#reseaulibre-meshtastic-bridge:matrix.org" # TODO: invite the bot here and then make room public
     meshtastic_channel: 0
-  - id: "!someroomid:example.matrix.org"
-    meshtastic_channel: 2
 
 meshtastic:
-  connection_type: tcp # Choose either "tcp", "serial", or "ble"
-  host: meshtastic.local # Only used when connection is "tcp"
-  serial_port: /dev/ttyUSB0 # Only used when connection is "serial"
-  ble_address: AA:BB:CC:DD:EE:FF # Only used when connection is "ble" - Uses either an address or name from a `meshtastic --ble-scan`
-  meshnet_name: Your Meshnet Name # This is displayed in full on Matrix, but is truncated when sent to a Meshnet
+  connection_type: serial # Choose either "tcp", "serial", or "ble"
+  #host: meshtastic.local # Only used when connection is "tcp"
+  serial_port: /dev/ttyACM0 # Only used when connection is "serial"
+  #ble_address: AA:BB:CC:DD:EE:FF # Only used when connection is "ble" - Uses either an address or name from a `meshtastic --ble-scan`
+  meshnet_name: RL # This is displayed in full on Matrix, but is truncated when sent to a Meshnet
   message_interactions: # Configure reactions and replies (both require message storage in database)
-    reactions: false # Enable reaction relaying between platforms
-    replies: false   # Enable reply relaying between platforms
+    reactions: true # Enable reaction relaying between platforms
+    replies: true   # Enable reply relaying between platforms
 
   # Connection health monitoring configuration
   #health_check:
@@ -116,7 +114,7 @@
 # These are core Plugins - Note: Some plugins are experimental and some need maintenance.
 plugins:
   # Global setting for all plugins: require bot mentions for commands
-  #require_bot_mention: true  # Set to false to disable mention requirements for all plugins
+  require_bot_mention: false  # Set to false to disable mention requirements for all plugins
   
   ping:
     active: true
@@ -125,13 +123,21 @@
   weather:
     active: true
     #require_bot_mention: true  # Override global setting for this plugin only
-    units: imperial # Options: metric, imperial - Default is metric
+    units: metric # Options: metric, imperial - Default is metric
     #channels: [] # Empty list, will only respond to DMs
   nodes:
     active: true
     #require_bot_mention: true  # Override global setting for this plugin only
     # Does not need to specify channels, as it's a Matrix-only plugin
 
+  health:
+    active: true
+  telemetry:
+    active: true
+  map:
+    active: true
+
+
 #community-plugins:
 #  sample_plugin:
 #    active: true
```

!!! warning

    Again, at this stage, do *not* use the above room
    configuration. Pick your own room!

At this point, the container should be able to start:

    docker-compose up

... and `mmrelay` commands can be ran with:

    docker-compose exec mmrelay mmrelay

The `mmrelay auth login` created the `matrix/credentials.json` file
with an access token the the home server configuration.

A RAK4631 development kit is hooked up to the server over USB, hanging
off the side in a janky setup in my basement. The board itself is
configured [as normal](../guides/meshtastic.md) except:

- hops: 7 (the node is in my basement and will necessarily go through
  at least one hop, and is designed to try to relay things)
- device role: `CLIENT_MUTE`, to avoid re-broadcasting, as we're an
  endpoint

The node itself has limited view of the network and relies on a
second, better positioned, relay to transmit its traffic.[^2]

[^2]: This is not ideal: ideally, we'd connect directly to the better
positioned router, but that router is not actually setup correctly yet
either, so we'll wait. Ultimately, I want to have a relay on the roof
and connect to it with a relay like this over Bluetooth, and I'd
probably install (and upgrade) the bot with `pip` then, on a
single-board computer like a Beagle Board or Raspberry Pi.

Note that in the above patch, there are some [plugins](https://github.com/jeremiah-k/meshtastic-matrix-relay/wiki/Core-Plugins)
enabled as well, see below on how to use those.
