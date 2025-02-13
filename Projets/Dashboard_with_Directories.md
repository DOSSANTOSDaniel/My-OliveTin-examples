# Utilisation des dashboards avec des dossiers
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
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
      - title: Outils de tests
        contents:
        - title: La commande existe ?
        - title: Ping Test
```
