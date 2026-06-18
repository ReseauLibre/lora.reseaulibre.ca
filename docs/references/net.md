# Weekly net procedures

Some Wednesdays at 21:00, we have try to hold a weekly "net" on the
Public channel. We also touch base on our [chat channel](../contact.md).

!!! note

    A "[net](https://en.wikipedia.org/wiki/Amateur_radio_net)" is a
    concept borrowed from amateur radio where multiple callers join on
    the same frequency and time to communicate and collaborate. It's
    like a meeting, with a moderator taking speaking turns.
    
    The point of hosting "nets" on the mesh is to give a known time
    window when people can be sure someone is listening on the network
    to see if they can be heard. We also use it to "stress-test" the
    mesh, to make sure contacts can still be made reliably, and
    welcome new people. 
    
    Finally, it's a useful metric to keep track of the growth of the mesh.

## Net Control Guide

On each Wednesday at 21:00 local, send those two messages:

```
Bienvenue au Réseau Libre! Vous pouvez vous signaler avec: "Allo, ici NOM à ENDROIT" Je réponds à tous les messages reçus!
```

```
Welcome to Réseau Libre net! Every Wednesday, you can check-in with: "Hello, this is NAME at LOCATION" I will acknowledge all checkins
```

You can resend those messages a couple of times at, say, one to five
minute intervals, as sometimes messages don't reach out immediately.

Respond to every check-in that you receive and include their name and
location:

```
Net Control in LOCATION received check-in by NAME.
```

It may feel redundant to include names in the messages, but this
ensures all parties have the node name available. Node lists typically
only remember the 100 most recent node names and this is easy to
exceed in high mesh-density areas.

At the end of the net, check out with:

```
Net Control checking out after N contacts.
```

And then send your results to the [chat channel](../contact.md) (list of who was
heard, their location, your location), ideally updating the [log below](#net-control-log).

If no one else is doing it and you're there, you're it, you can call
the net.

While you're there, review the node count in the [How many nodes in
the network?](../guides/faq.md#how-many-nodes-in-the-network) FAQ.

## Net control log

We keep track of past nets here.

### 2026-06-17

| time  | call sign    | location        | hops |
|-------|--------------|-----------------|------|
| 21:00 | `Oots`       | Villeray        | 3    |
| 21:02 | `Cédric`     | La Prairie      | 6    |
| 21:02 | `Erik`       | Vieux Longueuil | 2    |
| 21:03 | `Mad Jap`    | Marieville      | 3    |
| 21:05 | `SbMo`       | Mile End        | 3-4  |
| 21:07 | `Johnputer`  |                 | 4    |
| 21:10 | `VE2XJS`     | Delson          | 5    |
| 21:11 | `VariaLFliP` | Saint-Laurent   | 5    |
| 21:13 | `Carlitos`   | Sainte-Julie    | 4    |
| 21:13 | `Daniel`     | Saint-Jean      | 3    |
| 21:15 | `Normand`    | Saint-Hubert    | 3    |
| 21:15 | `VE2IES`     | Verdun          | 3    |
| 21:22 | `Stef`       | Longueuil       | 2-3  |
| 21:41 | `Massimo`    | Greenfield Park | 5    |

Longueuil repeater [VE2RSM](https://yul.meshmapper.net/?repeater=BF%2C45.53836%2C-73.45851) came online and drastically improved
hop counts and coverage on the south shore.

Observed:

- 13 participants (more than the previous record at 11)
- 109 repeaters in the past week
- 77 companions
- 10 rooms
- [129 nodes in the official map](https://map.meshcore.io/?zoom=7&lat=45.7100&lon=-72.6416)
- [104 repeaters in MeshMapper](https://yul.meshmapper.net/leaderboard.php)

### 2026-06-10

Largest net so far, again:

| time  | call sign          | location      |
|-------|--------------------|---------------|
| 21:00 | `oots`             | Villeray      |
| 21:00 | `uconsole -VE2CKK` | Longueuil     |
| 21:00 | `K836`             | Petite-Patrie |
| 21:01 | `anarcat`          | Petite-Italie |
| 21:02 | `VA2SM`            | Candiac       |
| 21:02 | `Carlitos`         | Sainte-Julie  |
| 21:03 | `MadJap`           | Marieville    |
| 21:04 | `MeshCourte`       | Villeray      |
| 21:07 | `VE2CL`            | La Prairie    |
| 21:20 | `DIR Hochelaga`    | Hochelaga     |
| 21:36 | `FoxRook`          | Laval         |

Usual host was late, SbMo took the above check-ins, then anarcat tried
to pick up again, only to rehash mostly the same people needlessly. :)

The Marieville record still holds, but we beat the number of
participants record (11, previously 7).

Observed:

- 11 participants (above)
- 100 repeaters
- 66 companions
- 9 rooms
- [114 nodes in the official map](https://map.meshcore.io/?zoom=7&lat=45.7100&lon=-72.6416)
- [97 repeaters in MeshMapper](https://yul.meshmapper.net/leaderboard.php)

### 2026-05-27

Largest net so far:

| time  | call sign       | location      |
|-------|-----------------|---------------|
| 21:01 | `K386`          | Petite-Patrie |
| 21:01 | `Arthur`        | Villeray      |
| 21:03 | `LobbyCycliste` | Centre-Sud    |
| 21:05 | `1D19F8FD`      | Mercier       |
| 21:05 | `Mad Jap`       | Marieville    |
| 21:12 | `Guillaume`     | Rosemont      |
| 21:13 | `SbMo`          | Mile-end      |

Operated from `anarcat3`, a WisMesh pocket companion operated from the
Meshy app, and `anarcat1`, a T-Echo companion operated from the
Meshcore Open app, connected to YUL-Little-Italy, a SenseCAP P1. The
original hop counts published here were from the Meshcore open app
which has a [bug displaying multi-byte
messages](https://github.com/zjs81/meshcore-open/issues/367), and have
been removed.

Observed:

- 7 participants (above)
- 3 non-participants sending text messages in Public or another #room
- 54 repeaters
- 17 companions
- 4 rooms
- [89 nodes in the official map](https://map.meshcore.io/?zoom=7&lat=45.7100&lon=-72.6416)
- [66 repeaters in MeshMapper](https://yul.meshmapper.net/leaderboard.php)

This net broke essentially all previous records:

- distance (Marieville, 58.14km)
- participants (7)
- number of repeaters (54!), etc

### 2026-05-20

- 4 contacts:
  - Rivière-des-Prairies
  - Villeray
  - Petite-Patrie
  - Brossard

### 2026-05-13

21:26, one contact (K386, Petite Patrie).

### 2026-04-15

Last Meshtastic net. 

First Meshcore net.

No contact on either.

### 2026-03-25

Meshtastic. 22:52. One contact: "DIR Rooftop", unclear
(just the string "2️⃣"), no location.
