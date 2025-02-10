# Action permettant d'afficher le cache DNS de la machine hôte
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
  - title: Show DNS Cache
    shell: "systemctl kill --signal='USR1' systemd-resolved && sleep 5 && journalctl -b -u systemd-resolved --grep=' IN ' --no-pager --no-hostname"
    icon: |
      <img
        src="https://icons.iconarchive.com/icons/kyo-tux/delikate/256/Internet-icon.png"
        width = "64px"
      />
    timeout: 30
    popupOnStart: execution-dialog-stdout-only
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
