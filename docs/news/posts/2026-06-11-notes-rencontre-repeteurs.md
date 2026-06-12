---
date:
  created: 2026-06-11
  actual:  2026-06-11
title: Notes de la rencontre répéteurs du 11 Juin 2026
categories:
  - events
---

Voici les notes de la [rencontre du 11 juin](2026-05-31-rencontre-repeteurs-2.md). Merci aux preneurs de
notes!

<!-- more -->

## Introduction

Nous avions un [agenda](2026-05-31-rencontre-repeteurs-2.md#agenda) plus modeste que le dernier cette
fois. Nous avons, comme la dernière fois, commencé par cette
introduction:

- **agenda**: présentation 
- **traduction**: voir si nous avions besoin de traduction. une personne
  n'était pas à l'aise de parler en français, mais était à l'aise
  d'écouter, nous avons donc conduit la rencontre en français
- **facilitation**: anarcat s'est porté volontaire pour animer la
  rencontre, encore
- **prise de notes**: Yannick a pris des notes et les a communiqué à
  anarcat par la suite, qui a rédigé ce procès-verbal
- **temps**: Julie a gardé le suivi du temps

## Personnes présentes

La rencontre était hybride et a commencé avec 3 personnes en ligne:

- opérateur relais Bélanger / St-Hubert, `EL-Bot`
- opérateur relais Garnier, bot `#meteo`
- un nouveau (pas encore de relais) de Tétraultville

Puis 10 personnes en personne:

- une personne représentant le RADAR du DIRO
- opérateur du relais `YUL-H2T-MileEnd`
- opérateur du relais `YUL-JeanTalon`
- futur opérateur à Verdun
- opératrice Villeray, Villeray Nord, Poly, IT DIRO
- opérateur relais à St-Hilaire, IT DIRO
- futur opérateur relais, projet Îlot UQAM
- opérateur `YUL-LittleItaly`
- second opérateur Villeray, Villeray Nord, Poly
- un curieux du plateau, plus penché reticulum

Deux personnes se sont ajoutées en cours de rencontre, une en ligne,
et une en personne.

## Présentation Résesau Libre

### Historique

anarcat a fait une présentation de [l'histoire](../../history.md) du projet.

On a repris en gros l'énoncé de l'agenda de la rencontre:

> Réseau Libre est un projet qui existe depuis plus de dix ans (2012),
> avant LoRa (2015), Reticulum ([2018](https://unsigned.io/articles/2018_06_30_15-kilometre-ssh-link-with-rnode.html)), Meshtastic ([2020](https://en.wikipedia.org/wiki/Meshtastic)) and
> MeshCore ([2024](https://en.wikipedia.org/wiki/MeshCore)). Ce projet a existé, et existe toujours avec un
> certain bagage et une [historique](../../history.md) qui est probablement inconnu
> d'une bonne partie des gens qui contribuent présentement à Meshcore.
> 
> Réseau Libre n'est pas Meshcore Canada, Québec, ou Montréal. Le projet
> n'a jamais eu la prétention d'être le *seul* mesh de Montréal,
> même. C'est un projet d'expérimentation et de recherche,
> particulièrement attaché au logiciel libre et à la justice sociale.

Une question a suivi: combien de relais Meshtastic à Montréal? Voir le
[FAQ](https://lora.reseaulibre.ca/guides/faq/#how-many-nodes-in-the-network), présentement moins de 30, en diminution, versus une centaine
Meshcore.

### Valeurs

anarcat a ensuite présenté l'ébauche des [valeurs](../../values.md) du projet, en
notant tout d'abord que, après avoir écrit celles-ci, il semblerait
qu'une nouvelle valeur soit apparu dans le mesh: l'entraide!

Au niveau de la vie privée, on note que le chiffrement par défaut de
Meshcore est mieux que rien, mais qu'il y a des gros enjeux de vie
privée. Reticulum adresse beaucoup de ces problèmes.

## Pause

Nous avons pris une pause de 10 minutes.

## Présentations

Au retour, un nouveau était apparu en ligne, de Dollards-des-Ormaux,
et en personne, l'opérateur `YUL-Villeray-Lajeunesse`.

## Enjeux de vie privée de Meshcore

Suite à des questions dans la présentation des valeurs, anarcat a fait
une courte présentation des différents outils de surveillance déployés
sur meshcore, spécifiquement:

- [Meshmapper](https://yul.meshmapper.net/): opérateurs de l'application divulgent leur
  position, le serveur peut géolocaliser précisément tous les relais

- [live.meshcore.ca](https://live.meshcore.ca/): les observeurs enregistrent tous les paquets,
  publiquement, qui peuvent être ensuite brute-forcés. les DMs
  montrent le chemin des paquets, ce qui identifie généralement la
  position des clients. On peut relativement facilement identifier qui
  parle à qui sur le mesh. Les paquets sont visibles "live" sur ces
  plateformes.

Les observers relaient ces données par MQTT.

Contrairement à Meshtastic, qui utilise l'adresse MAC (impossible à
changer) de l'appareil pour le routage, Meshcore (comme Reticulum)
utilise la clé publique, qui peut être changée. Mais Reticulum a
seulement le "next hop" sur les paquets, pas le chemin complet, ce qui
réduit la fuite de données.

## Propositions

Nous avons adopté plusieurs propositions.

### Meshcore

**Proposition**: Réseau Libre continue sur Meshcore, recherche
Reticulum.

Nous avons discuté d'alternatives telles que LoraWAN et Halow.

Le but de continuer avec Meshcore est qu'on a quelquechose qui marche.

Reticulum n'est pas encore au point:

- les applications viennent tout juste d'arriver à un niveau
  utilisable
- les relais autonomes ne sont pas encore tout à fait au point

La communauté est un peu en crise alors que le développeur principal a
fermé le projet aux contributions extérieurs et changé la licence. Il
y a eu plusieurs forks et une effervescence dans la communauté, mais
la situation est très dynamique.

De la même façon, Meshcore est également en crise au niveau de la
gouvernance, avec le "split". Un autre enjeu avec Meshcore est que
l'application principale est propriétaire (mais a une alternative)
tout comme les firmwares graphiques (e.g. pour le T-Deck).

Pour les gens qui voient seulement des relais Meshtastic, on encourage
de faire une annonce qu'on passe à Meshcore et faire le switch, ça
peut fonctionner. Envoyez [cette annonce](2026-05-02-meshtastic-deprecated.md).

Nous reconnaissons que Reticulum est mieux adapté pour respecter la
vie privée des usagers.

La proposition a été adopté, Réseau Libre continue avec Meshcore et
continuant les recherches sur Reticulum.

### Matrix

**Proposition**: Réseau Libre continue sur Matrix.

Avant, Réseau Libre était sur IRC, puis a passé sur Matrix.

Certaines personnes ne veulent pas avoir à se créer un nouveau
compte. On s'entend qu'on diffuse l'information sur plusieurs
plateformes (incluant Matrix, email, etc), incluant Matrix, qui est la plateforme de clavardage
principale.

On reste sur Matrix, sans empêcher les gens d'aller où ils veulent.

### Site web

**Proposition**: Réseau Libre continue sur le site web
`lora.reseaulibre.ca`.

Il y a aussi un site [`montrealmesh.ca`](https://montrealmesh.ca), avec lequel on a rêvé de
fusionner pendant un temps.

Mais comme le désir de fusionner toutes les communautés, il semble
pour l'instant hors de notre portée de fusionner les deux site.

On aime que le site reste francophone.

On continue à utiliser le site actuel.

### Rencontres en personne

**Proposition**: Réseau Libre s'organise par des rencontres en
personnes, exceptionnellement en ligne si nécessaire, par Jitsi ou sur
le canal [`#reseaulibre-decisions:matrix.org`](https://matrix.to/#/#reseaulibre-decisions:matrix.org).

Pour certains, c'est plus facile en virtuel, mais il était évident
dans la rencontre que la méthode hybrid défavorise largement les gens
en ligne.

On reconnaît aussi qu'il y a un autre rencontre mensuelle, le mesh
night, mais c'est une autre sorte de rencontre. Plutôt une rencontre
de travail, qu'un espace de discussion / décision / organisation.

La disponibilité dépend aussi jour de semaine versus week-end.

### Listes de discussion

**Discussion:** savez-vous que des listes de discussion existent? On
les garde?

Garder annonce, on peut fermer "nodes".

Annoncer les rencontres sur la liste annonce.

## Prochaine rencontre

Personne ne s'est porté volontaire pour organiser une rencontre en
juillet, anarcat le fera pour août.

Quiconque peut organiser un évènement plus "social" et on encourage
bien sûr les gens à aller au mesh night.
