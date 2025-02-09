# Action permettant la planification de l'exécution d'actions
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN
  
## Préparation nécessaire et dépendances
### Récupération de la base de données des fabricants
```bash
mkdir -p /etc/OliveTin/scripts/MAC/
cd /etc/OliveTin/scripts/MAC/
wget https://www.wireshark.org/download/automated/data/manuf.gz
gunzip manuf.gz
```

## Script shell (vim /etc/OliveTin/scripts/scan_pcs.bash)
```bash
#!/usr/bin/env bash

nmap_output=$(nmap -sn 192.168.1.0/24 | awk '/Nmap scan report/{ip=$NF}/MAC Address/{print ip, $0}')
json_file='/etc/OliveTin/entities/scanips.json'

# Initialisation du fichier JSON
:> $json_file

while read -r device_info; do
  # Extraire les éléments : IP, MAC et fabricant
  ip_address="$(echo "$device_info" | grep -oE '([0-9]{1,3}(\.[0-9]{1,3}){3})')"
  mac_address="$(echo "$device_info" | grep -oE '([0-9A-Fa-f]{2}([-:][0-9A-Fa-f]{2}){5})')"
  name_vendor="$(echo "$device_info" | grep -oP 'MAC Address: [0-9A-Fa-f:]{17} \(\K[^)]+')"

# Construire l'objet JSON
  new_object=$(jq -c -n \
    --arg ip_address "$ip_address" \
    --arg mac_address "$mac_address" \
    --arg name_vendor "$name_vendor" \
    '{
      ip_address: $ip_address,
      mac_address: $mac_address,
      name_vendor: $name_vendor,
     }')

  # Ajouter l'objet au fichier JSON
  echo "$new_object" >> $json_file
done <<< "$nmap_output"
```

## Configuration YAML (config.yaml)
```yaml
actions:
  # Récupérer le nom du fabricant
  - title: "Infos fabricant {{ devices.ip_address }}"
    icon: 🛠️
    shell: |
      manuf_device="$(echo {{ devices.mac_address }} | grep -Eo '^(([A-Z0-9]){2}:){2}([A-Z0-9]){2}')"
      grep "$manuf_device" /etc/OliveTin/scripts/MAC/manuf || echo {{ devices.name_vendor }}
    entity: devices
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

  # Afficher les ports TCP ouverts
  - title: Ports TCP ouverts {{ devices.ip_address }}
    icon: 📬
    shell: nmap -sV {{ devices.ip_address }}
    entity: devices
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

  # Action cachée qui exécute le script "scan_pcs.bash" au même moment que le service OliveTin ainsi que toutes les 5 minutes
  - title: Update devices entity json file
    shell: /etc/OliveTin/scripts/scan_pcs.bash
    hidden: true
    execOnStartup: true
    execOnCron: '*/5 * * * *'

# Fichier de l'entitie
# Contient les données récupérées par l'action "Update devices entity json file"
entities:
  - file: /etc/OliveTin/entities/scanips.json
    name: devices

dashboards:
  - title: Mes_ordinateurs
    contents:
      - title: PC {{ devices.ip_address }}
        entity: devices
        type: fieldset
        contents:
          - type: display
            title: |
              <p><strong>{{ devices.name_vendor }}</strong></p>
          - title: Infos fabricant {{ devices.ip_address }}
          - title: Ports TCP ouverts {{ devices.ip_address }}
```

## Exemple du fichier Entities (/etc/OliveTin/entities/scanips.json)
```json
{"ip_address":"192.168.1.1","mac_address":"CC:2D:***","name_vendor":"SFR"}
{"ip_address":"192.168.1.21","mac_address":"E8:40:***","name_vendor":"Pegatron"}
{"ip_address":"192.168.1.22","mac_address":"90:FB:***","name_vendor":"Hon Hai Precision Ind."}
{"ip_address":"192.168.1.35","mac_address":"2C:FD:***","name_vendor":"ASUSTek Computer"}
{"ip_address":"192.168.1.48","mac_address":"BC:24:***","name_vendor":"Unknown"}
{"ip_address":"192.168.1.59","mac_address":"38:1A:***","name_vendor":"Seiko Epson"}
{"ip_address":"192.168.1.85","mac_address":"00:30:***","name_vendor":"Jetway Information"}
{"ip_address":"192.168.1.112","mac_address":"00:30:***","name_vendor":"Jetway Information"}
```
```yaml
```

## Code CSS
```css
```

## Autre informations
