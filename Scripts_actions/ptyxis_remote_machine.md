# Lancer le terminal ptyxis sur une machine distante
```bash
#!/usr/bin/env bash

Client01="$1"
UserName="$2"
UserDomain="$3"

ssh -Tq "$Client01" "ptyxis --new-window --title=${UserDomain}_ --standalone -- ssh -o 'ServerAliveInterval 60' ${UserName}@${UserDomain} 2>/dev/null &"
```
