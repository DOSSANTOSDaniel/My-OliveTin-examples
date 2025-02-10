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
