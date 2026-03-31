---
title: FAQ
---

# Frequently Asked Questions

Here are a couple of questions we have frequently been asked.


## General questions

### Should I install a relay?

Yes. Even if you don't think you reach other nodes, you might be
surprised and do.

Even if you do set up a relay and you don't see neighbours, it's still
useful to experiment with this technology locally. And besides, this
is how a mesh start: with one node, and then a second...

### What should I buy?

It depends! In general, follow the [guide](meshtastic.md), which has devices we
have actually tested.

When in doubt, and starting, get a cheap one (e.g. [HELTEC v4](https://heltec.org/project/wifi-lora-32-v4/)) and
experiment.

If you want to put something on your roof or outside, consider a
self-contained solar node instead of running power all the way out
there.

See also our full [hardware reference](../references/hardware/index.md).

### Do I need something on my roof?

No. Plenty of people are running relays from their homes, living
rooms, attics, and even cars or backpacks.

But yes, if you *do* have access to a more elevated structure like a
roof, tree or mast, it will reach farther.

### How far can I communicate?

As far as the eye can see.

The current Meshtastic record is [330km](https://www.reddit.com/r/meshtastic/comments/1fnduwo/mountain_to_mountain_331_km/) over the Adriatic sea and
LoRa has been recorded as reaching [1336km](https://hackaday.com/2023/09/15/new-lora-distance-record-830-miles/) over the ocean, thanks
to tropospheric conditions.

More practically, you can still expect to reach stations a couple of
kilometers or more, even from inside your house. A node on a rooftop
can reach much further, easily a dozen kilometers, depending on how
clear the view is.

### How many nodes in the network?

Hard to tell. The [maps](../references/maps.md) seem to show somewhere between 20 and 40
nodes on any given day, but we don't have good metrics of this.

As of 2026-03-09, "from my house", I see about 10 to 20 relays on a
daily basis, with perhaps half a dozen direct contacts.

There are daily messages.

### Is this legal?

Yes. Meshtastic -- or more specifically LoRa -- transmits over [ISM
radio bands](https://en.wikipedia.org/wiki/ISM_radio_band), specifically centered around 915MHz.

Technically, the LoRa protocol itself is patented by the [Semtech
corporation](https://en.wikipedia.org/wiki/Semtech), so there is a non-free aspect to this. It is, in any
case, perfectly legal to *use* LoRa devices as a end-user, but this
means that someone might not have the right to re-implement the LoRa
protocol on its own hardware, for example.

### Are my messages secret?

It depends.

First off, communications on the main "shared" channel ("LongFast")
are encrypted, but with a predefined, shared key. So conversations
there are definitely not secret and should be treated as a public
billboard.

Second, Meshtastic is [encrypted](https://meshtastic.org/docs/overview/encryption/) but lack other key features like
authentication, integrity and perfect-forward secrecy. Only the
message contents are encrypted too, not the routing headers.

This means that you essentially get *some* secrecy; a neighbour might
not be able to tell what you are talking about in some other secret
channel you have setup, but they will be able to:

- see which nodes you are talking to
- replay a message
- pretend they are someone else in your private group if they have
  access to the secret key
- record your messages and decrypt them later if they get access to
  your private key

This sounds minor, but those are significant threats as, for example,
if someone knows you wrote "hi" to a channel, even if they don't have
the encryption key, they can replay that "hi" by sending the exact
same encrypted packet.

Security is hard. Projects like [Reticulum](https://reticulum.network/) [handle this
better](https://reticulum.network/crypto.html).

Physical access to the devices also likely leads to full compromise as
devices can generally be put in "DFU" ([Device firmware upgrade](https://en.wikipedia.org/wiki/USB#Device_Firmware_Upgrade_mechanism))
mode relatively easily. Treat encryption keys from a physically
compromised device to be equally compromised.



## Troubleshooting

### Why can't I contact anyone?

You might be too far away from another relay or blocked by an
obstacle. Or people are just being quiet.

Wait a little while; relays periodically announce themselves and you
should eventually see some relays.

[Make sure you have the right settings](meshtastic.md#settings).

Try to say hi and ask if anyone can read you. People might pick up the
message only much later and respond. Keep your device open.

Try to bring your device higher up or outside.

Look at the [maps](../references/maps.md) to see if there are relays in your
neighbourhood.

Try to [ask for help](../contact.md) or send the command `!ping` in the [Matrix
bridge](https://matrix.to/#/#reseaulibre-meshtastic-bridge:matrix.org) to see if you can hear that bot on the Meshtastic
network. See also the [Matrix bridge usage](matrix.md#usage) for how
to use the bridge.

### Is there a user manual for this GUI?

"This GUI" generally means the [Meshtastic UI](https://meshtastic.org/docs/configuration/device-uis/meshtasticui/) which ships with
device like the Lilygo T-Deck or the Heltec Kit. It's a color
interface design to be touch or cursor driven, as opposed to the [base
UI](https://meshtastic.org/docs/configuration/device-uis/baseui/) which is monochrome and designed to be driven by a single
button.

The user manual therefore depends on the interface:

- [**Meshtastic UI**](https://meshtastic.org/docs/configuration/device-uis/meshtasticui/): color interface
- [**Base UI**](https://meshtastic.org/docs/configuration/device-uis/baseui/): monochrome (typically green on black) interface
- [**InkHUD**](https://meshtastic.org/docs/configuration/device-uis/inkhud/): e-ink interface
- [**Programming mode**](https://meshtastic.org/docs/configuration/device-uis/meshtasticui/#bluetooth-programming-mode): color interface which just says `>>
  Programming mode <<` with a Bluetooth icon

### I am stuck in this user interface, how do I switch?

Again, these are the user interfaces:

- [**Meshtastic UI**](https://meshtastic.org/docs/configuration/device-uis/meshtasticui/): color interface, typically doesn't allow
  connecting from the app, for standalone devices
- [**Base UI**](https://meshtastic.org/docs/configuration/device-uis/baseui/): monochrome (typically green on black) interface,
  limited control on standalone devices (just one button), but grants
  access from the app over Bluetooth
- [**InkHUD**](https://meshtastic.org/docs/configuration/device-uis/inkhud/): e-ink interface
- [**Programming mode**](https://meshtastic.org/docs/configuration/device-uis/meshtasticui/#bluetooth-programming-mode): color interface which just says `>>
  Programming mode <<` with a Bluetooth icon, grants access from the
  app over Bluetooth

If you are in the **Base UI** and you believe your device *can* run
the full **Meshtastic UI** and you don't need to access the device
from your phone, you can switch with:

 1. go into the "system" by clicking the button until "system" shows
    up in the title
 2. hold the button until a menu appears
 3. click the button until you select"Reboot", hold the button
 4. click the button until you select "Switch to MUI", hold the button

To switch from **Meshtastic UI** back to **Base UI** so you can access
it from your phone, you can:

 1. tap on the "gear" icon to go to the Settings section
 2. tap the reboot menu
 3. hold the Bluetooth button
 3. click OK to go back in base UI

If you are in the "[Programming mode](https://meshtastic.org/docs/configuration/device-uis/meshtasticui/#bluetooth-programming-mode)", hold the "Bluetooth" icon
and you should return to the **Meshtastic UI**.

If you lost access to the interface entirely, for example if the MUI
is not supported, you can still go back to the Base UI by connecting
to the device over a USB cable (so-called "serial") and configuring it
to enable Bluetooth in the device settings from the Meshtastic
app. This will disable the Meshtastic UI and *should* reboot in the
Base UI.

## Technology choices
### Why not Reticulum?

We *are* experimenting with Reticulum. Some of us have worked on
[Debian packaging](https://github.com/markqvist/Reticulum/discussions/781), [microReticulum](https://github.com/attermann/microReticulum_Firmware) (to run Reticulum natively
on chip without a second computer), [transport nodes](https://github.com/jrl290/RTNode-HeltecV4) (same, as a
gateway to the Internet), Reticulum-over-Meshtastic, and more!

But Reticulum, while being more advanced in terms of routing and
cryptography, lacks the "ready-made" aspect of Meshtastic. You can,
today, buy a [hardware preinstalled with Meshtastic](../references/hardware/index.md) and it just
works, without anything else. Reticulum is just not there
yet, although projects like [ratdeck](https://github.com/ratspeak/ratdeck) are approaching the
capabilities of Meshtastic and Meshcore in terms of running standalone
routers, and [Columba](https://columba.network/) has tremendously improved the mobile experience.

Reticulum has also [switched to a in-house, non-free license in April
2025](https://github.com/markqvist/Reticulum/commit/e7daceec820850d397e6bf9aa585ef7222977891) and ultimately become "private source", where the GitHub
repository is a "[public mirror](https://github.com/markqvist/Reticulum/blob/master/MIRROR.md)" but development "happens
elsewhere".

Right now the focus is on organizing the mesh that already exists on
the island, and that is mostly made up of Meshtastic nodes. Reticulum
could be a backhaul for the network or the future of the network,
we'll see!

### Why not Meshcore?

We're also considering Meshcore! Many mesh projects including [Puget
mesh](https://pugetmesh.org/meshcore/) and Boston have started experimenting with it.

Right now, they main reason we're not using Meshcore is similar to
Reticulum: the devices and critical mass is on Meshtastic. Meshcore
brings interesting scalability properties to the table, but it's
unclear what improvements it brings to the table in terms of
security. 

Regarding encryption, [this blog post](https://jacksbrain.com/2026/01/a-hitchhiker-s-guide-to-meshcore-cryptography/) seems to indicate issues
with hashtag rooms and [issue #259](https://github.com/meshcore-dev/MeshCore/issues/259) flagged that AES is used in ECB
mode which leaks at least plain text length information and sometimes
full clear text patterns, known as the [ECB penguin problem](https://github.com/robertdavidgraham/ecb-penguin). As of
March 2025, there is a [pull request](https://github.com/meshcore-dev/MeshCore/pull/1677) to *add* "ChaChaPoly AEAD-4
encryption with nonce persistence" in a backwards compatible way,
which is very encouraging.

Furthermore, while some of the Meshcore firmware is free, the
[official Meshcore apps](https://meshcore.co.uk/apps.html) are [non-free and the T-Deck firmware is
proprietary](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#57-q-is-meshcore-open-source). There are a [number of third-party applications](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#514-q-are-there-are-projects-built-around-meshcore),
including an [open app](https://github.com/zjs81/meshcore-open) but Meshcore is generally not as well
integrated as Meshtastic.

Long story short, we'll scale the mesh when we get there. This might
come sooner than we think. We suspect we might be currently limited in
coverage by the Meshtastic hop limit.

### Why LongFast?

We currently stay close to the default Meshtastic settings, which
includes 3 hops limits and the LongFast default. For now, we are not
saturating.

When the time comes, we *will* need to change those defaults, as
others have done in [Tennessee (USA)](https://mtnme.sh/mediumfast/), [Puget Mesh (USA)](https://pugetmesh.org/meshtastic/may2025/) the bay
area (USA) and Wellington (NZ), see the [official blog post](https://meshtastic.org/blog/why-your-mesh-should-switch-from-longfast/) for a
conversation about this.


### Why Matrix?

Also known as "Why are you not on Telegram, Discord, Whatsapp,
Facebook, XMPP, or whatever?"

The real reason we are on Matrix is because we were already there and
people already had accounts. People like to argue that we should be
elsewhere because that is "where every is", but if that was the
argument, everyone should join Whatsapp (3 billion monthly active
users), yet people somehow think they should organise
elsewhere. Typically, it's the place they already use for some other
purpose.

Compared to all those other platforms (with exceptions), Matrix has
properties that are uniquely well suited to the mesh:

- Matrix is *federated*: everyone can run their own server, just like
  the mesh (XMPP is also federated)

- Matrix is *decentralized*: if one server goes down, the other
  servers keep operating normally

- Matrix is *open*: source code for most Matrix implementations
  (client and server) are open source, and the [specification](https://spec.matrix.org/latest/) is
  collaboratively established among multiple stakeholders through
  (XMPP is also open)

- Matrix is *bridged*: there are [multiple bridges](https://matrix.org/ecosystem/bridges/) to many other
  platforms, it is the glue that will allow us to merge together all
  those disconnected communities from Discord, Telegram, Mattermost
  and so on

- Matrix respects your privacy: while there are issues with data
  retention in any federated protocol, Matrix at least won't require
  your phone number (like Whatsapp, Telegram or, sometimes, Discord)
  or deliberately spy on you

- Matrix is *free*: since anyone can run a server, most (if not all)
  [servers](https://servers.joinmatrix.org/) offer free accounts to anyone (see below)

The key aspect is this: Matrix rooms are decentralized. As long as
your home server is reachable from the mesh, the Internet could go
down in flames and Matrix would still work.

This is a property unique to Matrix's design that is rarely seen in
other messaging platforms.

See also [Elements of Matrix](https://matrix.org/docs/matrix-concepts/elements-of-matrix/) for more information about how Matrix
works.

See the [Matrix guide](matrix.md) to get started.

## Other questions

### My question is not here

That is not a question, but ask us, [contact us!](../contact.md)
