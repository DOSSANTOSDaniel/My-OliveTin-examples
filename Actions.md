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
