---
date:
  created: 2026-05-22
  actual:  2026-05-22
title: Notes de la rencontre répéteurs le 21 Mai 2026
categories:
  - events
---

Voici les notes de la [rencontre du 21 Mai](2026-05-21-rencontre-repeteurs.md). Merci aux preneurs de
notes!

# Introduction

Nous avions un [agenda](2026-05-21-rencontre-repeteurs.md#agenda) reconnu comme étant ambitieux, à étaler sur
plusieurs rencontres. Nous avons commencé par:

- **agenda**: présenter ledit agenda et l'objectif principal, qui était
  que les gens se rencontre
- **traduction**: voir si nous avions besoin de traduction. une personne
  n'était pas à l'aise de parler en français, mais était à l'aise
  d'écouter, nous avons donc conduit la rencontre en français
- **facilitation**: anarcat s'est porté volontaire pour animer la
  rencontre
- **prise de notes**: deux personnes ont pris des notes et les ont
  communiqué à anarcat par la suite, qui a rédigé ce procès-verbal
- **temps**: deux personnes gardaient le suivi du temps. on a dédié une
  heure à un tour de table, puis une pause, et une heure pour le reste

# Personnes présentes

17 personnes étaient présentes:

- 4 membres du club RADAR du département d'informatique (DIRO) de
  l'Université de Montréal, incluant:
  - 2 radio amateurs
  - un radio amateur potentiel
  - intéressé par Reticulum et la philosophie
- opérateur du relais YUL-Dorval-South
- opérateur du relais YUL-Villeray-Lajeunesse, ancien membre Réseau Libre
- futur opérateur d'un relais sur le plateau et Villeray
- futur opérateur d'un relais sur le plateau, ancien membre Réseau
  Libre, radio amateur
- un curieux qui n'opère pas encore de relais mais intéressé par le
  mesh et Reticulum
- opérateur du relais Furthur à Rosemont
- personne impliquée dans Reticulum après avoir migré d'un déploiement Meshtastic
- opérateur du relais YUL-Little-Italy, site web Réseau Libre, ancien
  membre Réseau Libre, radio amateur
- opérateur des relais YUL-Villeray-Nord, YUL-Poly
- membre du support technique DIRO, opérateur du relais MSH-La-Pomeraie
- ancien membre Réseau Libre
- opératrices des relais YUL-Villeray
- membre du collectif Ilot

Nous avons fait un tour de table où chaque personne a énoncé:

- son nom
- ses pronoms préférés (on a noté 15 "il", déjà un problème de
  représentation de genre!)
- indicatif / sobriquets en ligne
- nom / emplacement du relais actif ou prévu
- objectifs dans la rencontre et le projet

Les noms des gens ainsi que les indicatifs de radio amateurs sont
gardés privés pour respecter la confidentialité des participant·e·s.

Tout le monde était bien content de rencontrer ses voisins de mesh!

S'en suit une pause où plusieurs conversations informelles ont eu
lieu.

# Sommaire technique

Suite à la pause, anarcat a suggéré de changer l'agenda, car le tour
de table a montré que plusieurs personnes n'étaient pas nécessairement
au fait de toutes les technologies en vigueur, particulièrement au
niveau de Reticulum.

anarcat a entrepris un sommaire des 3 technologies principales de mesh
LoRa sur un tableau, en 15 minutes:

| Quoi          | Meshtastic                        | MeshCore                                                        | Reticulum                                                                                       |
|---------------|-----------------------------------|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| Fréquence     | 906.875 MHz                       | 915.525 MHz                                                     | 914.875 MHz                                                                                     |
| Bande passnte | 250 kHz ("LongFast")              | 62.5 kHz                                                        | variable                                                                                        |
| applications  | texte, telemétrie                 | texte, telemétrie                                               | Texte (LXMF), "web" (NomadNet), shell (rnsh), etc                                               |
| Roles         | tous relaient par défaut          | "repeaters" floodent et "compagnons" ne relaient pas par défaut | transport nodes relaient, routage sur plusieurs "interfaces" (LoRa, TCP, Bluetooth, radio, etc) |
| Routage       | flood, pause avant retransmission | flood sauf pour les DMs qui sont routés à la source, régions    | seulement DMs, point à point, annonces en "flood"                                               |

anarcat s'est permis un éditorial sur les limites de Meshtastic, et
des difficultés que le mesh de Montréal a eu jusqu'à ce qu'on adopte
MeshCore. Nous pouvons maintenant communiquer!

S'ensuivi une discussion.

## Discussion informelle

Lequel de ces trois technologies devrions nous prioriser ? Meshtastic, Meshcore,
ou Reticulum. Le consensus semble être que Meshcore fonctionne déjà mieux que
Meshtastic et que Reticulum n'est pas encore facile à déployer.

Pourrait-on commencer par développer Meshcore puis transitionner vers
Reticulum ? C'est probablement faisable.

Que l'on le veuille ou non, des noeuds relieront éventuellement Montréal à
Ottawa. Est ce que le réseau Montréalais sera prêt à recevoir le traffic
supplémentaire que cela représentera ? La question demeure.

Les développements en mesh networking ressemblent aux développements en radio CB
des années 80s, où tout le monde peut parler à tout le monde.

À quelles fins notre mesh network servira ? La question demeure.

Certaines personnes parmis nous aimeraient communiquer avec des gens lointains
comme ceux à Ottawa, Québec, ou même Boston, New York.

Certaines personnes aimeraient voir le réseau qu'on développe comme fallback
autonome dans le cas de désastre naturel ou politique (voir le projet de loi
C22). De plus, le réseau pourrait permettre une connectivité aux personnes loin
dans le nord ignorées par les compagnies de télécom.

Si on veut davantage développer notre réseau, il améliorer l'accès à ce réseau
pour les personnes ayant moins de connaissances techniques dans ce domaine. Il
faut bien communiquer, vulgariser.

# Prochaine rencontre

La prochaine rencontre se déroulera le 11 juin, même heure, même salle.

Le site Web [reseaulibre.ca](https://lora.reseaulibre.ca/) sera bientôt mis à jour pour annoncer
la rencontre formellement. On souhaite de nouveau progresser sur le
reste de l'agenda originalement prévu et établir comment nous prenons
des décisions.

# Organisation contre C-22

Pour conclure, on souligne l'importance de combattre le [projet de loi C-22](https://www.lapresse.ca/affaires/techno/2026-05-14/projet-de-loi-c-22/ottawa-pourrait-faciliter-l-espionnage-de-votre-telephone.php). De
contacter ses représentants. D'appuyer les efforts existants contre la
dite loi:

- [Ligue des droits et libertés](https://liguedesdroits.ca/appel-conjoint-au-retrait-du-projet-de-loi-c-22/)
- [Koumbit](https://www.koumbit.org/fr/content/le-projet-de-loi-c-22-une-menace-notre-vie-privee)
- [OpenMedia](https://openmedia.org/article/item/openmedia-to-secu-withdraw-bill-c-22-or-gut-its-surveillance-provisions)
- [International Civil Liberties Monitoring Group](https://iclmg.ca/fr/arretons-c-22/)

Nous ne devons pas prévoir contourner la loi en assumant qu'elle sera
mise en vigueur mais plutôt nous organiser afin de bloquer cette loi.
