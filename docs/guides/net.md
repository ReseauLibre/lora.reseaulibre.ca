# Weekly net procedures

Wednesdays at 21:00, we have try to hold a weekly "net" on the
Public channel. We also touch base on our [chat channel](../contact.md).

A "[net](https://en.wikipedia.org/wiki/Amateur_radio_net)" is a
concept borrowed from amateur radio where multiple callers join on
the same frequency and time to communicate and collaborate. It's
like a meeting, with a moderator taking speaking turns.
    
The point of hosting "nets" on the mesh is to give a known time window
when people can be sure someone is listening on the network to see if
they can be heard. We also use it to "stress-test" the mesh, to make
sure contacts can still be made reliably, and welcome new people.
    
Finally, it's a useful metric to keep track of the growth of the mesh
and a good moment to pass announces on the mesh.

Emergency traffic has priority.

## Net Control Guide

If no one else is doing it and you're there, you're it, you can call
the net.

On each Wednesday at 21:00 local, send those two messages:

```
Bienvenue au Réseau Libre! Vous pouvez vous signaler avec: "Allo, ici NOM à ENDROIT" Je réponds à tous les messages reçus!
```

```
Welcome to Réseau Libre net! Every Wednesday, you can check-in with: "Hello, this is NAME at LOCATION" I will acknowledge all checkins
```

You can resend those messages a couple of times at, say, one to five
minute intervals, as LoRa is lossy and some folks might not see all
messages. If you are on a busy segment, you can also say:

```
Reminder: LoRa only handles about one message per second, globally. Wait for silence before speaking, emergencies first.
```

```
Rappel: LoRa est globalement limité à environ un message par seconde. Attendez un silence avant de parler, urgences d'abord.
```

Respond to every check-in that you receive and include their name and
location:

```
hello NAME, reading you in LOCATION over N hops.
```

or:

```
salut NOM, bien recu en EMPLACEMENT sur N hops.
```

It may feel redundant to include names in the messages, but this
ensures all parties known which node you're replying to. If you've
already made your location clear enough already, you can shorten the
message and also welcome who you think are newcomers:

```
welcome to the mesh NAME! N hops.
```

or:

```
bienvenue sur le mesh NOM! N hops.
```

Write down each contact in the [log](../references/log.md).

At the end of the net, check out with:

```
Net Control checking out after N contacts.
```

Upload the [log](../references/log.md) and publish a link to it on the mesh and the [chat channel](../contact.md).

While you're there, review the node count in the [How many nodes in
the network?](../guides/faq.md#how-many-nodes-in-the-network) FAQ.

## Net control log

We keep track of past nets in the [log](../references/log.md).
