# Envoyer une notification sur une machine distante via SSH
```bash
#!/usr/bin/env bash

ssh_client="$(jq -r .client01 /etc/OliveTin/entities/variables.json)"
exit_code="$1"
cmd_output="$2"

ssh -Tnq "$ssh_client" "notify-send 'OliveTin notify' --icon=computer --expire-time=1000 'End command: $exit_code, $cmd_output'"
```
