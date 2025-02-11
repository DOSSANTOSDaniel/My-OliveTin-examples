# Action permettant d'afficher une notification sur l'interface graphique d'une machine distante
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN

## Configuration YAML (config.yaml)
```yaml
actions:
  - title: Ping Fedora server
    shell: ping -c 2 192.168.1.1
    icon: ping
    shellAfterCompleted: "ssh -Tnq daniel@192.168.1.48 \"notify-send 'OliveTin notify' --icon=computer --expire-time=1000 'Commande ping: {{ exitCode }}, {{ output }}'\""
```
