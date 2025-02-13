# Action permettant la gestion de conteneurs Docker
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
actions:
    # Démarrer ou arrêter le conteneur
  - title: Start / Stop {{ container.Names }}
    icon: 🟢🔴
    shell: |
      if [ {{ container.State }} = 'running' ] || [ {{ container.State }} = 'restarting' ]; then
        docker stop {{ container.ID }}
        sleep 2
      else
        docker start {{ container.ID }}
      fi
    entity: container
    trigger: Update container entity file
    timeout: 5

    # Exécuter une commande dans le conteneur
  - title: Execute command {{ container.Names }}
    icon: 🕹️
    shell: docker exec {{ container.ID }} {{ command }}
    entity: container
    popupOnStart: execution-dialog-stdout-only
    arguments:
      - name: command
        description: Entrer une commande à exécuter dans le conteneur
        default: 'df -h'
        type: 'regex:^[a-zA-Z0-9\s-]+$'
        # Expression régulière permettant de saisir des commandes avec des lettres, nombres, espaces et symboles - ou --

    # Redémarrer le conteneur
  - title: Restart {{ container.Names }}
    icon: 🔄
    shell: docker restart {{ container.ID }}
    entity: container
    trigger: Update container entity file
    timeout: 5

    # Récupération des données pour la création du fichier d'entity.
    # Action cachée démarrant au lancement du service OliveTin ainsi que tous les 5 minutes.
    # S'exécute aussi quand l'action "Start / Stop {{ container.Names }}" est lancée (trigger: Update container entity file).
  - title: Update container entity file
    shell: 'docker ps -a --format json > /etc/OliveTin/entities/containers.json'
    hidden: true
    execOnStartup: true
    execOnCron: '*/5 * * * *'

entities:
  - file: /etc/OliveTin/entities/containers.json
    name: container

dashboards:
  - title: My Containers
    contents:
      - title: 'Container {{ container.Names }} ({{ container.Image }})'
        entity: container
        type: fieldset
        contents:
          - type: display
            title: |
              <p><strong>{{ container.State }}</strong></p>
              <p>{{ container.Ports }}</p>
          - title: Start / Stop {{ container.Names }}
          - title: Restart {{ container.Names }}
          - title: Execute command {{ container.Names }}
```
