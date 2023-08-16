#!/usr/bin/env bash

apt update
apt install -y unzip

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
wget -O /usr/local/etc/xray/config.json https://github.com/bjzhou/xray-server-setup/raw/main/xray/config.json
newpass=`openssl rand -base64 16`
sed -i "s/PASSWORD_PLACEHOLER/$newpass/g" /usr/local/etc/xray/config.json
wget -O mosdns.zip https://github.com/IrineSistiana/mosdns/releases/download/v5.1.3/mosdns-linux-amd64.zip
mkdir mosdns_temp
unzip mosdns.zip -d mosdns_temp
mv mosdns_temp/mosdns /usr/local/bin/mosdns
chmod +x /usr/local/bin/mosdns
rm -rf mosdns_temp
mkdir /etc/mosdns
wget -O /etc/mosdns/config.yaml https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/config.yaml
wget -O /etc/mosdns/geoip_cloudflare.txt https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/geoip_cloudflare.txt
wget -O /etc/mosdns/geosite_netflix https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/geosite_netflix
wget -O /etc/systemd/system/mosdns.service https://github.com/bjzhou/xray-server-setup/raw/main/mosdns/mosdns.service
systemctl enable mosdns.service
systemctl start mosdns.service

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
echo "net.ipv4.tcp_slow_start_after_idle=0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_notsent_lowat=16384" >> /etc/sysctl.conf
sysctl -p

systemctl restart xray
ip=`curl ifconfig.me`
echo "server：$ip\nport：25000\nmethod：2022-blake3-aes-128-gcm\npassword: $newpass"