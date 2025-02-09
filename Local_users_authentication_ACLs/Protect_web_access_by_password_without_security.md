# Action permettant la planification de l'exécution d'actions
## Contexte d'expérimentation
* OS : Ubuntu server 24.04.1 LTS
* Navigateur : Firefox 135.0 (64 bits)
* OliveTin : 2024.12.11
* Réseau : LAN
  
## Préparation nécessaire et dépendances
### fichier Javascript
Éditer le fichier index.html d’OliveTin :
```bash
vim /var/www/olivetin/index.html
```
Insérer cette ligne :”<script src = "custom-webui/password.js"></script>” avant la balise de fin “</body>”.
Création du fichier /etc/OliveTin/custom-webui/password.js
```bash
vim /etc/OliveTin/custom-webui/password.js
```

```javascript
const myPassword = 'daniel123'

const domMain = document.getElementsByTagName('main')[0]
domMain.style.display = 'none'

const domPassword = document.createElement('input')
const domLogin = document.createElement('button')

function checkPassword () {
  if (domPassword.value === myPassword) {
    domMain.style.display = 'block'
    domPassword.remove()
    domLogin.remove()
  } else {
    window.alert('Incorrect password. Please try again.')
  }
}

function setupPasswordForm () {
  domPassword.setAttribute('type', 'password')
  domPassword.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      checkPassword()
    }
  })

  domLogin.innerText = 'Login'
  domLogin.onclick = checkPassword

  const domHeader = document.querySelector('header')
  domHeader.appendChild(domPassword)
  domHeader.appendChild(domLogin)
}

document.addEventListener('DOMContentLoaded', setupPasswordForm)
```
Restart
```bash
systemctl restart OliveTin
```

## Script shell
```bash
```

## Configuration YAML (config.yaml)
```yaml
ShowNewVersions: false
CheckForUpdates: false

actions:
  - title: Ping Fedora server
    shell: ping -c 2 192.168.1.47
    icon: ping
    timeout: 5
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
