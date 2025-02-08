# liste d'exemples d'actions simples
## Liste des périphériques de stockage et partitions
```yaml
actions:
  - title: "Liste des périphériques"
    shell: printf "\033c"; lsblk
    icon: disk
    popupOnStart: execution-dialog-stdout-only
```

## Informations sur le périphérique de stockage
```yaml
actions:
  - title: Infos disk
    shell: printf "\033c"; lsblk -f /dev/{{ Device }}
    icon: disk
    popupOnStart: execution-dialog-stdout-only
    arguments:
      - name: Device
        type: 'regex:^(?:[sh]d[a-z]|nvme\d+n\d+)$'
        description: Indique le nom du périphérique de stockage.
        title: Périphérique de stockage
        default: sda
```

## Ping une machine avec sugestions
```yaml
actions:
  - title: Ping Test
    icon: ping
    shell: ping -c 1 {{ computer }}
    arguments:
      - name: computer
        title: IP Address
        description: Indique l'adresse IP.
        type: ascii_sentence
        suggestions:
          - 192.168.1.85: Serveur Tortue
          - 192.168.1.22: PC Windows
```

## Power
```yaml
actions:
  - title: Power OFF/Restart
    icon: ⚡
    shell: systemctl "{{ poweroption }}"
    arguments:
      - type: confirmation
        title: Confirmation ?

      - name: poweroption
        title: Power option
        choices:
          - title: OFF
            value: poweroff

          - title: Restart
            value: reboot
```

## Sauvegarde une fois par semaine
```yaml
actions:
# Sauvegarde à chaque heure
  - title: Backup home directory
    shell: ssh -Tnq daniel@192.168.1.48 "tar --exclude='/home/daniel/.cache' -czf - /home/daniel" > /root/backup-$(date +\%Y-\%m-\%d_\%H-\%M-\%S).tar.gz
    icon: backup
    timeout: 30
    execOnCron:
      - "@weekly"
```

## Envoyer une notification 
```yaml
actions:
  - title: Send notif
    shell: echo "Test"
    icon: ping
    shellAfterCompleted: "ssh -Tnq daniel@192.168.1.48 \"notify-send 'OliveTin notify' --icon=computer --expire-time=1000 'Retour commande: {{ exitCode }}, {{ output }}'\""
```
## Création d'un fichier d'informations sur la charge CPU et mémoire au démarrage d'OliveTin
```yaml
actions:
- title: Check processes
  shell: |
    LOG_FILE='/tmp/checkps.log'
    echo "===== MEM === $(date "+%Y-%m-%d %H:%M:%S") =====" >> "$LOG_FILE"
    ps aux --sort=-%mem | head -3 >> "$LOG_FILE"
    echo "===== CPU === $(date "+%Y-%m-%d %H:%M:%S") =====" >> "$LOG_FILE"
    ps aux --sort=-%cpu | head -3 >> "$LOG_FILE"
  icon: robot
  execOnStartup: true
```

## Récupère des informations sur les fichiers créés ou modifiés dans le dossier /home/daniel/Images/
```yaml
actions:
- title: Mames of modified files
  shell: 'echo "$(date +"%Y-%m-%d_%H-%M-%S"), file: {{ filename }}, Dir: {{ filedir }}, size: {{ filesizebytes }}" >> /tmp/imagedir.log'
  arguments:
    - name: filename
      type: 'regex:^[[:alnum:]_\-]([[:alnum:]_\-\s\.])+\.[[:alnum:]]+$'

    - name: filedir
      type: 'regex:^\/[[:alnum:]_\-\s\.]([[:alnum:]_\-\s\/\.])+$'

    - name: filesizebytes
      type: int
  hidden: true
  #execOnFileCreatedInDir
  execOnFileChangedInDir:
    - /home/daniel/Images/
```
## 
```yaml

```

##
```yaml

```

##
```yaml

```
## 
```yaml

```

##
```yaml

```

##
```yaml

```
## 
```yaml

```

##
```yaml

```
