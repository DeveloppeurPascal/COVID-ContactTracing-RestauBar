# COVID-ContactTracing-RestauBar

Logiciel de suivi et enregistrement des clients dans les établissements recevant du public.

A la base ce projet était un POC. Il sera cependant mis en production. Vous avez les détails de la version publique et exploitable des logiciels clients et établissements sur le site [CCTRB](https://cctrb.fr) où vous trouverez les liens de téléchargement des programmes installables lorsqu'ils seront disponibles.

-----

## Serveur alternatif

Les sources de la version PHP du serveur d'API utilisé par [CCTRB](https://cctrb.fr/) sont [disponibles sur ce dépôt](https://github.com/DeveloppeurPascal/CCTRB-PHP-API-Server).

Les deux ont été séparés pour simplifier leur codage dans des arborescences ou machines virtuelles différentes selon la configuration de chaque développeur.

-----

## TODO LIST:

### Logiciel CCTRB mobile

* changer le chemin de stockage des paramètres pour s'assurer de leur effacement en même temps que l'application ou proposer une option pour les effacer (ou envoyer sur l'option de l'OS pour ça, sur Android)
* adapter la lecture du QR Code à son nouveau format
* vérifier format Date/Heure des écrans cas contact (AAAAMMJJHHMMSS ou JJ/MM/AAAA HH:MM:SS)

### Serveur

* impacter les "cas contact" sur la base de données d'historiques lors de l'API deccovidplus

### Logiciel Etablissement

* changer la génération du QR Code pour y ajouter une part d'aléatoire et de clé privée
* vérifier format Date/Heure des écrans cas contact (AAAAMMJJHHMMSS ou JJ/MM/AAAA HH:MM:SS)
* s'assurer que le Bitmap du QRCode est dessiné avec la bonne résolution (vérifier son TBitmap.BitmapScale lors des dessins selon la résolution de l'écran et la profondeur des pixels)

-----

## Dépendances du projet

Ce projet a des dépendences déclarées comme sous-modules. Cela permet de les télécharger automatiquement si vous rapatriez le projet avec git en mode récursif.

Si vous téléchargez les sources sous forme de ZIP il vous faudra ajouter le contenu de ces dépendances directement dans leur sous-dossier ou adapter les programmes avant de les compiler.

https://github.com/DeveloppeurPascal/librairies stocké dans lib-externes/librairies
=> des procédures et fonctions utilisées dans le projet (notamment pour le stockage des configurations et le calcul de checksum)

https://github.com/foxitsoftware/DelphiZXingQRCode stocké dans lib-externes/DelphiZXingQRCode 
=> pour la création des QR Code dans le programme destiné aux établissements

https://github.com/Spelt/ZXing.Delphi stockée dans lib-externes/ZXing.Delphi
=> pour le scan des images de la caméra et l'interprétation des QR codes

Plus d'informations sur https://developpeur-pascal.fr/p/_300f-cctrb--covid-contact-tracing-restau-bar.html

-----

Si vous ne connaissez pas Delphi et le langage Pascal, profitez de la version Academic (pour les étudiants, enseignants et établissements d'enseignement) ou Community Edition (gratuite pour une utilisation personnelle) disponibles chez Embarcadero (rubrique "outils gratuits").
En entreprise vous pouvez aussi tester Delphi avec la version d'évaluation.
https://www.embarcadero.com/products/delphi

Cette formation en ligne gratuite vous apprendra les bases de la programmation avec le Pascal et Delphi même si vous n'avez jamais appris à programmer :
https://apprendre-delphi.fr/apprendre-la-programmation-avec-delphi/

Des conférences en ligne et des webinaires (points techniques sur des sujets précis) sont organisés régulièrement. Consultez [le planning de ces webinaires](https://developpeur-pascal.fr/p/_6007-webinaires.html) et regardez les [rediffusions des webinaires Delphi](https://serialstreameur.fr/webinaires-delphi.php).

Des sessions de [live coding sur Twitch](https://www.twitch.tv/patrickpremartin) ou [la chaîne YouTube Developpeur Pascal](https://www.youtube.com/channel/UCk_LmkBB90jdEdmfF77W6qQ) sont également organisées régulièrement. Pour Twitch vous pouvez consulter [le planning hebdomadaire](https://www.twitch.tv/patrickpremartin/schedule). Vous pouvez aussi vous reporter à [cet article](https://developpeur-pascal.fr/p/_600e-livestreams-de-codage-en-direct-avec-delphi.html). Pour les rediffusions de tout ça, rendez-vous simplement dans la [rubrique live coding](https://serialstreameur.fr/live-coding.php) de [Serial Streameur](https://serialstreameur.fr/) où vous trouverez de nombreuses vidéos en français à destination des développeurs de logiciels, applications mobiles, sites web et jeux vidéo.

Enfin, si vous préférez la lecture à la vidéo, vous trouverez tous les livres récents publiés sur Delphi et le langage Pascal sur [Delphi Books](https://delphi-books.com)
