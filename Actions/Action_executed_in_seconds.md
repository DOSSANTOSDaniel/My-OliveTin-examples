# Action permettant d'exécuter une commande toutes les n secondes
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN
  
## Préparation nécessaire et dépendances
```bash
```

## Script shell
```bash
```

## Configuration YAML (config.yaml)
```yaml
cronSupportForSeconds: true

actions:
  # Teste de la communication tous les 6 secondes
  - title: Ping server
    shell: ping -c 1 192.168.1.48
    icon: ping
    timeout: 5
    execOnCron:
      - "*/6 * * * * *"
```

## Exemple du fichier Entities
```json
```
```yaml
```

## Code CSS
```css
```

## Autre informations
