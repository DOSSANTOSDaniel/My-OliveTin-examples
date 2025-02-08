# Action permettant la planification de l'exécution d'actions
## Préparation nécessaire
```bash
mkdir /etc/OliveTin/plannings
```
## Configuration config.yaml
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
