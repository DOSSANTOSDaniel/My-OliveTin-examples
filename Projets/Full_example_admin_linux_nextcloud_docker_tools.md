# Interface de Gestion Serveur & Réseau
## Configuration, qui permet d'administrer un serveur Ubuntu, gérer des conteneurs Docker, surveiller Nextcloud, et exécuter divers outils réseau et système.
## Contexte d'expérimentation
* OS : Ubuntu server 24.04
* Navigateur : Firefox 135
* OliveTin : 

## Configuration YAML (config.yaml)
```yaml
pageTitle: OliveTin
logLevel: "DEBUG"

# Les entités
##############
entities:
  - file: /etc/OliveTin/entities/projects.json
    name: projects

  - file: /etc/OliveTin/entities/variables.json
    name: variables

# Actions
##########
actions:
  # Serveur Ubuntu
  - title: OFF Ubuntu
    shell: 'systemctl {{ choice }}'
    icon: |
      <img
        src = custom-webui/icons/actions/servers/stop.png
        width = "48px"
      />
    timeout: 10
    arguments:
      - type: confirmation
        title: Confirmation ?!
      - name: choice
        title: Reboot/Poweroff
        default: poweroff
        choices:
          - value: reboot
          - value: poweroff
    maxConcurrent: 1

  - title: SSH
    entity: variables
    shell: '/etc/OliveTin/scripts/clients/ssh_server.bash {{ variables.client01 }} {{ variables.ssh_server }} {{ variables.name_server }}'
    icon: |
      <img
        src = custom-webui/icons/actions/servers/ssh.png
        width = "48px"
      />
    maxConcurrent: 1
    shellAfterCompleted: '/etc/OliveTin/scripts/clients/notify.bash {{ exitCode }} {{ output }}'

  # Espace disque Ubuntu
  - title: Disk Space Ubuntu
    icon: |
      <img
        src = custom-webui/icons/tools/disk.png
        width = "48px"
      />
    shell: df -hlPT | awk 'NR == 1 || $7 == "/"'
    popupOnStart: execution-dialog-stdout-only
    timeout: 20
    maxConcurrent: 1

  # Espace disque Nextcloud
  - title: Disk Space Nextcloud
    entity: variables
    icon: |
      <img
        src = custom-webui/icons/tools/nextcloud_disk.png
        width = "48px"
      />
    shell: '/etc/OliveTin/scripts/server/disk_nextcloud.bash {{ variables.server_user }}'
    popupOnStart: execution-dialog-stdout-only
    timeout: 20
    maxConcurrent: 1

  # Logs Ubuntu
  - title: Logs dmesg Ubuntu
    shell: dmesg | tail -f
    icon: |
      <img
        src = custom-webui/icons/tools/logs.svg
        width = "48px"
      />
    popupOnStart: execution-dialog-stdout-only
    timeout: 20
    maxConcurrent: 1

  # Update Ubuntu
  - title: Update System Ubuntu
    shell: /etc/OliveTin/scripts/server/update_server.bash
    icon: |
      <img
        src = custom-webui/icons/tools/update.svg
        width = "48px"
      />
    popupOnStart: execution-dialog-stdout-only
    timeout: 1000
    maxConcurrent: 1

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

  # Outils
  ############
  # Scan pc ip, nom et mac
  - title: Scan PCs
    entity: variables
    shell: '/etc/OliveTin/scripts/server/scan_pcs.bash {{ variables.net_address }}'
    icon: |
      <img
        src = custom-webui/icons/tools/scanpc.png
        width = "48px"
      />
    timeout: 30
    popupOnStart: execution-dialog-stdout-only

  # Connexions ssh
  - title: Connexion SSH
    entity: variables
    shell: '/etc/OliveTin/scripts/clients/connexionssh.bash {{ variables.client01 }} {{ UserName }} {{ UserDomain }}'
    icon: |
      <img
        src = custom-webui/icons/tools/ssh.svg
        width = "48px"
      />
    timeout: 20
    arguments:
      - name: UserName
        title: Nom d'utilisateur
        type: ascii
        default: yakuza
        description: Nom

      - name: UserDomain
        title: Adresse IP ou Domaine
        type: ascii_identifier
        default: 192.168.1.200
        description: IP
    shellAfterCompleted: '/etc/OliveTin/scripts/clients/notify.bash {{ exitCode }} {{ output }}'

  - title: Logs Error
    shell: '/etc/OliveTin/scripts/server/logs_alerts.bash {{ Type_date }} {{ Number }}'
    arguments:
      - name: Number
        type: int
        default: 2
        description: Nombre de jours, mois, heures...

      - name: Type_date
        title: Date
        default: days
        description: Unité de temps
        choices:
          - title: Minutes
            value: minutes
          - title: Jours
            value: days
          - title: Semaines
            value: weeks
          - title: Mois
            value: months
          - title: Années
            value: years
    icon: |
      <img
        src = custom-webui/icons/actions/servers/logserror.png
        width = "48px"
      />
    timeout: 10
    popupOnStart: execution-dialog-stdout-only
    maxConcurrent: 1

  - title: IP WAN
    entity: variables
    shell: /etc/OliveTin/scripts/net_service/get_ip_wan.bash
    icon: |
      <img
        src = custom-webui/icons/tools/ipwan.png
        width = "48px"
      />
    timeout: 30
    popupOnStart: execution-dialog-stdout-only

  - title: Active Connexions Ports
    entity: variables
    shell: ss -tuln
    icon: |
      <img
        src = custom-webui/icons/actions/servers/ports.svg
        width = "48px"
      />
    timeout: 30
    popupOnStart: execution-dialog-stdout-only

  - title: Test Ports
    entity: variables
    shell: 'nc -zv -w 3 {{ IPAdd }} {{ PortNum }}'
    icon: |
      <img
        src = custom-webui/icons/tools/checkports.png
        width = "48px"
      />
    arguments:
      - name: IPAdd
        title: Adresse IP
        type: ascii_identifier
        default: 192.168.1.29
        description: Adresse IP de la machine à tester

      - name: PortNum
        title: Port
        type: int
        default: 22
        description: Numéro de port à tester

  - title: wttr
    entity: variables
    shell: 'wget -qO- fr.wttr.in/{{ WCity }}?QF'
    icon: |
      <img
        src = custom-webui/icons/tools/weather.png
        width = "48px"
      />
    arguments:
      - name: WCity
        title: Ville
        type: ascii
        default: Massy
        description: Indiquer une ville du monde
    popupOnStart: execution-dialog-stdout-only
    timeout: 15

  - title: Size Files Nextcloud
    entity: variables
    shell: '/etc/OliveTin/scripts/server/large_files_nextcloud.bash {{ variables.server_user }} {{ NbFiles }}'
    icon: |
      <img
        src = custom-webui/icons/actions/servers/sizefiles.png
        width = "48px"
      />
    timeout: 30
    arguments:
      - name: NbFiles
        title: Fichiers
        type: int
        default: 5
        description: Indiquer le nombre des plus gros fichiers
    popupOnStart: execution-dialog-stdout-only

  - title: Scan All Nextcloud Files
    entity: variables
    shell: 'nextcloud.occ files:scan --all'
    icon: |
      <img
        src = custom-webui/icons/actions/servers/scanall.png
        width = "48px"
      />
    timeout: 30
    popupOnStart: execution-dialog-stdout-only

  - title: Info System
    entity: variables
    shell: hostnamectl
    icon: |
      <img
        src = custom-webui/icons/actions/servers/infosystem.png
        width = "48px"
      />
    timeout: 30
    popupOnStart: execution-dialog-stdout-only

  - title: Scan Open Ports
    entity: variables
    shell: '/etc/OliveTin/scripts/server/scan_open_ports.bash {{ ScanType }} {{ IPAdd }}'
    icon: |
      <img
        src = custom-webui/icons/tools/scanopenports.png
        width = "48px"
      />
    timeout: 1000
    arguments:
      - name: IPAdd
        title: Adresse IP
        type: ascii_identifier
        default: 192.168.1.200
        description: Indiquer l'adresse IP

      - name: ScanType
        description: Attention le scan UDP est très long!
        title: Type de Scan
        default: TCP
        choices:
          - value: TCP
            title: TCP
          - value: UDP
            title: UDP
    popupOnStart: execution-dialog-stdout-only

  - title: Command Help
    entity: variables
    shell: 'wget -qO- cheat.sh/{{ Command }}'
    icon: |
      <img
        src = custom-webui/icons/tools/commandhelp.png
        width = "48px"
      />
    timeout: 0
    arguments:
      - name: Command
        title: Commande
        type: ascii
        default: ls
        description: Indiquer une commande
    popupOnStart: execution-dialog-stdout-only

  - title: Open File System Via SSH
    entity: variables
    shell: |
      ssh -Tq {{ variables.client01 }} \
      'nautilus ssh://{{ UserName }}@{{ IPAdd }}:22/home/{{ UserName }} &'
    icon: |
      <img
        src = custom-webui/icons/tools/filesystem.png
        width = "48px"
      />
    timeout: 5
    arguments:
      - name: UserName
        title: Nom d'utilisateur
        type: ascii
        default: yakuza
        description: Indiquer le nom de l'utilisateur distant

      - name: IPAdd
        title: Adresse IP
        type: ascii_identifier
        default: 192.168.1.200
        description: Indiquer l'adresse IP de la machine distante

  # Récupérations d'informations dynamiques
  #########################################
  # Etat des projets docker compose
  - title: Update docker services
    shell: /etc/OliveTin/scripts/server/projects.bash
    hidden: true
    execOnStartup: true

  # Variables globales
  - title: Variables
    shell: /etc/OliveTin/scripts/variables.bash
    hidden: true
    execOnStartup: true

# Dashboards
############
dashboards:
  # Dashboard Services
  - title: Server
    contents:
      - title: Ubuntu Server
        type: fieldset
        entity: variables
        contents:
          - title: OFF Ubuntu
          - title: SSH
          - title: Disk Space Ubuntu
          - title: Logs dmesg Ubuntu
          - title: Update System Ubuntu
          - title: Logs Error
          - title: Info System
          - title: Active Connexions Ports

      - title: Nextcloud
        type: fieldset
        entity: variables
        contents:
          - title: Disk Space Nextcloud
          - title: Size Files Nextcloud
          - title: Scan All Nextcloud Files

  # Dashboard outils
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

  - title: Tools
    contents:
      - title: Outils
        type: fieldset
        entity: variables
        contents:
          - title: Scan PCs
          - title: Connexion SSH
          - title: IP WAN
          - title: Test Ports
          - title: wttr
          - title: Scan Open Ports
          - title: Command Help
          - title: Open File System Via SSH
```
