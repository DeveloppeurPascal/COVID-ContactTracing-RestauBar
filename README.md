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

### Logiciel Etablissement

* changer la génération du QR Code pour y ajouter une part d'aléatoire et de clé privée
* vérifier format Date/Heure des écrans cas contact (AAAAMMJJHHMMSS ou JJ/MM/AAAA HH:MM:SS)

-----

## Dépendances du projet

Par habitude je stocke les dépôts de code utilisés dans une arborescence à part dont le premier niveau est le propriétaire du source et le second le nom du projet.

Par exemple, celui-ci se trouve dans /DeveloppeurPascal/COVID-ContactTracing-RestauBar

La version Delphi de CCRTB dépend des dépôts de code suivants :

https://github.com/DeveloppeurPascal/librairies stocké dans ../librairies par rapport au dossier de ce dépôt.
=> des procédures et fonctions utilisées dans le projet (notamment pour le stockage des configurations et le calcul de checksum)

https://github.com/foxitsoftware/DelphiZXingQRCode stockée dans ../../foxitsoftware/DelphiZXingQRCode par rapport au dossier de ce dépôt.
=> pour la création des QR Code dans le programme destiné aux établissements

https://github.com/Spelt/ZXing.Delphi stockée dans ../../Spelt/ZXing par rapport au dossier de ce dépôt.
=> pour le scan des images de la caméra et l'interprétation des QR codes

Plus d'informations sur https://developpeur-pascal.fr/p/_300f-cctrb--covid-contact-tracing-restau-bar.html

-----

Si vous ne connaissez pas Delphi et le langage Pascal, profitez de la version Academic (pour les étudiants, enseignants et établissements d'enseignement) ou Community Edition (gratuite pour une utilisation personnelle) disponibles chez Embarcadero (rubrique "outils gratuits").
En entreprise vous pouvez aussi tester Delphi avec la version d'évaluation.
https://www.embarcadero.com/products/delphi

Cette formation en ligne gratuite vous apprendra les bases de la programmation avec le Pascal et Delphi même si vous n'avez jamais appris à programmer :
https://apprendre-delphi.fr/apprendre-la-programmation-avec-delphi/

Retrouvez les rediffusions de mes conférences en ligne et webinaires depuis la page https://developpeur-pascal.fr/p/_6007-webinaires.html

Des sessions de codage Delphi en direct sont organisées tous les jeudi à 14 heures (heure de Paris, France). Rejoignez moi sur https://www.twitch.tv/patrickpremartin et retrouvez le programme ou des informations complémentaires sur https://developpeur-pascal.fr/p/_600e-livestreams-de-codage-en-direct-avec-delphi.html

Enfin, si vous préférez la lecture à la vidéo, vous trouverez tous les livres récents publiés sur Delphi et le langage Pascal sur https://delphi-books.com/
