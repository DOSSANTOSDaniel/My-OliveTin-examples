# Action permettant d'afficher la charge mémoire et CPU
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
actions:
  - title: Check processes
    shell: |
      dtime="$(date "+%Y-%m-%d %H:%M:%S")"
      nb_lines='5'
      printf "\033c"
      printf "\n ===== %s ===== \n" "$dtime"
      echo '===== MEM === :'
      ps aux --sort=-%mem | head -"$nb_lines"
      echo '===== CPU === :'
      ps aux --sort=-%cpu | head -"$nb_lines"
      printf "\n ------------------ \n"
    icon: robot
    popupOnStart: execution-dialog-stdout-only
~                                                           
```
