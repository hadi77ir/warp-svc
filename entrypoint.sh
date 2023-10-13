#!/bin/bash
set -m
mkdir -p /var/lib/cloudflare-warp
cd /var/lib/cloudflare-warp
ln -s /dev/null cfwarp_daemon_dns.txt
ln -s /dev/null cfwarp_service_boring.txt
ln -s /dev/null cfwarp_service_dns_stats.txt
ln -s /dev/null cfwarp_service_log.txt
ln -s /dev/null cfwarp_service_stats.txt
cd /
warp-svc | grep -v DEBUG &
sleep 2

while ! [ -f "/var/lib/cloudflare-warp/conf.json" ]; do
echo "ENTRYPOINT: Waiting for WARP registration"
sleep 1
done

warp-cli --accept-tos set-proxy-port 40000
warp-cli --accept-tos set-mode proxy
warp-cli --accept-tos connect
socat tcp-listen:1080,reuseaddr,fork tcp:localhost:40000 &
fg %1
