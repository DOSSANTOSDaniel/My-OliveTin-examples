# Utilisateurs et groupes par défaut qui ont besoin d'une configuration des ACLs

- Sur OliveTin, nous avons certains utilisateurs par défaut et on doit aussi leur appliquer les ACLs.
- Voici un tableau des utilisateurs par défaut sur OliveTion et leur fonction :
  
|Utilisateur|Rôle|
|---|---|
|cron|Responsable de l’exécution des actions par cron.Utilisation de l’option : “execOnCron:”|
|startup|Responsable de l’exécution des actions au démarrage du service OliveTin.Utilisation de l’option : “execOnStartup: true”|
|calendar|Responsable de l’exécution des actions utilisant la propriété “execOnCalendarFile”.|
|fileindir|Responsable de l’exécution des actions utilisant les propriétés “execOnFileChangedInDir” et “execOnFileCreatedInDir”.|
|guest|Utilisateur permettant les connexions anonymes.|
