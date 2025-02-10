#!/usr/bin/env bash

echo -e "\n Début de la mise à jour ! \n"

echo "Update APT"
sudo apt-get update
sudo apt-get full-upgrade --allow-downgrades -y || sudo apt-get -f -y install

echo "Update SNAP"
sudo snap refresh --list
sudo snap refresh
sudo snap changes

echo -e "\n Clean APT \n"
sudo apt-get autoremove --purge -y
sudo apt-get autoclean
sudo apt-get clean
dpkg -l | grep -q ^rc && sudo dpkg -P "$(dpkg -l | awk '/^rc/{print $2}')" || echo 'Aucun résidu trouvé.'

echo -e "\n Clean SNAP \n"
sudo snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read -r snapname revision; do
  sudo snap remove "$snapname" --revision="$revision"
done
sudo snap changes

