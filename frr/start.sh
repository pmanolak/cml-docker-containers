#!/bin/sh

CONFIG=/config/node.cfg
BOOT=/config/boot.sh

# Not needed for Docker
# for iface in /sys/class/net/*; do
#   iface_name=$(basename "$iface")
#   if /usr/sbin/ethtool "$iface_name" &>/dev/null; then
#     /usr/sbin/ethtool -K "$iface_name" tx off
#   fi
# done

# done in day0 via docker shim
# if [ -f $BOOT ]; then
#     source $BOOT
# fi
if [ -f $CONFIG ]; then
    cp $CONFIG /etc/frr/frr.conf
fi

hostname_value="router"
if grep -q "^hostname" $CONFIG; then
    hostname_value=$(awk '/^hostname/ {print $2}' $CONFIG)
fi
hostname $hostname_value

/usr/lib/frr/frrinit.sh start

trap '' INT TSTP
while true; do
    /usr/bin/vtysh
done
