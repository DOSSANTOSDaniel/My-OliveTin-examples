#!/usr/bin/env bash

interface="$(ip route | grep default | awk '{print $5}')"
ip_server="$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
net_address="$(ip route show dev $interface | grep -oP '^\S+/\d+')"

name_server='UBUNTU'

server_user="$(awk -F: '$3 == 1000 {print $1; exit}' /etc/passwd)"
nextcloud_dir="/var/snap/nextcloud/common/nextcloud/data/${server_user}/files/"

client01='daniel@192.168.1.47'
ssh_server="${server_user}@${ip_server}"

json_file_vars="/etc/OliveTin/entities/variables.json"

# Construire l'objet JSON
new_object=$(jq -c -n \
  --arg ip_server "$ip_server" \
  --arg net_address "$net_address" \
  --arg name_server "$name_server" \
  --arg server_user "$server_user" \
  --arg nextcloud_dir "$nextcloud_dir" \
  --arg client01 "$client01" \
  --arg ssh_server "$ssh_server" \
  '{
    ip_server: $ip_server, 
    net_address: $net_address, 
    name_server: $name_server, 
    server_user: $server_user, 
    nextcloud_dir: $nextcloud_dir, 
    client01: $client01, 
    ssh_server: $ssh_server
   }')

# Ajouter l'objet au fichier JSON
echo "$new_object" > $json_file_vars
