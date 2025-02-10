#!/usr/bin/env bash

date_time="$(date +%F_%H-%M-%S)"
date_option="$1" #minutes, hours, days, weeks, months, years
number_of="$2"

echo -e "\n *---- $date_time ----*"
echo -e "------------------------------------------------------------ \n"
echo -e "\n *---- LOGS_LEVELS_Emergency ----* \n"
journalctl --no-pager --since "$number_of $date_option ago" -p 0
echo -e "\n *---- LOGS_LEVELS_Alert ----* \n"
journalctl  --no-pager --since "$number_of $date_option ago" -p 1
echo -e "\n *---- LOGS_LEVELS_Critical ----* \n"
journalctl  --no-pager --since "$number_of $date_option ago" -p 2
echo -e "\n *---- LOGS_LEVELS_Error ----* \n"
journalctl  --no-pager --since "$number_of $date_option ago" -p 3
echo -e "\n *---- LOGS_LEVELS_Warning ----* \n"
journalctl  --no-pager --since "$number_of $date_option ago" -p 4
