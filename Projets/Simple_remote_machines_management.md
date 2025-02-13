# Gestion des machines distantes
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Script shell
```bash
#!/usr/bin/env bash

nmap_output=$(nmap -sn 192.168.1.0/24 | awk '/Nmap scan report/{ip=$NF}/MAC Address/{print ip, $0}')
json_file='/etc/OliveTin/entities/scanips.json'

# Initialisation du fichier JSON
:> $json_file

# Parse la sortie et convertit en JSON
while read -r device_info; do
  # Extraire les éléments : IP, MAC et fabricant
  ip_address="$(echo "$device_info" | grep -oE '([0-9]{1,3}(\.[0-9]{1,3}){3})')"
  mac_address="$(echo "$device_info" | grep -oE '([0-9A-Fa-f]{2}([-:][0-9A-Fa-f]{2}){5})')"
  name_vendor="$(echo "$device_info" | grep -oP 'MAC Address: [0-9A-Fa-f:]{17} \(\K[^)]+')"
  # Obtenir les ports ouverts
  open_ports_infos="$(nmap -p- -T4 --min-rate 10000 --max-retries 1 "$ip_address" | grep -E '^([0-9]*){5}/(tcp|udp)\s*open')"
  open_ports="$(echo "$open_ports_infos" | awk -F'/' '{print $1}')"

  # Initialisation des variables
  count_web_services=0

  port_web0=''
  port_web1=''
  port_web2=''
  port_web3=''
  port_web4=''
  port_web5=''

  # Savoir si le port ouvert est un service web accessible
  while read -r device_port; do
    if [[ -z "$open_ports" ]]; then
      open_ports_infos="$(nmap -p- -T4 --min-rate 10000 --max-retries 3 "$ip_address" | grep -E '^([0-9]*){5}/(tcp|udp)\s*open')"
      open_ports="$(echo "$open_ports_infos" | awk -F'/' '{print $1}')"
    fi
    if [[ -n "$open_ports" ]]; then
      for http_type in http https ; do
        web_req="$(curl -k -s -o /dev/null -w "%{http_code}\n" --tcp-fastopen --connect-timeout 2 --max-time 2 "$http_type"://"$ip_address":"$device_port")"
        if [[ "$web_req" =~ ^(200|301|302|403|404)$ ]]; then
          if [[ "$device_port" -eq 80 ]] && [[ "$http_type" = 'http' ]]; then
            declare port_web${count_web_services}="http://${ip_address}"
            ((count_web_services++))
          elif [[ "$device_port" -eq 443 ]] && [[ "$http_type" = 'https' ]]; then
            declare port_web${count_web_services}="https://${ip_address}"
            ((count_web_services++))
          else
            if [[ "$device_port" -ne 80 ]] && [[ "$device_port" -ne 443 ]]; then
              declare port_web${count_web_services}="${http_type}://${ip_address}:${device_port}"
              ((count_web_services++))
            fi
          fi
        fi
      done
    fi
  done <<< "$open_ports"

# Construire l'objet JSON
  new_object=$(jq -c -n \
    --arg ip_address "$ip_address" \
    --arg mac_address "$mac_address" \
    --arg name_vendor "$name_vendor" \
    --arg port_web0 "$port_web0" \
    --arg port_web1 "$port_web1" \
    --arg port_web2 "$port_web2" \
    --arg port_web3 "$port_web3" \
    --arg port_web4 "$port_web4" \
    --arg port_web5 "$port_web5" \
    '{
      ip_address: $ip_address,
      mac_address: $mac_address,
      name_vendor: $name_vendor,
      port_web0: $port_web0,
      port_web1: $port_web1,
      port_web2: $port_web2,
      port_web3: $port_web3,
      port_web4: $port_web4,
      port_web5: $port_web5,
     }')

  # Ajouter l'objet au fichier JSON
  echo "$new_object" >> $json_file
done <<< "$nmap_output"
```

## Configuration YAML (config.yaml)
```yaml
actions:
  - title: Infos OS {{ devices.ip_address }}
    icon: 🖥️
    shell: nmap -O --osscan-guess {{ devices.ip_address }}
    entity: devices
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

  - title: Infos fabricant {{ devices.ip_address }}
    icon: 🛠️
    shell: |
      manuf_device="$(echo {{ devices.mac_address }} | grep -Eo '^(([A-Z0-9]){2}:){2}([A-Z0-9]){2}')"
      grep "$manuf_device" /etc/OliveTin/scripts/MAC/manuf || echo {{ devices.name_vendor }}
    entity: devices
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

  - title: Nslookup {{ devices.ip_address }}
    icon: 📟
    shell: nslookup -timeout=2 {{ devices.ip_address }} || echo 'Unknown'
    entity: devices
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

  - title: Open ports {{ devices.ip_address }}
    icon: 📬
    shell: nmap -sV {{ devices.ip_address }}
    entity: devices
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

  - title: Traceroute {{ devices.ip_address }}
    icon: 👟
    shell: mtr --report --report-cycles 3 {{ devices.ip_address }}
    entity: devices
    popupOnStart: execution-dialog-stdout-only
    timeout: 15
      # démarrer au démarrage sur serveur

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
              <p>
                <strong>{{ devices.name_vendor }}</strong>
              </p>
                <a href='{{ devices.port_web0 }}' target='_blank'>{{ devices.port_web0 }}</a>
                <a href='{{ devices.port_web1 }}' target='_blank'>{{ devices.port_web1 }}</a>
                <a href='{{ devices.port_web2 }}' target='_blank'>{{ devices.port_web2 }}</a>
                <a href='{{ devices.port_web3 }}' target='_blank'>{{ devices.port_web3 }}</a>
                <a href='{{ devices.port_web4 }}' target='_blank'>{{ devices.port_web4 }}</a>
                <a href='{{ devices.port_web5 }}' target='_blank'>{{ devices.port_web5 }}</a>

          - title: Infos OS {{ devices.ip_address }}
          - title: Infos fabricant {{ devices.ip_address }}
          - title: Nslookup {{ devices.ip_address }}
          - title: Open ports {{ devices.ip_address }}
          - title: Traceroute {{ devices.ip_address }}
```
