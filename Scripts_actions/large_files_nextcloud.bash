#!/usr/bin/env bash

server_user="$1"
nb_files="$2"
nextcloud_data="/var/snap/nextcloud/common/nextcloud/data/$server_user/files"

du -ah "$nextcloud_data" | sort -rh | head -n "$nb_files"
