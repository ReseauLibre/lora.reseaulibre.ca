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

It depends! In general, follow the [hardware reference](../references/hardware/index.md), which has devices we
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

Yes. LoRa transmitters (used by Meshcore, Meshtastic, and optionally
by Reticulum) use the [ISM radio bands](https://en.wikipedia.org/wiki/ISM_radio_band), specifically centered
around 915MHz.

Technically, the LoRa protocol itself is patented by the [Semtech
corporation](https://en.wikipedia.org/wiki/Semtech), so there is a non-free aspect to this. It is, in any
case, perfectly legal to *use* LoRa devices as a end-user, but this
means that someone might not have the right to re-implement the LoRa
protocol on its own hardware, for example.

### Are my messages secret?

#### In Meshcore

Yes. Messages in Meshcore are encrypted with [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) in ECB mode
which has a [number of issues](https://github.com/meshcore-dev/MeshCore/issues/259) like leaking pattern information
(the [Penguin attack](https://github.com/robertdavidgraham/ecb-penguin)) and length. But generally it's considered to
be stronger than Meshtastic as it does include replay attack
protections.

Those issues have been acknowledged upstream and various proposals
have been brought up to fix the protocol.

#### In Reticulum

Yes. Reticulum uses [strong encryption](https://reticulum.network/crypto.html), including a Signal-like
ratcheting algorithm. To quote upstream, it uses:

> - Ed25519 for signatures
> - X22519 for ECDH key exchanges
> - HKDF for key derivation
> - AES-256 in CBC mode
> - HMAC-SHA256 for message authentication

In all the mesh protocols we're working on, Reticulum has the stronger
security promises.

#### In Meshtastic

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

Make sure you configured your device with the right settings, see our
[Meshcore](meshcore.md#configuration) and [Meshtastic](meshtastic.md#settings) settings.

Try to say hi and ask if anyone can read you. People might pick up the
message only much later and respond. Keep your device open.

Try to bring your device higher up or outside.

Look at the [maps](../references/maps.md) to see if there are relays in your
neighbourhood.

If you're using Meshtastic, consider switching to Meshcore. We've
found Meshtastic reliability to be extremely poor; while it eventually
manages to transmit relay telemetry across the mesh, we are not able
to communicate reliably, while so far the Meshcore mesh has been much
more reliable.

Try to [ask for help](../contact.md)!

### Is there a user manual for this GUI?

#### Meshcore

Liam Cottle wrote a [Meshcore quick start guide](https://files.liamcottle.net/MeshCore/Documentation/MeshCore_Quick_Start_Guide.pdf) for the
proprietary app.

#### Meshtastic

"This GUI" generally means the [Meshtastic UI](https://meshtastic.org/docs/configuration/device-uis/meshtasticui/) which ships with
device like the Lilygo T-Deck or the Heltec Kit. It's a color
interface design to be touch or cursor driven, as opposed to the [base
UI](https://meshtastic.org/docs/configuration/device-uis/baseui/) which is monochrome and designed to be driven by a single
button.

The user manual therefore depends on the interface:

- [**Meshtastic UI**][]: color interface
- [**Base UI**][]: monochrome (typically green on black) interface
- [**InkHUD**][]: e-ink interface
- [**Programming mode**][]: color interface which just says `>>
  Programming mode <<` with a Bluetooth icon

 [**Programming mode**]: https://meshtastic.org/docs/configuration/device-uis/meshtasticui/#bluetooth-programming-mode
 [**InkHUD**]: https://meshtastic.org/docs/configuration/device-uis/inkhud/
 [**Base UI**]: https://meshtastic.org/docs/configuration/device-uis/baseui/
 [**Meshtastic UI**]: https://meshtastic.org/docs/configuration/device-uis/meshtasticui/

### I am stuck in this user interface, how do I switch?

Again, these are the user interfaces:

- [**Meshtastic UI**][]: color interface, typically doesn't allow
  connecting from the app, for standalone devices
- [**Base UI**][]: monochrome (typically green on black) interface,
  limited control on standalone devices (just one button), but grants
  access from the app over Bluetooth
- [**InkHUD**][]: e-ink interface
- [**Programming mode**][]: color interface which just says `>>
  Programming mode <<` with a Bluetooth icon, grants access from the
  app over Bluetooth

If you are in the [**Base UI**][] and you believe your device *can* run
the full [**Meshtastic UI**][] and you don't need to access the device
from your phone, you can switch with:

 1. go into the "system" by clicking the button until "system" shows
    up in the title
 2. hold the button until a menu appears
 3. click the button until you select"Reboot", hold the button
 4. click the button until you select "Switch to MUI", hold the button

To switch from [**Meshtastic UI**][] back to [**Base UI**][] so you can access
it from your phone, you can:

 1. tap on the "gear" icon to go to the Settings section
 2. tap the reboot menu
 3. hold the Bluetooth button
 3. click OK to go back in [**Base UI**][]

If you are in the [**Programming mode**][], hold the "Bluetooth" icon
and you should return to the [**Meshtastic UI**][].

If you lost access to the interface entirely, for example if the
[**Meshtastic UI**][] is not supported, you can still go back to the
[**Base UI**][] by connecting to the device over a USB cable
(so-called "serial") and configuring it to enable Bluetooth in the
device settings from the Meshtastic app. This will disable the
[**Meshtastic UI**][] and *should* reboot in the [**Base UI**][].

## Technology choices
### Why not Reticulum?

We *are* experimenting with Reticulum. Some of us have worked on
[Debian packaging](https://github.com/markqvist/Reticulum/discussions/781), [microReticulum](https://github.com/attermann/microReticulum_Firmware) (to run Reticulum natively
on chip without a second computer), [transport nodes](https://github.com/jrl290/RTNode-HeltecV4) (same, as a
gateway to the Internet), Reticulum-over-Meshtastic, and more!

But Reticulum, while being more advanced in terms of routing and
cryptography, lacks the "ready-made" aspect of the other protocols. You can,
today, buy a [hardware preinstalled with Meshtastic or Meshcore](../references/hardware/index.md) and it just
works, without anything else. Reticulum is just not there
yet, although projects like [Ratdeck](https://github.com/ratspeak/ratdeck) are approaching the
capabilities of Meshtastic and Meshcore in terms of running standalone
routers, and [Columba](https://columba.network/) has tremendously improved the mobile experience.

Reticulum has also [switched to a in-house, non-free license in April
2025](https://github.com/markqvist/Reticulum/commit/e7daceec820850d397e6bf9aa585ef7222977891) and ultimately become "private source", where the GitHub
repository is a "[public mirror](https://github.com/markqvist/Reticulum/blob/master/MIRROR.md)" but development "happens
elsewhere".

Right now the focus is on organizing the mesh that already exists on
the island, and that is mostly made up of Meshtastic and Meshcore nodes. Reticulum
could be a backhaul for the network or the future of the network,
we'll see!

### Why not Meshtastic?

We also support and run Meshtastic! At least to a certain extent: at
the time of writing, there's a mesh of about 100 nodes in
Montreal. But it doesn't scale: while telemetry seems to eventually
make it through the mesh, messaging is extremely lossy up to a point
where one cannot reliably communicate over the mesh.

We are experimenting with Meshcore instead. We still believe there are
interesting use cases for Meshtastic: for smaller communities, it just
works, and it's easier to use than the alternatives.

Plus, Meshtastic is free software, more so than Meshcore at least:
software and firmware are all free software, and documentation is
pretty good. Those are all lessons Meshcore should take a lesson
from. The on-boarding is fantastic as well.

Meshtastic have built a great product and tool chain. They have blazed
the way towards people creating mesh networks all across the planet.

### Why LongFast?

Note that we don't recommend people setup repeaters using Meshtastic,
use Meshcore instead.

That said, in our guide we currently stay close to the default
Meshtastic settings, which includes 3 hops limits and the LongFast
default. This didn't seem to cause saturation, but it did seem like we
were running out of hops.

We suspect that people were regularly changing at *least* the hop
count, because traffic with 7 hops were sometimes observed.

Others have tried experimenting with other settings than LongFast in
[Tennessee (USA)](https://mtnme.sh/mediumfast/), [Puget Mesh (USA)](https://pugetmesh.org/meshtastic/may2025/) the bay area (USA) and
Wellington (NZ), see also the [official blog post](https://meshtastic.org/blog/why-your-mesh-should-switch-from-longfast/) for a
conversation about this.

Ultimately, we do not believe this would have helped the Meshtastic
mesh and instead, we're focusing more on an "infrastructure" approach
with Meshcore.

### Why Meshcore?

We're slowly experimenting with Meshcore more and more! When we first
started working on LoRa in 2025, there were significantly more
Meshtastic than Meshcore relays across the world, but as of April
2026, that trend has reversed, and wildly.

There are now country-wide meshes in the UK and large parts of Europe,
including Germany and the Netherlands. The [Puget mesh](https://pugetmesh.org/meshcore/) seem on
their way to connect Vancouver to California.

With Meshcore, there is a distinction between routers and clients. And
while mesh "purists" might feel this is a tragic treason of
fundamental principles, mesh veterans know that a mesh is just another
piece of infrastructure. There is necessarily some level of
organization (and chaos) in a mesh, and the sooner we realize and
acknowledge those power structures, the sooner we can avoid
[The Tyranny of Structurelessness](https://www.jofreeman.com/joreen/tyranny.htm) ([Wikipedia](https://en.wikipedia.org/wiki/The_Tyranny_of_Structurelessness)).

The stronger distinction between the device roles in Meshcore forces a
more deliberate approach in building necessary infrastructure. With
[over a dozen device roles](https://meshtastic.org/docs/configuration/radio/device/), this is one of Meshtastic's weak
point. Even after months of experimentation with Meshtastic, who
really knows [how to chose the right device role](https://meshtastic.org/blog/choosing-the-right-device-role/), even after
reading that blog post?

Security is a bit of a mixed bag (see below), but it feels like
Meshcore's cryptographic design is slightly more solid than Meshtastic
utterly trivial design. There is some authentication to thwart replay
attacks, something which Meshtastic still struggles with. It is far
from being as solid as Reticulum, which is closer to Signal in terms
of security properties, but it's a bit of a "worse is better" in this
case: Meshcore's simpler cryptographic design means it's lighter to
implement and there are already lots of devices that can run Meshcore
firmware, while Reticulum is still struggling to embed on a few.

In March 2026, we said we'd "scale the mesh when we get there". A
month later, it already feels like we're there since, as we said,
"this might come sooner than we think".

### Why not Meshcore?

There *are* serious problems with Meshcore, that said, that make us a
little uncomfortable with its massive adoption.

Regarding encryption, [this blog post](https://jacksbrain.com/2026/01/a-hitchhiker-s-guide-to-meshcore-cryptography/) seems to indicate issues
with hashtag rooms and [issue #259](https://github.com/meshcore-dev/MeshCore/issues/259) flagged that AES is used in ECB
mode which leaks at least plain text length information and sometimes
full clear text patterns, known as the [ECB penguin problem](https://github.com/robertdavidgraham/ecb-penguin). As of
March 2025, there is a [pull request](https://github.com/meshcore-dev/MeshCore/pull/1677) to *add* "ChaChaPoly AEAD-4
encryption with nonce persistence" in a backwards compatible way,
which is encouraging, but a year later, the effort doesn't seem to
have realized significant progress yet.

Furthermore, while some of the Meshcore software is free, the
[official Meshcore apps](https://meshcore.io/#download) are non-free and a lot of [firmware is
proprietary](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#57-q-is-meshcore-open-source). There are a [number of third-party applications](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#514-q-are-there-are-projects-built-around-meshcore),
including an [open app](https://github.com/zjs81/meshcore-open) but Meshcore is generally not as close to
open source ethos as Meshtastic, or Reticulum.

For example, the main discussion channel for Reticulum is, of course,
on Matrix. Virtually everything Meshcore is on Discord instead, a
[controversial commercial chat provider](https://en.wikipedia.org/wiki/Discord#Criticisms_and_controversies), a closed platform with
[questionable monetization strategies](https://en.wikipedia.org/wiki/Discord#Monetization) that is one IPO away from a
Slack-style rug-pull. The local mesh is trying to pull people towards
Matrix through bridging and advocacy, but it's an upward slope.

Finally, the way routing works in Meshcore is that the path is encoded
in packets in clear text. This means an attacker watching the mesh can
tell where, generally, you are. On a normal communication (say, when
you're home), your packets will go through a certain repeater and
then, if you move around, your packets will go through a different
repeater.

While there's an aspect of this that's inherent to any radio
communication, it's particularly tricky with Meshcore because those
paths are encoded in the packet itself, which travels of course much
further than the local LoRa range. Meshtastic doesn't share that
problem as much since it's mostly flood-routed. Reticulum doesn't have
that problem because routers only know about their neighbors and
routes identity-based.

We consider this anonymity issue to be an acceptable trade-off:
repeaters don't *have* to keep track of their users locations (and
most don't). Compare this to cell phone towers, for example. Not only
do towers precisely locate their users by triangulation, they also
resell that private information to data brokers which can then become
accessible for a small fee, bypassing decades of traditional legal
protection against unreasonable search and seizure.

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
