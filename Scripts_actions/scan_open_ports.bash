#!/usr/bin/env bash

scan_type="$1"
ip_address="$2"

if [ "$scan_type" = 'TCP' ]; then
  masscan "$ip_address" -p1-65535 --rate=1000
else
  nmap -sU -p- "$ip_address"
fi
