# shadowsocks and v2ray-plugin
Runnig shadowsocks with v2ray-plugin
```bash
$ git clone https://github.com/FaridTofighi/shadowsoks.git
$ docker build -t shadowsocks:va2ray . --no-cache
$ docker run -itd -e PASSWORD=<password> -e DNS_ADDRS=1.1.1.1 -e SERVER_PORT=8383 -p 8080:8383 shadowsocks:v2ray
```
