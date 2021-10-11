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

index=0
rule_workdays_idx="undefined"
while true; do
        name=$(uci get firewall.@rule[$index].name 2>/dev/null) || break
        echo "$name"| (grep -q "$rule_workdays") && {
             #### Do you stuff here with $index ###
             rule_workdays_idx=$index
             break
        }
        index=$((index+1))
done

index=0
rule_weekend_idx="undefined"
while true; do
        name=$(uci get firewall.@rule[$index].name 2>/dev/null) || break
        echo "$name"| (grep -q "$rule_weekend") && {
             #### Do you stuff here with $index ###
             rule_weekend_idx=$index
             break
        }
        index=$((index+1))
done

#echo "index 1: $rule_workdays_idx"                                     
#echo "index 2: $rule_weekend_idx"                                      
                                                                        
if [ "$rule_workdays_idx" = "undefined" ]; then                         
    echo "ERROR: couldn't find firewall rule with name:$rule_workdays"  
else                                                                    
    echo "$2 firewall rule[$rule_workdays_idx]:$rule_workdays"          
    uci set firewall.@rule[$rule_workdays_idx].enabled=$enabled         
fi                                                                      
                                                                        
if [ "$rule_weekend_idx" = "undefined" ]; then                          
    echo "ERROR: couldn't find firewall rule with name:$rule_weekend"   
else                                                                  
   echo "$2 firewall rule[$rule_weekend_idx]:$rule_weekend"           
   uci set firewall.@rule[$rule_weekend_idx].enabled=$enabled         
fi                                                                    
                                                                      
uci commit                                                            
/etc/init.d/firewall restart                                          
