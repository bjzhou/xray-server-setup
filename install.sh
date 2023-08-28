#!/usr/bin/env bash

apt update
apt install -y unzip

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
wget -O /usr/local/etc/xray/config.json https://github.com/bjzhou/xray-server-setup/raw/main/xray/config.json
newpass=`openssl rand -base64 16`
sed -i "s|PASSWORD_PLACEHOLDER|$newpass|g" /usr/local/etc/xray/config.json
wget -O mosdns.zip https://github.com/IrineSistiana/mosdns/releases/download/v5.1.3/mosdns-linux-amd64.zip
mkdir mosdns_temp
unzip mosdns.zip -d mosdns_temp
mv mosdns_temp/mosdns /usr/local/bin/mosdns
chmod +x /usr/local/bin/mosdns
rm -rf mosdns_temp
mkdir /etc/mosdns
wget -O /etc/mosdns/config.yaml https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/config.yaml
wget -O /etc/mosdns/geoip_cloudflare.txt https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/geoip_cloudflare.txt
wget -O /etc/mosdns/geosite_netflix.txt https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/geosite_netflix.txt
wget -O /etc/systemd/system/mosdns.service https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/mosdns.service
systemctl enable mosdns.service
systemctl start mosdns.service
rm -rf mosdns.zip

echo "
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_ecn = 2
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_notsent_lowat = 16384
" >> /etc/sysctl.conf
sysctl -p

systemctl restart xray
ip=`curl ifconfig.me`

echo "

Shadowsocks information 👇

server：$ip
port：25000
method：2022-blake3-aes-128-gcm
password: $newpass

"
