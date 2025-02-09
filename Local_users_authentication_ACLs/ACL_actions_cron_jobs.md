# Actions permettant les ACLs et utilisation d’actions avec des tâches cron
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN
  
## Préparation nécessaire et dépendances
```bash
```

## Script shell
```bash
```

## Configuration YAML (config.yaml)
```yaml
logLevel: DEBUG

ShowNewVersions: false
CheckForUpdates: false

authLocalUsers:
  enabled: true
  users:
    - username: admin
      password: $argon2id$v=19$m=65536,t=4,p=2$LiaOg01nGYEnu94WfY1PEQ$klAyJeF/nzIiFHnlxPWtqM5Rev/gBVcC5zm1QapYt88

AuthRequireGuestsToLogin: true

accessControlLists:
  - name: Administration
    addToEveryAction: true
    matchUserNames:
      - admin
    permissions:
      view: true
      exec: true
      logs: true

  - name: Cronuser
    matchUserNames:
      - cron
    permissions:
      view: false
      exec: true
      logs: false

actions:
  - title: Ping Fedora server
    shell: ping -c 2 192.168.1.47
    icon: ping
    timeout: 5

  - title: Backup OliveTin
    shell: |
      backup_file="/tmp/backup_OliveTin_$(date +'%Y-%m-%d').tar.gz"
      tar -czvf "$backup_file" /etc/OliveTin
      scp "$backup_file" daniel@192.168.1.47:/home/daniel/Backup
    icon: backup
    execOnCron:
      - "@hourly"
    acls:
        - "cron"
```

## Exemple du fichier Entities
```json
```
```yaml
```

## Code CSS
```css
```

## Autre informations
