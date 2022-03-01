# my-network

1. [Setup of Firewall Reject Schedule](reject_schedule.md)

## Register domain name with vimexx

I have registered an account at [vimexx.nl](https://www.vimexx.nl/)
and created a cheap domain name (1.56€ for the first year).

Then I have changed the nameservers to the 3 name servers of digital ocean:

* `ns2.digitalocean.com`
* `ns3.digitalocean.com`
* `ns1.digitalocean.com`

Note that this takes quite some time before they are effectively used.

## Digital Ocean Setup

I have registered an account at [DigitalOcean](https://digitalocean.com)

Under `Networking` I added the domain I have registered above at `Vimexx.nl`.
For that domain I have manually created an `A record` with

* `Hostname = @`
* `will direct to =` *the public IP address of my bbox modem*

It takes some time before the above changes appear to be working.
On mac OS it might be needed to clear the local DNS cache to speed it up:

* [How to clear the local DNS cache in Mac OS?](https://www.siteground.com/kb/how_to_clear_the_local_dns_cache_in_mac_os/?gclid=CjwKCAiApfeQBhAUEiwA7K_UH5eumUWdwNRccF9YaWIdarNxnSGFYBkPGYD0UtgIJdfdhBaglnk6QhoCSn0QAvD_BwE)
