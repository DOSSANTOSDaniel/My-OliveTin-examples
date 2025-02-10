# Exemple d'action avec un script python
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
actions:
  - title: "Command exists ?"
    shell: |
      python3 -c '
      import shutil

      cmd = "{{ command }}"
      if shutil.which(cmd):
        print(f"Commande {cmd} trouvée ✅")
      else:
        print(f"Commande {cmd} introuvable ❌")
      '
    popupOnStart: execution-dialog-stdout-only
    arguments:
      - name: command
        description: Saisir une commande
        title: Commande
        default: ping
        type: 'regex:^[a-zA-Z0-9\s-]+$'
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
