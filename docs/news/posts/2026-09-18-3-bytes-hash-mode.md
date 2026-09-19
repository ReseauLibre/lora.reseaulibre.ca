---
date:
  created: 2026-09-18
title: Prière d'utiliser le routage à 3 octets
categories:
  - announcements
---

En août, plusieurs répéteurs de la grande région de Montréal ont
commencé à expérimenter avec le [routage
multi-octet](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#39-q-what-is-multibyte-support-what-do-1-byte-2-byte-3-byte-adverts-and-messages-mean). Nous recommandons fortement que vous configuriez vos
répéteurs et compagnons pour utiliser le routage multi-octet,
particulièrement si vous avez de la difficulté avec les messages privés
ou l'opération à distance de vos relais.

Les relais à un seul octet sont aussi à risque d'être retirés de la
carte MeshMapper. Le nouveau réglage "Canada" permet de configurer son
appareil correctement.

Cette annonce explique comment configurer son relais et pourquoi nous
effectuons ce changement.

## Comment configurer le routage à 3 octets?

Le project MeshCore a ajouté un réglage "Canada" qui sélectionne
automatiquement le routage en 3 octets. Si vous configurez un appareil
nouveau (ou existant) en utilisant le dernier firmware, choisissez le
réglage "Canada" et votre appareil sera configuré correctement.

Pour les appareils plus anciens, voir [cette question dans la FAQ](https://github.com/meshcore-dev/MeshCore/blob/main/docs/faq.md#393-q-how-do-i-change-my-companions-path-hash-size)
mais généralement, il faut configurer le `Path hash mode` à `3 bytes
(max 21 hops)`, qui est parfois présenté comme `2 - 3 bytes`. Ce
réglage était auparavant caché derrière une section `Experimental
settings` mais est maintenant visible plus directement dans
l'application officielle.

Il est également possible de configurer un appareil en ligne de
commande avec la commande:

    set path.hash.mode 2

La valeur indiquée ici peut être égrante: `2` signifie en fait `3
bytes`. Voici les réglages possibles pour le paramètre:

| `path.hash.mode` | Taille de l'annonce  |
|------------------|----------------------|
| 0                | 1 octet (par défaut) |
| 1                | 2 octets             |
| 2                | 3 octets             |

## Pourquoi un routage à 3 octets?

Le project MeshCore suggère encore le routage sur un octet par défaut
dans la plupart des régions mais a basculé vers 3 octets au Canada. La
logique présentée par le projet pour garder un octet est que les
messages multi-octets sont ignorés par les répéteurs avec une version
inférieur à 1.14 (sortie en mars 2026). Nous croyons que la vaste
majorité des relais dans notre régions roulent une version plus
récente et que ceci n'est pas un problème.

Nous croyons que le mesh ne peut *pas* fonctionner correctement avec le
routage sur un seul octet. Il *faut* donc configurer les relais en
multi-octet.

Le problème fondamental est que un octet, c'est trop court. Un octet
permet d'adresser seulement 256 appareils différents. Pire, à cause du
[paradoxe des anniversaires](https://fr.wikipedia.org/wiki/Paradoxe_des_anniversaires), il y a 50% de chances d'un conflit
avec seulement 20 appareils![^1] Utiliser 2 octets garde la même
chance avec 300 appareils, donc nous croyons qu'il faut les 3 octets,
ce qui nous donne 50% de chance de conflit avec environ 4800 relais.

[^1]: pour les boles en mathématiques, il s'agit de la [séquence OEIS
    A033810](https://oeis.org/A033810), avec `n=256` (`256 = 2**8`) au lieu `n=365`. Vous
    pouvez utiliser le code Python de la séquence pour arriver aux
    chiffres ci-haut:
    
        >>> A033810(2**8)
        20
        >>> A033810(2**16)
        302
        >>> A033810(2**24)
        4823

Les conflits d'identité causent toutes sortes de problèmes:

 1. le routage est plus difficile à diagnostiquer: quand on trace un
    chemin pour déterminer quels relais sont utilisés pour un message,
    on peut trouver des aberrations comme un message qui semble sauter
    des centaines de kilomètres plusieurs fois.

 2. les messages directs sont pratiquement impossibles à router:
    puisque les conflits peuvent arriver avec seulement 20 relais, il
    est très fréquent qu'un mauvais chemin est choisi pour un message,
    ou qu'une route "clignote", alors que des chemins ambigus sont
    annoncés ce qui fait que les messages directs sont perdus

Ceci s'applique aux relais, mais aussi aux compagnons. Puisque le
routage multi-octet est utilisé seulement si le *compagnon* le
demande, les compagnons mono-octet utilisent le mesh comme s'il était
entièrement construit relais mono-octets également!

Régler un mode multi-octet sur votre compagnon va également améliorer
la fiabilité de vos messages privés ("DMs"). Parce que les DMs sont
*routés* (par opposition aux messages de canaux et annonces, qui sont
*innondés*, ou "flooded"), le mode multi-octet est crucial pour
trouver un bon chemin. En configuration mono-octet, cet octet est
ambigu et peut référer à plusieurs relais en conflit. Donc une annonce
reçu peut vous dire de passer par un ensemble de relais qui est en
fait très mauvais pour votre contact, dans une configuration mono-octet.

Ceci s'applique aux messages privés, mais aussi l'opération à distance
des relais, qui opère de façon similaire aux DMs puisqu'ils sont
routés.

Donc, si vous avez des ennuis avec les DMs, ou la gestion des relais à
distance, essayez d'utiliser le mode multi-octet!

## Le multi-octet limite-t-il la taille du mesh?

Les plus assidus remarqueront que le nombre de sauts ("hops") est
réduit par ce changement. La configuration dans l'application indique
en effet:

- `1-byte (max 64 hops)`
- `2-byte (max 32 hops)`
- `3-byte (max 21 hops)`

Nous ne croyons pas que ceci est un réel problème. Limiter le nombre
de sauts dans le mesh est une *bonne chose*, parce que chaque saut
augment exponentiellement le nombre de retransmission, voir [ce
message pour les détails](https://forum.meshcore.ca/t/follow-up-from-salishmesh-swbc-experiences-how-to-deal-with-large-saturated-congested-meshes/38/7?u=anarcat).

Avec 10 sauts, nous avons [contact avec Québec](2026-09-03-quebec-first-contact.md). Nous croyons que,
avec une bonne configuration, nous devrions être capables de connecter
Ottawa et Québec sous la limite des 21 sauts.

## Pourquoi pas 2 octets?

Nous utilisons 3 octets parce que 2 octets n'est pas suffisant. Avec
le paradoxe de l'anniversaire, il y a 50% de chance de conflit avec
seulement 300 relais.

Et bien que Montréal n'ai pas techniquement passé ce stade (en
Septembre 2026), nous avons définitivement plus de 300 relais en
comptant Ottawa (289), Trois-Rivières (37) et Québec (80).

## Commentaires et retours

Nous apprécions vos commentaires et retours sur la proposition par nos
[canaux de communication habituels](../../contact.md) et ce [merge request sur Codeberg](https://codeberg.org/reseaulibre/lora-reseaulibre-ca/pulls/13).

Cet article est également disponible sous l'URL court
<https://lora.reseaulibre.ca/fr/3byte/> pour partager plus facilement
sur le mesh.
