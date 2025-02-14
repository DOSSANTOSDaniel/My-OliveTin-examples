# Action permettant la planification de l'exécution d'actions
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
actions:
  - title: Get disk usage
    id: status_command
    icon: disk
    shell: 'df -h --output=source,size,used,avail,pcent,target | awk "NR==1 || /^\/dev\//"'
    execOnStartup: true
    execOnCron:
      - "*/1 * * * *"

dashboards:
  - title: Control Panel
    contents:
      - title: Status
        type: fieldset
        contents:
          - title: Get disk usage
          - type: stdout-most-recent-execution
            title: status_command
```
