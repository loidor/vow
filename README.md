# vow
VPN on wifi monitor checks a list of safe wifi SSIDs. If you're connected to a wifi that's not on the list, wireguard starts. Equally, if you're on a safe wifi (that's already VPN protected), wireguard stops.

Install by running install.sh. Add your safe SSIDs, your wifi interface name and your wireguard config to /etc/vow.conf.
