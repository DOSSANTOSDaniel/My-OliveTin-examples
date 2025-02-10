# Action permettant la planification de l'exécution d'actions
## Contexte d'expérimentation
* OS : Ubuntu server 24.04
* Navigateur : Firefox 135
* OliveTin : 

## Préparation nécessaire
```bash

```

## Script shell
```bash
```

## Configuration YAML (config.yaml)
```yaml
actions:
  - title: Ping {{ workstations.ip }}
    icon: ping
    shell: ping -c 1 {{ workstations.ip }}
    entity: workstations

    # Récupérer le nom du frabricant
  - title: Infos fabricant {{ workstations.ip }}
    icon: 🛠️
    shell: |
      manuf_device="$(echo {{ workstations.mac }} | tr '[:lower:]' '[:upper:]' | grep -Eo '^(([A-Z0-9]){2}:){2}([A-Z0-9]){2}')"
      grep "$manuf_device" /etc/OliveTin/scripts/MAC/manuf || echo "Unknown"
    entity: workstations
    popupOnStart: execution-dialog-stdout-only

    # Afficher les ports TCP ouverts
  - title: Ports TCP ouverts {{ workstations.ip }}
    icon: 📬
    shell: nmap -sV {{ workstations.ip }}
    entity: workstations
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

entities:
  - file: /etc/OliveTin/entities/workstations.yaml
    name: workstations

dashboards:
  - title: Ordinateurs
    contents:
      - title: '{{ workstations.name }} - {{ workstations.ip }}'
        entity: workstations
        type: fieldset
        contents:
          - type: display
            title: |
              <p><strong>{{ workstations.hostname }}</strong></p>
              <p>Utilisateur: {{ workstations.user }}</p>
          - title: Ping {{ workstations.ip }}
          - title: Infos fabricant {{ workstations.ip }}
          - title: Ports TCP ouverts {{ workstations.ip }}
          - type: display
            title: |
              <p>OS: {{ workstations.os }}</p>
              <p>Localisation: {{ workstations.location }}</p>
```

## Exemple du fichier Entities
```bash
vim /etc/OliveTin/entities/workstations.yaml
```
```yaml
- name: 'poste01'
  user: 'daniel'
  hostname: 'poste01.exemple.fr'
  ip: '192.168.1.101'
  mac: 'bc:24:11:6b:9d:89'
  os: 'Linux'
  location: 'Bât. 1, 3ᵉ étg'

- name: 'poste02'
  user: 'anne'
  hostname: 'poste02.exemple.fr'
  ip: '192.168.1.102'
  mac: 'bc:24:11:6b:ad:90'
  os: 'Windows'
  location: 'Bât. 1, 2ᵉ étg'
```

## Code CSS
```css
```

## Autre informations
