#!/usr/bin/env bash

net_address="$1"

nmap -sP "$net_address" | awk '/Nmap scan report/{ip=$NF}/MAC Address/{print ip, $0}'
