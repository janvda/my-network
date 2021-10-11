# Setup of Firewall Reject Schedule

This page explains the setup of a firewall reject schedule for the wifi router upstairs.

## IP groups

IP addresses are grouped in 3 groups:

| name | ip/mask | ip range | description |
|--:|---|:---:|--|
| `priviliged` | not in below groups | `192.168.2.1-192.168.2.111` | priviliged devices (Jan Marleen) |
| `sterre` | `192.168.2.112/28`  | `192.168.2.113-192.168.2.126` | devices Sterre |
| `mirko_and_co` | `192.168.2.128/25` | `192.168.2.129-192.168.2.254` | all other devices |

## Archer 7 (main router)

Assure that DHCP server gives IP addresses in range `mirko_and_co` be doing below steps:

1. goto Network > Interfaces > Edit
2. Specify `Start = 129` and `Limit = 125`
3. Save the changes.

## Archer 6 (router 1st floor)

Install following packages:

* `ipset` : is needed to use masks ( `/28`)
* `luci-app-commands`: is needed for shell commands through URL (custom commands)
* `kmod-br-netfilter`: is needed to assure that the bridge firewall rules work  (see section *Enable bridge firewall*)

### Enable bridge firewall

Follow instructions outlined at:

* https://openwrt.org/docs/guide-user/firewall/fw3_configurations/bridge

In other words perform following instructions:

```
# Install packages
opkg update
opkg install kmod-br-netfilter
 
# Configure kernel parameters
cat << EOF >> /etc/sysctl.conf
net.bridge.bridge-nf-call-arptables=1
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
EOF
/etc/init.d/sysctl restart

# Log and status
/etc/init.d/firewall restart
```

## Iphones - disable `Private Address` for `lan_jan` and `lan_jan_5g`

Iphones when connecting to wifi network are each time using a different MAC address.  This makes that DHCP can not use the MAC address to assign a specific IP address.

To overcome this issue you must disable this feature for the `lan_jan` wifi network and als for `lan_jan_5g` wifi.
This can be disabled on iphone through following steps:

1. Goto Settings > Wi-Fi
2. click on (i) - information of `lan_jan`
3. disable the check box `Private Address`
4. ... and do the same steps for `lan_jan_5g` wifi network
