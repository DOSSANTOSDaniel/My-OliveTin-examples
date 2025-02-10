#!/usr/bin/env bash

server_user="$1"
nextcloud_data="/var/snap/nextcloud/common/nextcloud/data/$server_user/files"

du -L -h --max-depth=1 "$nextcloud_data" | awk -F'/' '{print$1,$NF}' | head -n -1
