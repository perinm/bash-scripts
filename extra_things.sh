COMMAND=nordvpn
if ! command -v $COMMAND &> /dev/null; then
    sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
    # nordvpn set obfuscate on
    nordvpn set firewall on
    nordvpn set killswitch on
    nordvpn set autoconnect on
    nordvpn set ipv6 on
    nordvpn set dns 1.1.1.1 8.8.8.8 8.8.4.4
    # nordvpn set autoconnect on Obfuscated_Servers
else
    echo "$COMMAND found"
fi