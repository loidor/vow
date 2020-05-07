#!/bin/bash

last_message=0

. /etc/vow.conf

while true; do

  vpn_status=$(wg)

  if [[ -z "$vpn_status" ]]; then
  # VPN is down
    if ! [ "$(cat /proc/net/route | grep $interface)" ];then
    #Wifi is down - restart
      if ! [[ $last_message == 1 ]];then
        echo "Both the wifi and the VPN is down. Doing nothing."
        last_message=1
      fi
      sleep 1;
      continue
    else
    #Wifi is up
      ssid=$(iwgetid $interface --raw)

      if [[ ${safe_list[*]} =~ $ssid ]]; then
      #Connected to safe wifi - restart
        if ! [[ $last_message == 2 ]]; then
          echo "The wifi is up, but it's safe so the VPN is down. Doing nothing."
          last_message=2
        fi
        sleep 1;
        continue
      else
      #Connected to unsafe wifi - connect
        if ! [[ $last_message == 3 ]]; then
          echo "The wifi is up and is unsafe. Starting the VPN."
          last_message=3
        fi
        wg-quick up $wg >> /dev/null 2>&1
        sleep 1;
        continue
      fi
    fi
  else
  #VPN is up
    if ! [ "$(cat /proc/net/route | grep $interface)" ];then
    #Wifi is down
      if ! [[ $last_message == 4 ]]; then
        echo "The unsafe wifi has been disconnected. Killing the VPN."
        last_message=4
      fi
      wg-quick down $wg >> /dev/null 2>&1
      sleep 1;
      continue
    fi
  fi
done
