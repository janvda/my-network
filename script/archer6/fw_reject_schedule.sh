#!/bin/sh
# author Jan Van den Audenaerde
# date 2021-10-10
#
# usage: fw_reject_schedule [sterre|mirko] [enable|disable]
if [ "$1" = "sterre" ]; then
  rule_workdays="iprange_sterre_reject_during_workdays"
  rule_weekend="iprange_sterre_reject_during_weekend"
elif [ "$1" = "mirko" ]; then
  rule_workdays="iprange_mirko_and_co_reject_during_workdays"
  rule_weekend="iprange_mirko_and_co_reject_during_weekend"
elif [ "$1" = "jan" ]; then
  rule_workdays="iphone_jan_reject_test_schedule"
  rule_weekend="iphone_jan_reject_test_schedule"
else
  echo "ERROR: parameter 1 must be mirko or sterre"
  exit 1
fi

if [ "$2" = "enable" ]; then
  enabled=1
elif [ "$2" = "disable" ]; then
  enabled=0
else
  echo "ERROR: parameter 2 must be enable or disable"
  exit 2
fi
