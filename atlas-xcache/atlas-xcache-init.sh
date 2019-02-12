#!/bin/bash

/usr/local/sbin/fix_certs.sh

while read disk; do
    if [ ! -d "$disk" ]; then
        echo "WARNING: Missing directory: $disk"
    else
        echo "oss.space data $disk" >> /etc/xrootd/config.d/40-data-disks.cfg
    fi
done < /etc/xrootd/cache-disks.config

if [ -n "$DISABLE_OSG_MONITORING" ]; then
    echo -e "set DisableOsgMonitoring = $DISABLE_OSG_MONITORING\n" >> /etc/xrootd/config.d/10-docker-env-var.cfg
fi

su xrootd -c "xrootd -c /etc/xrootd/xrootd-atlas-xcache.cfg -k fifo -n atlas-xcache -k 10 -s /var/run/xrootd/xrootd-atlas-xcache.pid -l /var/log/xrootd/xrootd.log"
