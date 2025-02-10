# Action permettant de récupérer le nom du frabricant d'une machine
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN
  
## Préparation nécessaire et dépendances
```bash
mkdir /etc/OliveTin/scripts/MAC
cd /etc/OliveTin/scripts/MAC

wget https://www.wireshark.org/download/automated/data/manuf.gz
ou
curl -O https://www.wireshark.org/download/automated/data/manuf.gz

gzip -d manuf.gz
ou
gunzip manuf.gz
```

## Script shell
```bash
```

## Configuration YAML (config.yaml)
```yaml
actions:
    # Récupérer le nom du frabricant
  - title: Infos fabricant
    icon: 🛠️
    shell: |
      mac_add="$(ip link show | awk '/ether/ {print $2; exit}' | tr '[:lower:]' '[:upper:]')"
      manuf_device="$(echo "$mac_add" | grep -Eo '^(([A-Z0-9]){2}:){2}([A-Z0-9]){2}')"
      printf "\033c"
      grep "$manuf_device" /etc/OliveTin/scripts/MAC/manuf || echo "Name not found $mac_add"
    popupOnStart: execution-dialog-stdout-only
    timeout: 15                
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
