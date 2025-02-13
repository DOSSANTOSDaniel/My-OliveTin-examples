# Actions permettant la gestion et supervision des sessions SSH
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN
  
## Préparation nécessaire et dépendances
```bash
/etc/OliveTin/scripts/kill_ssh_session.bash
/etc/OliveTin/entities/ssh_sessions.json
```

## Script shell
```bash
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
```

## Configuration YAML (config.yaml)
```yaml
actions:
    # Kill les sessions SSH
  - title: SSH Kill {{ sshsessions.ip }}
    icon: ☠️
    shell: kill -15 {{ sshsessions.pid }}
    entity: sshsessions
    trigger: Update SSH Sessions entity file

    # Informations sur les sessions SSH
  - title: SSH Infos {{ sshsessions.ip }}
    icon: 📖
    shell: |
      echo "Session SSH Infos"
      echo '------------------------------'
      echo "IP: {{ sshsessions.ip }}"
      echo "NAME: {{ sshsessions.name }}"
      echo "MANUF: {{ sshsessions.manuf }}"
      echo "MAC: {{ sshsessions.mac }}"
      echo "PID: {{ sshsessions.pid }}"
      echo '------------------------------'
    entity: sshsessions
    popupOnStart: execution-dialog-stdout-only

    # Récupération des données pour la création du fichier d'entity.
    # Action cachée démarrant au lancement du service OliveTin ainsi que tous les minutes.
    # S'exécute aussi quand l'action "- title: SSH Kill {{ sshsessions.ip }}" est lancée,
    # car cette action possede un trigger vers l'action (Update container entity file).
  - title: Update SSH Sessions entity file
    shell: /etc/OliveTin/scripts/kill_ssh_session.bash
    hidden: true
    execOnStartup: true
    execOnCron: '*/1 * * * *'

entities:
  - file: /etc/OliveTin/entities/ssh_sessions.json
    name: sshsessions

dashboards:
  - title: Mes_Sessions_SSH
    contents:
      - title: Session SSH {{ sshsessions.ip }} {{ sshsessions.name }}
        entity: sshsessions
        type: fieldset
        contents:
          - type: display
            title: |
              <span class = "icon">
                <img
                  src="https://icons.iconarchive.com/icons/justicon/free-simple-line/128/Process-Gear-File-Document-Development-icon.png"
                  width="48px"
                />
              </span>
              <p><strong>Processes: {{ sshsessions.nbps }}</strong></p>
          - title: SSH Infos {{ sshsessions.ip }}
          - title: SSH Kill {{ sshsessions.ip }}
```

## Exemple du fichier Entities
```json
{"ip":"192.168.1.22","pid":"1821 1963 2020 2049 2102 2149 2184 2240 ","nbps":"8","mac":"90:fb:****","name":"DESKTOP-LNDO03H.","manuf":"HonHaiPrecis Hon Hai Precision Ind. Co.,Ltd."}
```
