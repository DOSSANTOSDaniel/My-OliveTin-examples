# Action permettant de vérifier quand un fichier est modifié ou créé
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
actions:
  - title: Modified files
    shell: 'echo "$(date +"%Y-%m-%d_%H-%M-%S"), file: {{ filename }}, Dir: {{ filedir }}, size: {{ filesizebytes }}" >> /tmp/imagedir.log'
    arguments:
      - name: filename
        type: 'regex:^[[:alnum:]_\-]([[:alnum:]_\-\s\.])+\.[[:alnum:]]+$'

      - name: filedir
        type: 'regex:^\/[[:alnum:]_\-\s\.]([[:alnum:]_\-\s\/\.])+$'

      - name: filesizebytes
        type: int
    hidden: true
    execOnFileChangedInDir:
      - /home/daniel/Images/
```
