# Actions permettant l'administration des conteneurs Docker avec couleur de fonctionnement et image de fond
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

![Capture](/Screenshots/dockercolor.png)
  
## Préparation nécessaire et dépendances
```bash
mkdir /etc/OliveTin/custom-webui/themes/ColorButton
```

## Configuration YAML (config.yaml)
```yaml
ShowNewVersions: false
CheckForUpdates: false

themeName: ColorButton

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
            cssClass: '{{ container.State }}'
            title: |
              <p><strong>{{ container.State }}</strong></p>
              <p>{{ container.Ports }}</p>
          - title: Start / Stop {{ container.Names }}
          - title: Restart {{ container.Names }}
          - title: Execute command {{ container.Names }}
```

## Exemple du fichier Entities
/etc/OliveTin/entities/containers.json
```json
{"Command":"\"docker-entrypoint.s…\"","CreatedAt":"2025-01-16 22:41:45 +0100 CET","ID":"9d3f30782cfc","Image":"valkey/valkey:8-alpine","Labels":"com.docker.compose.project.config_files=/home/daniel/ServicesDocker/searxng/docker-compose.yaml,com.docker.compose.config-hash=dfea73859db6ed7bd1c57f15a408855e358cbace9eeec6ae15aad03a3f77629e,com.docker.compose.container-number=1,com.docker.compose.depends_on=,com.docker.compose.image=sha256:9c269705b0cdd5ce39c767f2f11b41912d57034e57c35ee4c7b58d02d54fdb6c,com.docker.compose.oneoff=False,com.docker.compose.project=searxng,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/searxng,com.docker.compose.service=redis,com.docker.compose.version=2.20.3","LocalVolumes":"1","Mounts":"searxng_valkey…","Names":"redis-searxng","Networks":"searxng_searxng","Ports":"6379/tcp","RunningFor":"3 weeks ago","Size":"0B","State":"running","Status":"Up 8 minutes"}
{"Command":"\"/sbin/tini -- /usr/…\"","CreatedAt":"2025-01-16 22:41:45 +0100 CET","ID":"62dfc39caa40","Image":"searxng/searxng:latest","Labels":"org.opencontainers.image.version=2025.1.16-272e39893,com.docker.compose.config-hash=cba882b117896745df7b02abe61e7ab24311481b24dcab1203a538a910a9d6aa,maintainer=searxng \u003chttps://github.com/searxng/searxng\u003e,org.label-schema.usage=https://github.com/searxng/searxng-docker,org.label-schema.vcs-ref=272e39893d41d6e47126957e6c82fb89e89fc80f,org.opencontainers.image.revision=272e39893d41d6e47126957e6c82fb89e89fc80f,com.docker.compose.version=2.20.3,org.opencontainers.image.title=searxng,org.label-schema.name=searxng,org.label-schema.schema-version=1.0,org.opencontainers.image.documentation=https://github.com/searxng/searxng-docker,com.docker.compose.oneoff=False,com.docker.compose.project=searxng,com.docker.compose.project.config_files=/home/daniel/ServicesDocker/searxng/docker-compose.yaml,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/searxng,org.opencontainers.image.source=https://github.com/searxng/searxng,com.docker.compose.service=searxng,description=A privacy-respecting, hackable metasearch engine.,org.label-schema.build-date=2025-01-16T19:31:13Z,org.opencontainers.image.created=2025-01-16T19:31:13Z,org.opencontainers.image.url=https://github.com/searxng/searxng,com.docker.compose.depends_on=,org.label-schema.vcs-url=https://github.com/searxng/searxng,org.label-schema.version=2025.1.16+272e39893,com.docker.compose.container-number=1,com.docker.compose.image=sha256:23df018dd0ce40efe502b178a3810d0a0d894779dd5de189485844c62db7decc,version=2025.1.16+272e39893,org.label-schema.url=https://github.com/searxng/searxng","LocalVolumes":"0","Mounts":"/home/daniel/S…","Names":"searxng","Networks":"searxng_searxng","Ports":"127.0.0.1:8181-\u003e8080/tcp","RunningFor":"3 weeks ago","Size":"0B","State":"running","Status":"Up 8 minutes"}
{"Command":"\"caddy run --config …\"","CreatedAt":"2025-01-16 22:41:45 +0100 CET","ID":"7c803303b7f6","Image":"caddy:2-alpine","Labels":"com.docker.compose.image=sha256:1b7d0a82297a0ab4d6f0a855f790d0208a975163c02e307c171de9674d23a4a0,org.opencontainers.image.description=a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go,org.opencontainers.image.title=Caddy,org.opencontainers.image.vendor=Light Code Labs,com.docker.compose.depends_on=,com.docker.compose.oneoff=False,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/searxng,com.docker.compose.project.config_files=/home/daniel/ServicesDocker/searxng/docker-compose.yaml,com.docker.compose.service=caddy,com.docker.compose.version=2.20.3,org.opencontainers.image.licenses=Apache-2.0,org.opencontainers.image.version=v2.9.1,com.docker.compose.config-hash=22fa33af8c063f21296dec74ce7045ca421813e71d09374c9e3cf243844bc26e,com.docker.compose.container-number=1,com.docker.compose.project=searxng,org.opencontainers.image.documentation=https://caddyserver.com/docs,org.opencontainers.image.source=https://github.com/caddyserver/caddy-docker,org.opencontainers.image.url=https://caddyserver.com","LocalVolumes":"2","Mounts":"searxng_caddy-…,/home/daniel/S…,searxng_caddy-…","Names":"caddy-searxng","Networks":"host","Ports":"","RunningFor":"3 weeks ago","Size":"0B","State":"restarting","Status":"Restarting (1) 14 seconds ago"}
{"Command":"\"/docker-entrypoint.…\"","CreatedAt":"2025-01-15 23:32:52 +0100 CET","ID":"0df3028a4eae","Image":"corentinth/it-tools:latest","Labels":"com.docker.compose.depends_on=,com.docker.compose.oneoff=False,com.docker.compose.version=2.20.3,maintainer=NGINX Docker Maintainers \u003cdocker-maint@nginx.com\u003e,com.docker.compose.config-hash=6868528e5f08624054ded095547d8fb05e5a161108f75ad599b8b4eb412c1fb0,com.docker.compose.container-number=1,com.docker.compose.image=sha256:bb7ba9626731f5919cea26f919bbc204fb031533cdf8742cde45d08e16ce2e0f,com.docker.compose.project=it-tools,com.docker.compose.project.config_files=/home/daniel/ServicesDocker/it-tools/compose.yaml,com.docker.compose.project.working_dir=/home/daniel/ServicesDocker/it-tools,com.docker.compose.service=it-tools","LocalVolumes":"0","Mounts":"","Names":"it-tools","Networks":"it-tools_default","Ports":"0.0.0.0:8383-\u003e80/tcp, [::]:8383-\u003e80/tcp","RunningFor":"3 weeks ago","Size":"0B","State":"running","Status":"Up 4 hours"}
```

## Code CSS
vim /etc/OliveTin/custom-webui/themes/ColorButton/theme.css
```css
@media (prefers-color-scheme: dark) {
    body {
        background-image: url("custom-webui/themes/ColorButton/wallhaven-3ld95v.jpg");
        background-repeat: no-repeat;
        background-size: cover;
        background-color: #85929e;
    }
}

@media (prefers-color-scheme: light) {
    body {
        background-image: url("custom-webui/themes/ColorButton/wallhaven-7py2zo.png");
        background-repeat: no-repeat;
        background-size: cover;
        background-color: #e5e8e8;
    }
}

/* Style lorsque la classe "running" est appliquée */
div.display.running {
  background-color: #52be8090; /* Vert clair */
  border-color: #82e0aa; /* Vert foncé */
}

/* Style lorsque la classe "exited" est appliquée */
div.display.exited {
  background-color: #cd615590; /* Rouge clair */
  border-color: #f1948a; /* Rouge foncé */
}

/* Style display par défaut */
div.display {
  background-color: #abb2b990; /* Gris clair */
  border-color: #566573; /* Gris foncé */
}
```
