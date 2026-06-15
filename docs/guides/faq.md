---
title: FAQ
---

# Frequently Asked Questions

Here are a couple of questions we have frequently been asked.

## General

### Should I install a relay?

Most likely, yes. Even if you don't think you reach other nodes, you
might be surprised and do.

Even if you do set up a relay and you don't see neighbours, it's still
useful to experiment with this technology locally. And besides, this
is how a mesh start: with one node, and then a second...

Still, please take a look at the [Meshmapper coverage](https://yul.meshmapper.net/) or [other
maps](../references/maps.md) to see if a relay in your area would help. Some areas already
have pretty good coverage and might not need an extra repeater, which
might add noise.

A good rule of thumb is to setup a non-repeating device (a "companion"
in Meshcore) and see if you see other repeaters. If you can
communicate with others, you don't need to install a relay.

### Do I need something on my roof?

No. Plenty of people are running relays from their homes, living
rooms, attics, and even cars or backpacks.

But yes, if you *do* have access to a more elevated structure like a
roof, tree or mast, it will reach farther.

### What should I buy?

It depends! In general, follow the [hardware reference](../references/hardware/index.md), which has devices we
have actually tested.

When in doubt, and starting, get a cheap one (e.g. [HELTEC v4](https://heltec.org/project/wifi-lora-32-v4/)) and
experiment.

If you want to put something on your roof or outside, consider a
self-contained solar node instead of running power all the way out
there.

See also our full [hardware reference](../references/hardware/index.md).


### How far can I communicate?

As far as the eye can see.

The current Meshtastic record is [330km](https://www.reddit.com/r/meshtastic/comments/1fnduwo/mountain_to_mountain_331_km/) over the Adriatic sea and
LoRa has been recorded as reaching [1336km](https://hackaday.com/2023/09/15/new-lora-distance-record-830-miles/) over the ocean, thanks
to tropospheric conditions.

More practically, you can still expect to reach stations a couple of
kilometers or more, even from inside your house. A node on a rooftop
can reach much further, easily a dozen kilometers, depending on how
clear the view is.

As of 2026-05-11, the [current record](https://yul.meshmapper.net/leaderboard.php) is 21.5km across Lac
Saint-Louis, by [`YUL_Dorval-South`](https://yul.meshmapper.net/index.php?repeater=D0,45.43988,-73.73579).

### How many nodes in the network?

Hard to tell. The [maps](../references/maps.md) seem to show somewhere between 20 and 40
nodes on any given day, but we don't have good metrics of this.

We're trying to keep track of how many relays we see on [the maps](../references/maps.md),
over time:

| Date       | Meshcore | Meshtastic |
|------------|----------|------------|
| 2026-03-18 | 3-25     | 23-51      |
| 2026-04-24 | 17-47    | ~25        |
| 2026-05-11 | 35-65    | 27-40      |
| 2026-05-27 | 66-89    | 22-34      |
| 2026-06-10 | 97-114   | 16-29      |

Links used to extract those numbers:

- Meshtastic: [high](https://meshtastic.liamcottle.net/?lat=45.744526980468436&lng=285.7461547851563&zoom=8), [low](https://meshmap.net/), [lowest](https://map.mt.gt/)
- Meshcore: [high](https://map.meshcore.io/?zoom=8&lat=45.6486&lon=-72.9767), [low](https://yul.meshmapper.net/leaderboard.php)

## Software

### How do I upgrade?

Typically, devices can be safely upgraded by flashing them with the
new version. For Meshcore, follow the [Flash the firmware on the
device](meshcore.md#flash-the-firmware-on-the-device) instructions and, if you have the device properly
configured, the [OTA upgrades](meshcore.md#ota-upgrades).

To be on the safer side, it's always a good time to perform a backup.

Just make sure to avoid doing an "erase"!

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

We now have a [guide on getting started with Reticulum](reticulum/index.md) as well.

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

People interested in Reticulum are welcome to join us at Foulab's Mesh
Night (every first Wednesday of the month) where we do a lot of
research on Reticulum.

### Why not Meshtastic?

Once upon a time, there was a mesh of about 100 Meshtastic nodes in
Montreal. But it didn't scale: while telemetry eventually
trickled out through the mesh, messaging was extremely lossy, so much
that one could reliably communicate over the mesh.

There might still be interesting use cases for Meshtastic: for smaller
communities, it just works, and it's somewhat easier to use.

Meshtastic is also free software, more so than Meshcore, for example:
software and firmware are all free software, and documentation is
pretty good. Those are all lessons Meshcore should take a lesson
from. The on-boarding is fantastic as well.

Meshtastic have built a great product and tool chain. They have blazed
the way towards people creating mesh networks all across the
planet. But given that Meshcore also has a routing companion now, it's
not clear to us there's still a use case for Meshtastic anymore.

### Why LongFast?

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

Obviously, the Meshcore community is organised a mostly through
Discord, and we're not there. We are on Matrix is because we were
already there before Meshcore existed, and we are not just about
Meshcore.

Some people claim there are more people on Discord than Matrix in
general, but we dispute those claims.[^1]

[^1]: Here is a select number of social networks and their size in
    monthly active users, as of 2026-05-28, mostly from [this 2025
    report](https://www.statista.com/statistics/272014/global-social-networks-ranked-by-number-of-users/) unless otherwise noted:

      * Facebook: 3.07 billion MAU ("may be out of date")
      * WhatsApp: 3.00B
      * Instagram: 3.00B
      * YouTube: 2.58B ("ad reach")
      * TikTok: 1.99B ("ad reach")
      * WeChat: 1.41B
      * Telegram: 1B
      * Messenger: 942 million ("may be misrepresented")
      * Snapchat: 932M
      * Reddit: 765M
      * Matrix: 200M "users" ([according to
      Element](https://element.io/en)), was [60M in
      2022](https://www.theregister.com/on-prem/2022/07/15/matrix-messaging-service-leaps-60-million-user-barrier/1562103)
      and [28M in 2021](https://www.youtube.com/watch?v=TzUfS08lMek&t=265s)
      * Signal: 70-100M users ([according to their CEO](https://tech-insider.org/signal-vs-telegram-2026/))
      * Discord: 90M+ "daily active users" (according to
      [discord.com](https://discord.com/company)), 150M MAU in 2024,
      [according to Wikipedia](https://en.wikipedia.org/wiki/Discord)
      * Meshcore: [46,546 devices world wide](https://map.meshcore.io/)

    So, if actual numbers of users were a real criteria for picking a
    platform, people would organise primarily on Facebook or Telegram
    (and indeed, lots of people are), but clearly not on Discord,
    which is primarily a gaming platform.

    The reality is people organize where they already are, and can't
    be moved around easily, because [communities are not fungible](https://www.joanwestenberg.com/communities-are-not-fungible/).

Compared to all those other platforms (with exceptions), Matrix has
properties that are uniquely well suited to the mesh:

- Matrix is **federated**: everyone can run their own server, just like
  the mesh (XMPP is also federated)

- Matrix is **decentralized**: if one server goes down, the other
  servers keep operating normally

- Matrix is **open**: source code for most Matrix implementations
  (client and server) are open source, and the [specification](https://spec.matrix.org/latest/) is
  collaboratively established among multiple stakeholders through
  (XMPP is also open)

- Matrix is **free**: since anyone can run a server, most (if not all)
  [servers](https://servers.joinmatrix.org/) offer free accounts to anyone (see below)

- Matrix is **bridged**: there are [multiple bridges](https://matrix.org/ecosystem/bridges/) to many other
  platforms, it is the glue that will allow us to merge together all
  those disconnected communities from Discord, Telegram, Mattermost
  and so on

- Matrix **respects your privacy**: while there are issues with data
  retention in any federated protocol, Matrix at least won't require
  your phone number (like Whatsapp, Telegram or, sometimes, Discord)
  or deliberately spy on you

The key aspect is this: Matrix rooms are decentralized. As long as
your home server is reachable from the mesh, the Internet could go
down in flames and Matrix would still work.

This is a property unique to Matrix's design that is rarely seen in
other messaging platforms.

See also [Elements of Matrix](https://matrix.org/docs/matrix-concepts/elements-of-matrix/) for more information about how Matrix
works.

See the [Matrix guide](matrix.md) to get started.

### Why *not* Matrix?

A few arguments can be made against Matrix which, of course, is not
perfect. We explain a few of those issues so people are aware of the
downsides and to preempt complaints about them:

- **Encryption**. Matrix's end-to-end security is not as strong as
  other platforms like Signal. Room membership is defined by the
  servers which have more power than they should. A lot of information
  travels out of band, in clear text.

- **Encryption usability**. Matrix infamously suffers from "cannot
  decrypt message" kind of issues, where past message cannot be
  reliably read on all devices. This seems to be a high priority
  for the Matrix team, and is less of an issue than before.

- **Interoperability**. While Matrix is an open standard with strong
  compatibility promises across multiple clients, the reality of this
  is that the compatibility across client is somewhat spotty. Not all
  features (like spaces, threading, or video) are implement across all
  clients, and certainly not in the same user interface, so it can be
  confusing to onboard people across multiple client
  implementations. It is best for users to use the flagship client
  (Element) to avoid those issues.

- **Data retention**. By default, federated rooms copy messages across
  every home server with a user connected to the room. This means that
  messages get retained across multiple servers which have different
  retention policies. Worse, the *defaults* are to keep messages
  forever, which affects `matrix.org`, so it is difficult to ensure
  automatic message expiry across the federation. Message redaction
  *should* be better supported however.

- **Moderation**. The Matrix protocol itself has mechanisms to redact
  messages and ban users, but lacks large-scale moderation systems
  across rooms and the federation, which are typically handled by
  bots. This leads to abuse being sometimes more a problem on Matrix
  than on other platforms, although work is being done on that front
  as well.

Overall, we find that the benefits of using Matrix (federated,
decentralized, open, free, bridged, respects your privacy) far
outweigh those inconveniences, since the alternative also fail at many
of those challenges. For example, Discord doesn't implement end-to-end
encryption at all, is not operable, and leaves no control over data
retention to the user.

### Which radio frequencies are you using?

We're using the defaults!

- MeshCore: "US/Canada" preset (910.525 MHz, 62.5 kHz, SF7, CR5)
- Meshtastic: "US" preset, LongFast (906.875 MHz, 250kHz, SF 11, CR5)
- Reticulum: "Ottawa" preset (914.875 MHz, 125 kHz, SF7, CR7)

For Reticulum, there is less standardization on those settings, so
people often pick arbitrary numbers. Obviously, avoid the frequencies
used by MeshCore and Meshtastic. The frequencies above are not
overlapping and look something like:

- MeshCore: 910.49375 to 910.55625 MHz (910.525 MHz with 62.5 kHz
bandwidth or ± 31.25 kHz)
- Meshtastic: 906.750 too 907.0 MHz (906.875 MHz with a 250 kHz
  bandwidth or ± 125 kHz)
- Reticulum: 914.8125 to 914.9375 (914.875 MHz with a 125 kHz
  bandwidth or ± 62.5 kHz)

You can use [this tool from the Reticulum community](https://unsigned.io/understanding-lora-parameters/) as a good
introduction to the LoRa parameters.

Keep in mind when we say a *frequency* it is the *center* frequency,
so you need to calculate the bandwidth *around* the frequency to make
sure you do not interfere.

In general, we operate within the [ISM bands](https://en.wikipedia.org/wiki/ISM_radio_band#Frequency_allocations) which is, in our
region, 902 to 928MHz, also known as the [33 cm band](https://en.wikipedia.org/wiki/33-centimeter_band), which can be
quite crowded! It can also receive interference from nearby [UHF
bands](https://en.wikipedia.org/wiki/Ultra_high_frequency#United_States) of course, particularly if you are near a cell phone tower.

### What do those radio settings even mean?

Bandwidth? Spread factor? Coding rate? What do all those things mean?

While explaining all of Radio is beyond the scope of this FAQ, you
should know a few basic things while configuring LoRa radios,
particularly in Reticulum where there are less strictly defined
presets:

- **Frequency** - This needs to match between nodes. It is somewhat
  arbitrary, but can be chosen based on context-specific factors like
  local radio interference, existing use by other LoRa platforms,
  available antenna sizes, and local regulations.

- **Bandwidth** and **Spreading Factor** - These both need to match
  between nodes. They both offer tradeoffs between speed of data
  exchange, and distance of effective communication.

- **Coding Rate** - This does not need to match between nodes. It is
  the amount of error correction, so more of it slows down speed of
  data exchange (and slightly increases power consumption), but makes
  communication more reliable, especially important when there is a
  lot of radio interference at the frequency being used.

- **TX power** - This does not need to match between nodes. Higher
  levels will transmit further, be easier for anyone to detect and
  locate, will consume more power, and can cause overload problems if
  two nodes are right next to each other and transmitting at high
  power. Higher power levels are also more likely to be regulated. The
  maximum level varies by LoRa device.

See also the Reticulum [LoRa Bitrate & Sensitivity Calculator](https://unsigned.io/understanding-lora-parameters/) guide.

## Other questions

### My question is not here

That is not a question, but ask us, [contact us!](../contact.md)
