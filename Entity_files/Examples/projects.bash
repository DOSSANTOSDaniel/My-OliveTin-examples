#!/usr/bin/env bash

username="$(awk -F: '$3 == 1000 {print $1; exit}' /etc/passwd)"
services_dir="/home/${username}/ServicesDocker/"
json_file_services='/etc/OliveTin/entities/projects.json'

if [[ -d "$services_dir" ]]; then
  # Initialise le fichier JSON
  :> "$json_file_services"

  # Parcours des fichiers de configuration compose
  find "$services_dir" -type f -iname "*compose*" \( -iname "*.yml" -or -iname "*.yaml" \) | while IFS= read -r compose_file; do
    project_name="$(docker compose -f "$compose_file" ps --format json | jq -r .[0].Project)"
    project_status="$(docker compose -f "$compose_file" ps --format json | jq -r .[0].State)"
  
    # Si les données ne sont pas trouvées, c'est que le projet est down, définir des valeurs down
    if [ -z $project_name ] || [ $project_name = 'null' ]; then
      project_name="$(dirname "$compose_file" | grep -oP "^${services_dir}\K.*")"
      project_status="stopped"
    fi
  
    # Construire un objet JSON pour chaque projet docker
    new_object=$(jq -c -n \
      --arg project "$project_name" \
      --arg status "$project_status" \
      --arg composecfg "$compose_file" \
      '{project: $project, status: $status, composecfg: $composecfg}')
  
    # Ajouter l'objet JSON au fichier
    echo "$new_object" >> "$json_file_services"
  done
fi
