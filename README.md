# xray-server-setup

My self server setup script

### Install script

```
bash -c "$(curl -L https://github.com/bjzhou/xray-server-setup/raw/main/install.sh)"
```

### Filesystem

* Xray

```
installed: /etc/systemd/system/xray.service
installed: /etc/systemd/system/xray@.service

installed: /usr/local/bin/xray
installed: /usr/local/etc/xray/config.json

installed: /usr/local/share/xray/geoip.dat
installed: /usr/local/share/xray/geosite.dat

installed: /var/log/xray/access.log
installed: /var/log/xray/error.log
```

* mosdns

```
installed: /etc/systemd/system/mosdns.service
installed: /usr/local/bin/mosdns
installed: /etc/mosdns/config.yaml
installed: /etc/mosdns/geoip_cloudflare.txt
installed: /etc/mosdns/geosite_netflix.txt
```

### Cloudflare Speed test

https://github.com/XIU2/CloudflareSpeedTest/releases

```
./CloudflareST -url https://download.parallels.com/desktop/v15/15.1.5-47309/ParallelsDesktop-15.1.5-47309.dmg
```

### Credits

* [Xray core](https://github.com/XTLS/Xray-core)
* [Xray install](https://github.com/XTLS/Xray-install)
* [mosdns](https://github.com/IrineSistiana/mosdns)
