#!/usr/bin/env bash

estab_port='22'
oui_db='/etc/OliveTin/scripts/MAC/manuf'
json_file='/etc/OliveTin/entities/ssh_sessions.json'

all_processes="$(lsof -n -i :"$estab_port" | awk '/ESTABLISHED/')"
remote_ip="$(echo "$all_processes" | awk '{match($9, /->([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/, ip); if (ip[1]) print ip[1]}' | sort -u)"

# Initialisation du fichier JSON
:> "$json_file"

while IFS= read -r machine; do
  session_pid="$(echo "$all_processes" | awk -v ip="$machine" '$0 ~ ip {print $2}' | tr '\n' ' ')"
  nb_process="$(read -r -a words <<< "$session_pid"; echo "${#words[@]}")"
  remote_mac="$(ping -c 1 "$machine" > /dev/null && ip neigh show "$machine" | awk '/lladdr/ {print $5}')"
  pre_manuf="$(echo "$remote_mac" | grep -iEo '^(([A-Z0-9]){2}:){2}([A-Z0-9]){2}')"
  
  remote_name="$(nslookup "$machine" | awk '/name =/ {print $NF}')"
  if [[ -z "$remote_name" ]]; then
    remote_name="$(avahi-resolve-address "$machine" | awk '{print $2}')"
  fi
  
  remote_manuf="$(awk -v mac="$remote_mac" 'BEGIN {IGNORECASE=1} $0 ~ mac { $1=""; sub(/^ /, ""); print $0 }' "$oui_db")"
  if [[ -z "$remote_manuf6" ]]; then
    remote_manuf="$(awk -v mac="$pre_manuf" 'BEGIN {IGNORECASE=1} $0 ~ mac { $1=""; sub(/^ /, ""); print $0 }' "$oui_db")"
  fi

  # Construire l'objet JSON
  new_object=$(jq -c -n \
    --arg ip "$machine" \
    --arg pid "$session_pid" \
    --arg nbps "$nb_process" \
    --arg mac "$remote_mac" \
    --arg name "$remote_name" \
    --arg manuf "$remote_manuf" \
    '{
      ip: $ip,
      pid: $pid,
      nbps: $nbps,
      mac: $mac,
      name: $name,
      manuf: $manuf,
     }')

  # Ajouter l'objet au fichier JSON
  echo "$new_object" >> $json_file
done <<< "$remote_ip"
