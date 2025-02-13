# Action permettant la gestion de conteneurs docker
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN
  
![Capture](/dockerstartstop.png)

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
        description: Entrer une commande dans le conteneur
        default: 'df -h'
        type: 'regex:^[a-zA-Z0-9\s-]+$'

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

## Exemple du fichier Entities (/etc/OliveTin/entities/containers.json)
```json
{"Command":"\"docker-entrypoint.s…\"","CreatedAt":"2025-01-16 22:41:45 +0100 CET","ID":"9d3f30782cfc","Image":"valkey/valkey:8-alpine","Labels":"com.docker.compose.container-number=1,com.docker.compose.depends_on=,com.docker.compose.image=sha256:9c269705b0cdd5ce39c767f2f11b41912d57034e57c35ee4c7b58d02d54fdb6c,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/searxng,com.docker.compose.service=redis,com.docker.compose.version=2.20.3,com.docker.compose.config-hash=dfea73859db6ed7bd1c57f15a408855e358cbace9eeec6ae15aad03a3f77629e,com.docker.compose.project=searxng,com.docker.compose.project.config_files=/home/daniel/ServicesDocker/searxng/docker-compose.yaml,com.docker.compose.oneoff=False","LocalVolumes":"1","Mounts":"searxng_valkey…","Names":"redis-searxng","Networks":"searxng_searxng","Ports":"","RunningFor":"3 weeks ago","Size":"0B","State":"exited","Status":"Exited (0) 12 days ago"}
{"Command":"\"/sbin/tini -- /usr/…\"","CreatedAt":"2025-01-16 22:41:45 +0100 CET","ID":"62dfc39caa40","Image":"searxng/searxng:latest","Labels":"org.label-schema.schema-version=1.0,org.opencontainers.image.revision=272e39893d41d6e47126957e6c82fb89e89fc80f,com.docker.compose.container-number=1,com.docker.compose.service=searxng,org.label-schema.build-date=2025-01-16T19:31:13Z,org.label-schema.vcs-url=https://github.com/searxng/searxng,org.opencontainers.image.source=https://github.com/searxng/searxng,org.opencontainers.image.version=2025.1.16-272e39893,com.docker.compose.project.config_files=/home/daniel/ServicesDocker/searxng/docker-compose.yaml,org.opencontainers.image.created=2025-01-16T19:31:13Z,com.docker.compose.config-hash=cba882b117896745df7b02abe61e7ab24311481b24dcab1203a538a910a9d6aa,description=A privacy-respecting, hackable metasearch engine.,org.label-schema.usage=https://github.com/searxng/searxng-docker,org.opencontainers.image.title=searxng,org.opencontainers.image.url=https://github.com/searxng/searxng,version=2025.1.16+272e39893,com.docker.compose.oneoff=False,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/searxng,org.label-schema.url=https://github.com/searxng/searxng,org.opencontainers.image.documentation=https://github.com/searxng/searxng-docker,maintainer=searxng \u003chttps://github.com/searxng/searxng\u003e,com.docker.compose.image=sha256:23df018dd0ce40efe502b178a3810d0a0d894779dd5de189485844c62db7decc,org.label-schema.version=2025.1.16+272e39893,com.docker.compose.depends_on=,com.docker.compose.project=searxng,com.docker.compose.version=2.20.3,org.label-schema.name=searxng,org.label-schema.vcs-ref=272e39893d41d6e47126957e6c82fb89e89fc80f","LocalVolumes":"0","Mounts":"/home/daniel/S…","Names":"searxng","Networks":"searxng_searxng","Ports":"127.0.0.1:8181-\u003e8080/tcp","RunningFor":"3 weeks ago","Size":"0B","State":"running","Status":"Up 3 hours"}
{"Command":"\"caddy run --config …\"","CreatedAt":"2025-01-16 22:41:45 +0100 CET","ID":"7c803303b7f6","Image":"caddy:2-alpine","Labels":"org.opencontainers.image.source=https://github.com/caddyserver/caddy-docker,org.opencontainers.image.description=a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go,org.opencontainers.image.documentation=https://caddyserver.com/docs,com.docker.compose.project=searxng,com.docker.compose.project.config_files=/home/daniel/ServicesDocker/searxng/docker-compose.yaml,com.docker.compose.service=caddy,org.opencontainers.image.licenses=Apache-2.0,org.opencontainers.image.title=Caddy,org.opencontainers.image.vendor=Light Code Labs,com.docker.compose.config-hash=22fa33af8c063f21296dec74ce7045ca421813e71d09374c9e3cf243844bc26e,com.docker.compose.image=sha256:1b7d0a82297a0ab4d6f0a855f790d0208a975163c02e307c171de9674d23a4a0,org.opencontainers.image.version=v2.9.1,com.docker.compose.version=2.20.3,com.docker.compose.oneoff=False,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/searxng,org.opencontainers.image.url=https://caddyserver.com,com.docker.compose.container-number=1,com.docker.compose.depends_on=","LocalVolumes":"2","Mounts":"searxng_caddy-…,searxng_caddy-…,/home/daniel/S…","Names":"caddy-searxng","Networks":"host","Ports":"","RunningFor":"3 weeks ago","Size":"0B","State":"restarting","Status":"Restarting (1) 30 seconds ago"}
{"Command":"\"/docker-entrypoint.…\"","CreatedAt":"2025-01-15 23:32:52 +0100 CET","ID":"0df3028a4eae","Image":"corentinth/it-tools:latest","Labels":"maintainer=NGINX Docker Maintainers \u003cdocker-maint@nginx.com\u003e,com.docker.compose.container-number=1,com.docker.compose.oneoff=False,com.docker.compose.project=it-tools,com.docker.compose.project.config_files=/home/daniel/ServicesDocker/it-tools/compose.yaml,com.docker.compose.version=2.20.3,com.docker.compose.config-hash=6868528e5f08624054ded095547d8fb05e5a161108f75ad599b8b4eb412c1fb0,com.docker.compose.depends_on=,com.docker.compose.image=sha256:bb7ba9626731f5919cea26f919bbc204fb031533cdf8742cde45d08e16ce2e0f,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/it-tools,com.docker.compose.service=it-tools","LocalVolumes":"0","Mounts":"","Names":"it-tools","Networks":"it-tools_default","Ports":"0.0.0.0:8383-\u003e80/tcp, [::]:8383-\u003e80/tcp","RunningFor":"3 weeks ago","Size":"0B","State":"running","Status":"Up 3 hours"}
```
