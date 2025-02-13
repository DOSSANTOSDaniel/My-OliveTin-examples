# Gestion d'une stack de projets docker compose
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

![Capture](/Screenshots/docker_compose.png)
## Script shell (Récupére l'état des projets docker compose)
```bash
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
```

## Configuration YAML (config.yaml)
```yaml
pageTitle: OliveTin
logLevel: "DEBUG"

# Les entités
##############
entities:
  - file: /etc/OliveTin/entities/projects.json
    name: projects

# Actions
##########
actions:
  # Services Docker
  ###################
  - title: 'ON {{ services.project }}'
    entity: projects
    shell: 'docker compose -f {{ services.composecfg }} up -d'
    icon: |
      <img
        src = custom-webui/icons/actions/containers/start.svg
        width = "48px"
      />
    trigger: Update docker services
    maxConcurrent: 5
    timeout: 30

  - title: 'OFF {{ services.project }}'
    entity: projects
    shell: 'docker compose -f {{ services.composecfg }} down'
    icon: |
      <img
        src = custom-webui/icons/actions/containers/stop.svg
        width = "48px"
      />
    timeout: 30
    arguments:
      - type: confirmation
        title: Confirmation ?
    trigger: Update docker services
    maxConcurrent: 5

  - title: 'RESTART {{ services.project }}'
    entity: projects
    shell: 'docker compose -f {{ services.composecfg }} restart'
    icon: |
      <img
        src = custom-webui/icons/actions/containers/restart.png
        width = "48px"
      />
    timeout: 30
    arguments:
      - type: confirmation
        title: Confirmation ?
    trigger: Update docker services
    maxConcurrent: 5

  - title: 'UPDATE {{ services.project }}'
    entity: projects
    shell: |
      docker compose -f {{ services.composecfg }} down
      docker compose -f {{ services.composecfg }} pull
      docker compose -f {{ services.composecfg }} up -d
    icon: |
      <img
        src = custom-webui/icons/actions/containers/update.svg
        width = "48px"
      />
    timeout: 30
    arguments:
      - type: confirmation
        title: Confirmation ?
    popupOnStart: execution-dialog-stdout-only
    trigger: Update docker services
    maxConcurrent: 5

  - title: 'LOGS {{ services.project }}'
    entity: projects
    shell: 'docker compose -f {{ services.composecfg }} logs | tail -n 50'
    icon: |
      <img
        src = custom-webui/icons/actions/containers/logs.svg
        width = "48px"
      />
    timeout: 30
    popupOnStart: execution-dialog
    maxConcurrent: 1

  # Récupérations d'informations dynamiques
  #########################################
  # Etat des projets docker compose
  - title: Update docker services
    shell: /etc/OliveTin/scripts/server/projects.bash
    hidden: true
    execOnStartup: true

# Dashboards
############
dashboards:
  - title: Docker Projects
    contents:
      - title: 'Project {{ projects.project }}'
        type: fieldset
        entity: projects
        contents:
          - type: display
            title: |
              <strong>State</strong>
              <strong>{{ projects.status }}</strong>
          - title: 'ON {{ projects.project }}'
          - title: 'OFF {{ projects.project }}'
          - title: 'RESTART {{ projects.project }}'
          - title: 'UPDATE {{ projects.project }}'
          - title: 'LOGS {{ projects.project }}'
```

