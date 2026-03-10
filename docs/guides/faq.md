---
title: FAQ
---

# Frequently Asked Questions

Here are a couple of questions we have frequently been asked.

## Which device should I buy?

It depends! In general, follow the [guide](index.md), which has devices we
have actually tested.

When in doubt, and starting, get a cheap one (e.g. [HELTEC v4](https://heltec.org/project/wifi-lora-32-v4/)) and
experiment.

If you want to put something on your roof or outside, consider a
self-contained solar node instead of running power all the way out
there.

See also our full [hardware guide](hardware.md).

## Do I need something on my roof?

No. Plenty of people are running relays from their homes, living
rooms, attics, and even cars or backpacks.

## How far can this LoRa thing reach?

As far as the eye can see.

The current Meshtastic record is [330km](https://www.reddit.com/r/meshtastic/comments/1fnduwo/mountain_to_mountain_331_km/) over the Adriatic sea and
LoRa has been recorded as reaching [1336km](https://hackaday.com/2023/09/15/new-lora-distance-record-830-miles/) over the ocean, thanks
to tropospheric conditions.

More practically, you can still expect to reach stations a couple of
kilometers or more, even from inside your house. A node on a rooftop
can reach much further, easily a dozen kilometers, depending on how
clear the view is.

## How many nodes are there in the network?

Hard to tell. The [maps](references.md#maps) seem to show somewhere between 20 and 40
nodes on any given day, but we don't have good metrics of this.

As of 2026-03-09, "from my house", I see about 10 to 20 relays on a
daily basis, with perhaps half a dozen direct contacts.

There are daily messages.

## Is this legal?

Yes. Meshtastic -- or more specifically LoRa -- transmits over [ISM
radio bands](https://en.wikipedia.org/wiki/ISM_radio_band), specifically centered around 915MHz.

Technically, the LoRa protocol itself is patented by the [Semtech
corportation](https://en.wikipedia.org/wiki/Semtech), so there is a non-free aspect to this. It is, in any
case, perfectly legal to *use* LoRa devices as a end-user, but this
means that someone might not have the right to reimplement the LoRa
protocol on its own hardware, for example.

## My question is not here

That is not a question, but ask us, [contact us!](../contact.md)
