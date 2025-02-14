# Actions permettant des utilisateurs et groupes privilégiés et non privilégiés et interdisant un accès anonyme
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
logLevel: DEBUG

ShowNewVersions: false
CheckForUpdates: false

authLocalUsers:
  enabled: true
  users:
    - username: admin
      usergroup: admins
      password: $argon2id$v=19$m=65536,t=4,p=2$LiaOg01nGYEnu94WfY1PEQ$klAyJeF/nzIiFHnlxPWtqM5Rev/gBVcC5zm1QapYt88

    - username: daniel
      usergroup: users
      password: $argon2id$v=19$m=65536,t=4,p=2$X8YLHsSnfgXGranxrBSQWQ$ZHEKjZ8GSZtUjJBNZZgTqpPoIG5Y1d91NC+SK1MPg2I

AuthRequireGuestsToLogin: true

accessControlLists:
  - name: Administration
    addToEveryAction: true
    matchUserNames:
      - admin
    matchUserGroups:
      - admins
    permissions:
      view: true
      exec: true
      logs: true

  - name: RegularUser
    matchUserNames:
      - daniel
    matchUserGroups:
      - users
    permissions:
      view: true
      exec: true
      logs: false

actions:
  - title: Ping Fedora server
    shell: ping -c 2 192.168.1.47
    icon: ping
    timeout: 5
    acls:
      - RegularUser

  - title: Shutdown Ubuntu server
    shell: echo "poweroff"
    icon: ashtonished

  - title: Show date
    shell: date
    icon: poop
    popupOnStart: execution-dialog-stdout-only
    acls:
      - RegularUser
```
