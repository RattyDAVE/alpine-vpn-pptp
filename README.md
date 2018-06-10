# VPN (PPTP) for Docker

This is a docker image with simple VPN (PPTP) server with _chap-secrets_ authentication.

PPTP uses _/etc/ppp/chap-secrets_ file to authenticate VPN users.
You need to create this file on your own and link it to docker when starting a container.

Example of _chap-secrets_ file:

````
# Secrets for authentication using PAP
# client    server      secret      acceptable local IP addresses
username    *           password    *
````

### Use Local DNS

To user the DNS SERVER on the local host machine set the environment variable "LOCALDNS=1".


## Starting VPN server

To start VPN server as a docker container run:

````
docker run -d --name VPN --restart unless-stopped --privileged --net=host -v {local_path_to_chap_secrets}:/etc/ppp/chap-secrets rattydave/alpine-vpn-pptp
````

Edit your local _chap-secrets_ file, to add or modify VPN users whenever you need.
When adding new users to _chap-secrets_ file, you don't need to restart Docker container.

## Connecting to VPN service
You can use any VPN (PPTP) client to connect to the service.
To authenticate use credentials provided in _chap-secrets_ file.

**Note:** Before starting container in `--net=host` mode, please read how networking in `host` mode works in Docker:
https://docs.docker.com/reference/run/#mode-host

## Using with adblocker

##### VPN with AD BLOCKER #####

This will is abcminiuser/docker-dns-ad-blocker as the DNS ad blocker. Then run the VPN with the local DNS setting.

````
docker run -d --restart unless-stopped --name DNS-AD-BLOCK -p 127.0.0.1:53:53/tcp -p 127.0.0.1:53:53/udp -e DNSCRYPT=1 -e DNS_CRYPT_SERVERS=adguard-dns oznu/dns-ad-blocker

echo "user * password *" > /root/chap-secrets

docker run -d --restart unless-stopped --privileged --name VPN --net=host -v /root/chap-secrets:/etc/ppp/chap-secrets -e "LOCALDNS=1" rattydave/alpine-vpn-pptp
````

