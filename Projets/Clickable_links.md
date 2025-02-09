# Actions permettant la mise en place de liens cliquables
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
AdditionalNavigationLinks:
  - title: 'Mon_Blog'
	url: 'https://blogdanieldsj.wordpress.com/'

actions:
  - title: Link Blog
    icon: ping
    shell: |
      URL='https://blogdanieldsj.wordpress.com/'
      MSG='Double click ici pour voir mon blog'
      printf "\033c"
      printf "\e]8;;${URL}\e\\${MSG}\e]8;;\e\\"
    popupOnStart: execution-dialog-stdout-only

dashboards:
  - title: Mes_Liens
    contents:
      - title: Liens cliquables
        type: fieldset
        contents:
          - type: display
            title: |
              <span class = "icon">
                <a href="https://blogdanieldsj.wordpress.com/">
                  <img src="https://icons.iconarchive.com/icons/dryicons/aesthetica-2/48/blog-post-edit-icon.png" width="48" height="48">
                </a>
              </span>

              <a href="https://blogdanieldsj.wordpress.com/">
                <strong>Mon Blog</strong>
              </a>

          - title: Link Blog
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
