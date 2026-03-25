# History

Réseau Libre and the Montreal mesh has a rich history.

## The Internet era (1970-2010)

In another millennia, the [Internet](https://en.wikipedia.org/wiki/Internet#History) was founded as a decentralized
military/university network called [ARPANET](https://en.wikipedia.org/wiki/ARPANET), between 1969 and
1980, on top of which was developed the [World Wide Web](https://en.wikipedia.org/wiki/World_wide_web)
(1993), on which you are likely reading this text.

At first hindered then co-opted by [large](https://en.wikipedia.org/wiki/AT&T) [telephone
companies](https://en.wikipedia.org/wiki/Telecommunications_company), the network struggled to stay decentralized and
horizontal. Access, which was first free — provided you paid your
phone company — became its own commodity, and has rarely decreased in
price ever since.

In Québec, universities and CÉGEPS were the first to offer internet
access, alongside a hodgepodge crew of small independent
providers. The [RISQ](https://en.wikipedia.org/wiki/R%C3%A9seau_d%27informations_scientifiques_du_Qu%C3%A9bec "eant firs") network was founded in 1989 and still exists to
this day, but almost every other challenger to the large
telecommunication companies (Bell, Québecor, Rogers, and Telus) have
all been absorbed by one of the incumbents.

So apart from a privileged few with data center access or
[knowledge](https://en.wikipedia.org/wiki/Site_reliability_engineering) of the [dark](https://en.wikipedia.org/wiki/Peer-to-peer) [arts](https://en.wikipedia.org/wiki/System_administrator), the Internet never really
materialized its decentralized nature for the commoner. In the year of
the dragon (2000), [hopes were high](https://www.ratm.com/track/war-within-a-breath/) but then the [towers fell](https://en.wikipedia.org/wiki/September_11_attacks)
and a veil of darkness slowly fell over the world.

We consider this as part of the history of "the Montréal mesh",
because there *was* the belief that this Internet could become
something else than classic broadcasting. As it turns out,
telecommunication companies were far from the worst we would see.

## The WiFi era (2010-2020)

In 2011, while Facebook was preparing its IPO, the [Occupy
movement](https://en.wikipedia.org/wiki/Occupy_movement) was taking the world by storm while some hackers in
Montréal and elsewhere were experimenting with WiFi mesh
networks.

There were already well-established community networks then, [Île sans
fil](https://web.archive.org/web/20030826233314/http://www.ilesansfil.org/) (ISF, Montréal, 2003), [Freifunk](https://en.wikipedia.org/wiki/Freifunk) (Berlin, 2003) and
[Guifi.net](https://en.wikipedia.org/wiki/Guifi.net) (Catalonia, 2004), for example, but no "mesh" network
in Montréal proper, ISF having abandoned the mesh idea to focus on
on-premise hot spots.

In 2012, the [Réseau Libre name was picked](https://wiki.reseaulibre.ca/meetings/2012-05-16-decisions/) and the [informal
organization](https://wiki.reseaulibre.ca/) was [founded by people](https://wiki.reseaulibre.ca/meetings/2012-02-15-intro/) from ISF, [Koumbit](https://koumbit.org),
[Foulab](https://foulab.org), [FACIL](https://facil.qc.ca/) and others.

At that point, the goal was not to give internet access but to create
an alternative network, with local services. But by then the ["printemps
érable"](https://en.wikipedia.org/wiki/2012_Quebec_student_protests) was in full swing and people were organizing over the
newer, commercial social networks like Twitter and Facebook.

Réseau Libre nevertheless persevered in researching WiFi mesh
technologies: first with OLSR and BATMAN, then converging over
Babel.

Unfortunately, reaching critical mass seemed impossible: WiFi was
fundamentally hard to deploy because of high power usage and limited
range. The lack of a clear application, especially when people were so
massively transitioning to centralized infrastructure like Amazon,
Google and Facebook, was also found to be demotivating for
some. 

Worries about surveillance were also a concern: in 2013, the [Snowden
revelations](https://en.wikipedia.org/wiki/Snowden_disclosures) showed how much power the state had developed over the
Internet. At that point, TLS was not as pervasive as it has become,
[Let's Encrypt](https://en.wikipedia.org/wiki/Let%27s_Encrypt) disrupting the [Certificate Authority](https://en.wikipedia.org/wiki/Certificate_authority) only from
2014.

At its peak, the Réseau Libre WiFi network had somewhere between 20
and 60 relays, mostly disconnected, with the biggest pocket in
Pointe-Saint-Charles of about half a dozen relays.

After about 6 years of effort, the project slowly died down. The last
[meetings](https://wiki.reseaulibre.ca/meetings/) were held in 2015 while discussions on the mailing list
trickled down to a halt in 2018.

## The LoRa era (2020-?)

Meanwhile a new technology, [LoRa](https://en.wikipedia.org/wiki/LoRa), enters the picture, around 2015. But
it's not until 2020 that more accessible software, namely
[Meshtastic](https://en.wikipedia.org/wiki/Meshtastic) emerges in public view, and later [Reticulum](https://reticulum.network/)
(2022?) and [MeshCore](https://en.wikipedia.org/wiki/MeshCore) (2024).

Folks in Foulab — who had never stopped running a mesh — start hosting
a "mesh night" in 2024 at which point there are already [dozens of
cities with Meshtastic groups](https://web.archive.org/web/20240316074726/https://meshtastic.org/docs/community/local-groups/). More nodes come up in the
summer of 2025 at which point there are hardly a dozen nodes over the
entire city, without significant coverage.

Unbeknownst to the Montreal folks, the [Ottawa Mesh](https://ottawamesh.ca/) is also
working towards their own Meshtastic/Meshcore mesh, with a [presence
of about 50 Meshcore repeaters](https://github.com/MrAlders0n/MeshCore-GOME/commit/3726cfd1764f52c61d6f450beefe9f1ddf500db2).

Shortly after, the Montreal network grows organically and starts to
gain critical mass, with about 60 to 100 relays in the spring of 2026,
at which point <https://lora.reseaulibre.ca> is brought online (in
February 2026) and [added](https://github.com/meshtastic/meshtastic/pull/2281) to the Meshtastic local groups list.

In spring 2026, there are 150 Meshcore repeaters in Ottawa, thousands
on the US west coast, about 20,000 Meshcore repeaters worldwide, and
roughly the same number of Meshtastic MQTT relays, although those
numbers should all be taken with a grain of salt.

Our challenge is communication reliability and crossing the mythical
mountain, an old Réseau Libre dream that now finally seems attainable.

Meanwhile, [there are](https://www.statista.com/statistics/272014/global-social-networks-ranked-by-number-of-users/) 3 billion monthly active users on Facebook,
Whatsapp, and Instagram (all owned by Meta), 2.5B on YouTube (owned by
Google), 2B on TikTok. Surveillance, hate speech, fake content, and
censorship are pervasive on all those platforms. The internet is
[ripping at the seams](https://en.wikipedia.org/wiki/Splinternet), we are reaching [peak oil](https://en.wikipedia.org/wiki/Peak_oil), war is ever
present, and the challenges are tremendous.

But what is sure is that 2026 brings a lot of momentum, and the future
is unwritten. What was left as a dead experiment has been revived, and
we will always have [hope](https://godspeedyoublackemperor.bandcamp.com/album/f-a).

— anarcat, 2026-03-25
