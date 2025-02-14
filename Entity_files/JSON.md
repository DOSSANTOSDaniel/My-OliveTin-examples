# Les fichiers d'entités au format JSON
## Dépendances
* jq
* nmap
## Script de récupération de données et création du fichier JSON
```bash
vim /etc/OliveTin/scripts/scan_pcs_services_json.bash
```
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
Exemple de résultat :
```bash
cat /etc/OliveTin/entities/scanips.json
```
```json
{"ip_address":"192.168.1.1","mac_address":"CC:2D:****","name_vendor":"SFR"}
{"ip_address":"192.168.1.21","mac_address":"E8:40:****","name_vendor":"Pegatron"}
{"ip_address":"192.168.1.22","mac_address":"90:FB:****","name_vendor":"Hon Hai Precision Ind."}
{"ip_address":"192.168.1.35","mac_address":"2C:FD:****","name_vendor":"ASUSTek Computer"}
{"ip_address":"192.168.1.47","mac_address":"16:80:****","name_vendor":"Unknown"}
{"ip_address":"192.168.1.48","mac_address":"BC:24:****","name_vendor":"Unknown"}
{"ip_address":"192.168.1.59","mac_address":"38:1A:****","name_vendor":"Seiko Epson"}
{"ip_address":"192.168.1.85","mac_address":"00:30:****","name_vendor":"Jetway Information"}
{"ip_address":"192.168.1.112","mac_address":"00:30:****","name_vendor":"Jetway Information"}
```
