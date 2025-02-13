# Action permettant la planification de l'exécution d'actions
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Préparation nécessaire
```bash
mkdir /etc/OliveTin/plannings
```

## Configuration YAML (config.yaml)
```yaml
actions:
  - title: Scheduling Server Startup
    shell: |
      timez="$(date +"%:z")"
      echo "- {{ when }}${timez}" >> /etc/OliveTin/plannings/start-debiansrv-calendar.yaml
    icon: clock
    arguments:
      - name: when
        title: Choisir une date
        type: datetime
        description: Choisir la date et l'heure de démarrage de l'action (Start debian server)

  - title: Start debian server
    shell: wakeonlan -i 192.168.1.255 bc:24:11:dc:2f:12
    icon: ping
    execOnCalendarFile: /etc/OliveTin/plannings/start-debiansrv-calendar.yaml
```
