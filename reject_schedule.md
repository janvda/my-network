# Setup of Firewall Reject Schedule

This page explains the setup of a firewall reject schedule for the wifi router upstairs.
So devices having an IP addresses in the group `sterre` or `mirko_and_co` (see below) will only have access to the router during restricted periods during the week.  Outside these periods access will be rejected.

It is possible to disable the reject schedule so that it is possible to access the router outside the period defined by the schedule.

## IP groups

IP addresses are grouped in 3 groups:

| name | ip/mask | ip range | description |
|--:|---|:---:|--|
| `priviliged` | not in below groups | `192.168.2.1-192.168.2.111` | priviliged devices (Jan Marleen) |
| `sterre` | `192.168.2.112/28`  | `192.168.2.113-192.168.2.126` | devices Sterre |
| `mirko_and_co` | `192.168.2.128/25` | `192.168.2.129-192.168.2.254` | all other devices |

## 1. [Archer 7 (main router)](http://archer7)

Assure that DHCP server gives IP addresses in range `mirko_and_co` by executing below steps.
This is important to assure that new devices (or devices with changing MAC address) don't get an IP address in the `priviliged` range.

1. goto Network > Interfaces > Edit
2. Specify `Start = 129` and `Limit = 125`
3. Save the changes.

## 2. [Archer 6 (router 1st floor)](http://archer7)

### 2.1 Install additional packages

Install following packages:

* `ipset` : is needed to use masks in the firewall rules ( `/28`)
* `luci-app-commands`: is needed for shell commands through URL (custom commands)
* `kmod-br-netfilter`: is needed to assure that the bridge firewall rules work  (see section *Enable bridge firewall*)

### 2.2. Enable bridge firewall

The Archer 6 router is used as switch (the WAN port is not used).  
By default the firewall rules are not applied for LAN - LAN traffic.
To assure that firewall rules are also applied for LAN to LAN traffic we must enable bridge firewall as outlined in this section.

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

### 2.3. Create firewall reject traffic rules with appropriate schedule

From web interface goto Network > Firewall > Traffic Rules and add rules that "reject" access for the IP groups `sterre` and `mirko_and_co` during the workdays and during the weekend.

So the following 4 rules are created:

* `iprange_sterre_reject_during_workdays`
* `iprange_sterre_reject_during_weekend`
* `iprange_mirko_and_co_reject_during_workdays`
* `iprange_mirko_and_co_reject_during_weekend`

### 2.4 Create custom command to disable/enable the schedule firewall rules

Steps:

1. Copy [script/archer6/fw_reject_schedule.sh](script/archer6/fw_reject_schedule.sh) to archer6 (folder = `/root`)
     * Assure this script is executable (`chmod a+x fw_reject...`)
2. Create a custom command with name `reject schedule` via menu `System` > `Custom Commands` > tab `configure` that is calling `/root/fw_reject_schedule.sh` and allows Customs argument and Public access.
3. You can now trigger the command via menu `System` > `Custom Commands` > tab `Dashboard`.
   * On this tab you can also get the URL (click on `link` and take the url next to `display result`) to launch the script from the browser
      * the script parameters can be passed as specified in forum topic [How to pass arguments in custom command link url?](https://forum.openwrt.org/t/how-to-pass-arguments-in-custom-command-link-url/108804)

## 4. Create google site page to trigger custom command

Create a google site page with 4 buttons:

* `(re)enable schedule Sterre`
* `(re)enable schedule others (includes Mirko)`
* `disable schedule Sterre`
* `disable schedule others (includes Mirko)`

These buttons open a custom command URL (see previous section) with appropriate 2 parameters to enable/disable the schedule for sterre or mirko.

## 3. Iphones - disable `Private Address` for `lan_jan` and `lan_jan_5g`

Iphones when connecting to wifi network are each time using a different MAC address.  This makes that DHCP can not use the MAC address to assign a specific IP address.
To overcome this issue you must disable this feature for the `lan_jan` wifi network and als for `lan_jan_5g` wifi.
This can be disabled on iphone through following steps:

1. Goto Settings > Wi-Fi
2. click on (i) - information of `lan_jan`
3. disable the check box `Private Address`
4. ... and do the same steps for `lan_jan_5g` wifi network
