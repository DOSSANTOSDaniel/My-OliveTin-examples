# customisation des boutons
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
themeName: super_bouton

actions:
  - title: La commande existe ?
    shell: command -v {{ command }}
    icon: 📦
    arguments:
    - name: command
      title: Saisir une commande
      type: ascii

  - title: Ping Test
    icon: ping
    shell: ping -c 1 {{ computer }}
    arguments:
    - name: computer
      title: IP Address
      description: Indique l'adresse IP.
      type: ascii_sentence
      suggestions:
      - 192.168.1.85: Serveur Tortue
      - 192.168.1.22: PC Windows

dashboards:
  - title: Mes_outils
    contents:
    - title: Serveur Ubuntu
      type: fieldset
      contents:
        - title: La commande existe ?
          cssClass: super-button
        - title: Ping Test
```

## Code CSS
```css
/* Cible autour du bouton */
.super-button {
  grid-column: span 2;
  grid-row: span 2;
  border: 2px solid red;
  background-color: pink; /* Couleur de fond */
  border-radius: 15px; /* Coins arrondis */
  padding: 10px 10px 10px 10px; /* Espacement interne */
}

/* Cible autour du bouton au survol */
.super-button:hover {
  background-color: black; /* Couleur au survol */
  transform: scale(1.05); /* Effet de zoom au survol */
}

/* Cible l'intérieur du bouton */
.super-button button {
  background-color: green;
}

/* Cible l'intérieur du bouton au survol */
.super-button button:hover {
  background-color: red;
  transform: translateY(-5px); /* Légère élévation au survol */
}

/* Cible le titre à l'intérieur du bouton */
.super-button span.title {
  font-size: 1rem;      /* Taille du texte */
  font-weight: bold;    /* Texte en gras */
  color: white;
}

/* Cible le titre à l'intérieur du bouton au survol */
.super-button button:hover span.title{
 color: black;
}

/* Cible l'icône à l'intérieur du bouton */
.super-button span.icon {
  font-size: 2.5rem; /* Agrandir l'icône */
}

/* Cible l'icône à l'intérieur du bouton au survol */
.super-button button:hover span.icon {
  font-size: 5.5rem; /* Agrandir l'icône */
}
```
