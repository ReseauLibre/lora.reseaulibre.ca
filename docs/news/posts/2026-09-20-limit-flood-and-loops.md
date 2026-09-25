---
date:
  created: 2026-09-25
title: Prière de limiter les annonces, boucles et "floods"
categories:
  - announcements
---

Ça bouge sur le mesh!

Après des discussions et tests avec plusieurs personnes clé à
Montréal et ses environs, nous vous encourageons fortement à faire les
changement suivants sur vos répéteurs:


- [Loop detection](https://docs.meshcore.io/cli_commands/#view-or-change-this-nodes-loop-detection): `moderate`, `off` par défaut
- [Zero hop advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-zero-hop-advert-interval): `240` (en minutes, `60` par défaut)
- [Flood advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-flood-advert-interval): `47` (en heures, `12` par défaut)
- [Number of hops for a flood message](https://docs.meshcore.io/cli_commands/#limit-the-number-of-hops-for-a-flood-message): `16` (`64` par défaut)

Sur la ligne de commande, c'est équivalent aux commandes suivantes:

```
set loop.detect moderate
set advert.interval 240
set flood.advert.interval 47
set flood.max 16
```

Pour les répéteurs avec plusieurs voisins (30-50), nous conseillons
également d'augmenter le `txdelay`:

- [Re-transmit delay for flood traffic](https://docs.meshcore.io/cli_commands/#view-or-change-the-retransmit-delay-factor-for-flood-traffic): `1` (`0.5` par défaut)
- [Re-transmit delay for direct traffic](https://docs.meshcore.io/cli_commands/#view-or-change-the-retransmit-delay-factor-for-direct-traffic): `0.5` (`0.2` par défaut)

Commandes équivalentes:

```
set txdelay 1
set direct.txdelay 0.5
```

Nous ne recommandons pas présentement de changer le [`rxdelay`]( https://docs.meshcore.io/cli_commands/#experimental-view-or-change-the-processing-delay-for-received-traffic).

<!-- more -->

## Qui?

Ces réglages ont été testés par les opérateurs-trices et répéteurs suivants:

- `anarcat`: `YUL-Little-Italy`
- Smog: `YMX-J6Y`
- `Oots`: `YUL-Villeray/Garnier`
- `VA2DG`: `VA2DGR Repeater`
- `Johnputer`: `YUL-Cartierville`, `YUL-UpperSalaberry`

## Pourquoi?

On grandit vite! En Janvier, il n'y avait essentiellement aucun
répéteur MeshCore à Montréal, mais nous avons depuis passé le cap des
100 (en juinx) puis 200 (août) rapidement. Nous sommes sur le point de
connecter Ottawa et Québec, ce qui nous amènerait à environ un millier
de répéteurs.

Et bien qu'il faut éventuellement réfléchir à comment segmenter le
réseau en régions, ceci est un projet plus complexe et controversé que
les quelques modifications proposées ici pour améliorer notre capacité.

Voyons donc chaque réglage à tour de rôle et comment ils nous aident.

### Détection de boucles

Par défaut, MeshCore n'a pas de détection de boucle, ce qui signifie
qu'il est techniquement possible pour un paquet de repasser par un
point déjà visité. En Mars, [MeshCore 1.14 a introduit la détection de
boucle](https://buymeacoffee.com/ripplebiz/path-diagnostics-improvements) mais ne l'a pas activé par défaut.

Avec une [adoption plus large des modes multi-octet](2026-09-18-3-bytes-hash-mode.md), nous croyons
qu'il s'agit d'un réglage sans danger: le réglage a été choisi parce
que nous voulons que les répéteurs à 2 octet fonctionnnent toujours en
cas de conflit.

Le changement aura un impact sur les répéteurs à simple octet qui sont
en double, alors nous encourageons les compagnons à [passer en mode
multi-octet](2026-09-18-3-bytes-hash-mode.md).

### Limiter les annonces

Les trois autres réglages ([Zero hop advert interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-zero-hop-advert-interval), [Flood advert
interval](https://docs.meshcore.io/cli_commands/#view-or-change-the-flood-advert-interval) and [Number of hops for a flood message](https://docs.meshcore.io/cli_commands/#limit-the-number-of-hops-for-a-flood-message)) sont tous
conçus pour limiter le trafic de télémétrie sur le mesh.

Les annonces sont le plus gros paquet sur le mesh, et utilisent donc
le plus grand temps d'antenne. Et bien qu'ils sont utiles parce qu'ils
montrent où sont les répéteurs, ils ne sont en fait pas nécessaire
pour faire fonctionner le mesh.

Présentement, les annonces inondent les mesh du UK et du Pacific
Northwest. Ils ont passé la masse critique où le produit du nombre de
relais et de la fréquence d'annonce implique que le mesh relaient
constamment de la télémétrie au lieu du contenu.

L'intervalle d'annonce locale a été augmenté de une à six heures, pour
s'assurer que les nouveaux compagnons voient les relais locaux
apparaître durant le premier jour.

L'intervalle d'annonce "flood" (inondée?) pass de deux fois par jour à
une fois tous les *quatre* jours, ce qui permet encore de construire
une bonne carte du réseau sur une semaine. Elle est réglée à 4 jours
moins une heure pour que l'heure d'annonce recule d'une heure chaque
jour, pour éviter que les relais inondent toujours à la même heure
chaque jour.

En regardant les [métriques](https://dev.meshcore.ca/?iata=YUL&tab=Analytics&range=30d), on voit qu'on passe beaucoup de temps
(16%, ou un paquet sur six!) à faire des annonces. Au moment d'écrire
ces lignes (2026-09-20), nous avons ce nombre de paquets durant les
dernier 30 jours:

| Type              | Nombre  | Ratio | Note                                |
|-------------------|---------|-------|-------------------------------------|
| Group text        | 271664  | 26%   | Messages sur les canaux, bien.      |
| Request           | 262860  | 25%   | Innattendu, voir ci-base            |
| Advert            | 188927  | 16%   | Ce qu'on veut résoudre!             |
| Text message      | 87445   | 8%    | Messages privés                     |
| Response          | 84382   | 8%    | Relié aux "Request"                 |
| Control           | 60127   | 6%    |
| Anonymous request | 43458   | 4%    |
| Path              | 42249   | 4%    |
| Others            | ~10000  | ~1%   |
| **TOTAL**         | 1051112 | 98%   | Pardonnez l'erreur d'arrondissement |

## Et que fait-on des régions?

Les régions sont... plus compliquées. Elles demandent des changements
plus approfondis, possiblement en rupture, aux configurations et ne
sont pas généralement utilisés. Les réglages ci-haut ont été testés
sur des relais et sont connus comme étant sans danger, tout en
améliorant le mesh.

Ceci dit, il y a pésentement une [nouvelle proposition de régions en
discussion](https://meshcore.ca/proposals/onqc-scopes/) que nous ramènerons ici bientôt.

## Et que faire des requêtes?

En écrivant la section ci-haut, nous avons découvert avec surprise une
grande quantité de trafic sur le mesh qui était du type
["request"](https://docs.meshcore.io/payloads/#request).

Nous aimerions régler ce problème également, mais nous ne savons pas
quelle en est la cause, ou comment le résoudre. Nous espérons que de
changer au [routage multi-octet](2026-09-18-3-bytes-hash-mode.md) va améliorer le nombre de paquets
du genre qui vont inonder le réseau, ceci dit.

## Commentaires

Dans tous les cas, nous aimerions avoir vos commentaires sur cette
proposition par nos [points de contact habituels](../../contact.md) et la [merge
request sur Codeberg](https://codeberg.org/reseaulibre/lora-reseaulibre-ca/pulls/14).
