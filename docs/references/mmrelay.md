

```
volumes:
  mmrelay-data:

services:
  mmrelay:
    image: ghcr.io/jeremiah-k/mmrelay:latest
    container_name: meshtastic-matrix-relay
    restart: unless-stopped
    stop_grace_period: 30s
    user: "1337:1337"
    labels:
      - com.centurylinklabs.watchtower.enable=true # Enables automatic updates via Watchtower (if enabled, below)
    environment:
      - MMRELAY_HOME=/data
      - MMRELAY_READY_FILE=/tmp/mmrelay-ready
      - TZ=UTC # Set timezone (PYTHONUNBUFFERED and MPLCONFIGDIR are set in Dockerfile)

    volumes:
      # Mount your config directory - create ~/.mmrelay/config.yaml first
      # See docs/DOCKER.md for setup instructions
      # Use MMRELAY_HOST_HOME (not MMRELAY_HOME) for host paths to avoid conflict with container env
      # For non-SELinux systems (most common):
      - mmrelay-data:/data
      - /dev/ttyACM0:/dev/ttyUSB0
```

addgroup --system --gid 1337 mmrelay
adduser --system --uid 1337 --gid 1337 mmrelay
adduser mmrelay dialout
chown mmrelay:mmrelay /var/lib/docker/volumes/mmrelay_mmrelay-data/_data/


curl -Lo /var/lib/docker/volumes/mmrelay_mmrelay-data/_data/config.yaml https://raw.githubusercontent.com/jeremiah-k/meshtastic-matrix-relay/main/src/mmrelay/tools/sample_config.yaml


`mmrelay config generate` creates the config file as well.

patch config:

```diff
--- sample_config.yaml  2026-03-15 20:01:08.939719431 -0400
+++ /var/lib/docker/volumes/mmrelay_mmrelay-data/_data/config.yaml      2026-03-15 20:02:03.508220496 -0400
@@ -44,24 +44,24 @@
   # 4. For interactive setup, use: mmrelay auth login
   #
   e2ee:
-    enabled: true
+    enabled: false
 
   # Message prefix customization (Meshtastic _ Matrix direction)
   #prefix_enabled: true # Enable prefixes on messages from mesh (e.g., "[Alice/MyMesh]: message")
   #prefix_format: "[{long}/{mesh}]: " # Default format. Variables: {long1-20}, {long}, {short}, {mesh1-20}, {mesh}
 
 matrix_rooms: # Needs at least 1 room & channel, but supports all Meshtastic channels
-  - id: "#someroomalias:example.matrix.org" # Matrix room aliases & IDs supported
+  - id: "#reseaulibre-meshtastic-bridge:matrix.org" # TODO: invite the bot here and then make room public
     meshtastic_channel: 0
-  - id: "!someroomid:example.matrix.org"
-    meshtastic_channel: 2
+  #- id: "!someroomid:example.matrix.org"
+    #meshtastic_channel: 2
 
 meshtastic:
-  connection_type: tcp # Choose either "tcp", "serial", or "ble"
-  host: meshtastic.local # Only used when connection is "tcp"
+  connection_type: serial # Choose either "tcp", "serial", or "ble"
+  #host: meshtastic.local # Only used when connection is "tcp"
   serial_port: /dev/ttyUSB0 # Only used when connection is "serial"
-  ble_address: AA:BB:CC:DD:EE:FF # Only used when connection is "ble" - Uses either an address or name from a `meshtastic --ble-scan`
-  meshnet_name: Your Meshnet Name # This is displayed in full on Matrix, but is truncated when sent to a Meshnet
+  #ble_address: AA:BB:CC:DD:EE:FF # Only used when connection is "ble" - Uses either an address or name from a `meshtastic --ble-scan`
+  meshnet_name: RL # This is displayed in full on Matrix, but is truncated when sent to a Meshnet
   message_interactions: # Configure reactions and replies (both require message storage in database)
     reactions: false # Enable reaction relaying between platforms
     replies: false   # Enable reply relaying between platforms
@@ -125,7 +125,7 @@
   weather:
     active: true
     #require_bot_mention: true  # Override global setting for this plugin only
-    units: imperial # Options: metric, imperial - Default is metric
+    units: metric # Options: metric, imperial - Default is metric
     #channels: [] # Empty list, will only respond to DMs
   nodes:
     active: true
```

Then `mmrelay auth login` creates the `matrix/credentials.json` file
with an access token the the home server configuration.


TODO: extract config from container.
