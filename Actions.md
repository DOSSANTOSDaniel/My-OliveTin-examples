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
    shell: lsblk -f /dev/{{ Device }}
    icon: disk
    popupOnStart: execution-dialog-stdout-only
    arguments:
      - name: Device
        type: 'regex:^(?:[sh]d[a-z]|nvme\d+n\d+)$'
        description: Indique le nom du périphérique de stockage.
        title: Périphérique de stockage
        default: sda
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
