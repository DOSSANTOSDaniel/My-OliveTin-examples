# Les fichiers d'entités au format YAML
## Dépendances
* yq
* nmap

## Récupération d'informations statiques
```bash
vim exemple.yaml
```
```yaml
- name: 'poste01'
  user: 'daniel'
  hostname: 'poste01.exemple.fr'
  ip: '192.168.1.101'
  mac: 'bc:24:11:6b:9d:89'
  os: 'Linux'
  location: 'Bât. 1, 3ᵉ étg'

- name: 'poste02'
  user: 'anne'
  hostname: 'poste02.exemple.fr'
  ip: '192.168.1.102'
  mac: 'bc:24:11:6b:ad:90'
  os: 'Windows'
  location: 'Bât. 1, 2ᵉ étg'
```
## Récupération d'informations dynamiques
### Script permettant de récupérer les données et créer le fichier yaml
```bash
vim /etc/OliveTin/scripts/exemple.bash
```
```bash
#!/usr/bin/env bash

# Variables
nmap_output=$(nmap -sn 192.168.1.0/24 | awk '/Nmap scan report/{ip=$NF}/MAC Address/{print ip, $0}')
yaml_file='/etc/OliveTin/entities/scanpcs.yaml'

# Initialisation du fichier YAML
:> "$yaml_file"

# Récupération des données IP, MAC et nom du fabricant
echo "$nmap_output" | while IFS= read -r device; do
  ip_address="$(echo "$device" | grep -oE '([0-9]{1,3}(\.[0-9]{1,3}){3})')"
  mac_address="$(echo "$device" | grep -oE '([0-9A-Fa-f]{2}([-:][0-9A-Fa-f]{2}){5})')"
  name_vendor="$(echo "$device" | grep -oP 'MAC Address: [0-9A-Fa-f:]{17} \(\K[^)]+')"

  # Parse la sortie et ajoute les données au fichier YAML
  yq e '. += [{
    "ip_address": "'"$ip_address"'",
    "mac_address": "'"$mac_address"'",
    "name_vendor": "'"$name_vendor"'"}]' -i "$yaml_file"
done
```
### Exemple de résultat
```bash
cat /etc/OliveTin/entities/scanpcs.yaml
```
```yaml
- ip_address: 192.168.1.1
  mac_address: CC:2D:****
  name_vendor: SFR
- ip_address: 192.168.1.21
  mac_address: E8:40:****
  name_vendor: Pegatron
- ip_address: 192.168.1.22
  mac_address: 90:FB:****
  name_vendor: Hon Hai Precision Ind.
- ip_address: 192.168.1.30
  mac_address: D0:9C:****
  name_vendor: Xiaomi Communications
```
