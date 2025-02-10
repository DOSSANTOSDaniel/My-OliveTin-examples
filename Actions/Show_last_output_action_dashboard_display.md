# Action permettant d'afficher la sortie la plus récente d'une action sur un tableau de bord avec un icone mais sans bouton
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
actions:
  - title: Get network printers
    id: status_command
    icon: ping
    shell: |
      info_printers="$(nmap -p 631,9100,515 --open -sV -T4 -n --min-parallelism 64 --max-retries 1 -PR 192.168.1.0/24)"
      IFS=$'\n' # Définit le séparateur de ligne à une nouvelle ligne
      ip_add="$(echo "$info_printers" | awk '/Nmap scan report for/ {print $NF}')"
      echo "===== IP imprimantes réseau ====="
      echo "$ip_add"

    execOnStartup: true
    timeout: 35
    hidden: true

dashboards:
  - title: Control Panel
    contents:
      - title: Network Printers
        type: fieldset
        contents:
          - type: display
            title: |
              <span class = "icon">
                <img src="https://icons.iconarchive.com/icons/aha-soft/universal-shop/256/Print-icon.png"
                  alt="Process Icon"
                  style="margin-top: 12px;"
                  width="48px"
                />
              </span>

          - type: stdout-most-recent-execution
            title: status_command
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
