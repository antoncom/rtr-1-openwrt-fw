
# Архив конфигурации

Опциональные пакеты по умолчанию не включены в сборку 
| Список опций | Включённые пакеты | Опциональные пакеты  |
|---|---|---|
| OpenWrt-22-03 | Applogic | Kmod-usb-serial-xxx |
| Web-интерфейс | tsm* |
| Сервис управления GSM-модемом (Tsmodem) |  | kmod-ipsec |
| Сервис приёма/передачи SMS (Tsmsms) | kmod-usb-hid-cp2112 | libreswan |
| Сервис управления микроконтролером (Tsmstm) | kmod-usb-serial-ftdi | openssl-util |
| Сервис основной логики работы прибора (Applogic) | kmod-usb-serial-pl2303 | ip-full |
| Доступ к роутеру по SSH | Kmod-usb-serial-cp210x | kmod-tun |
| Доступ к роутеру по Telnet | kmod-usb-serial-ch341 | wpa-supplicant-basic  |
| Журнал событий прибора (Tsmjournal) | kmod-usb-acm | luci-app-ddns |
|  |  | luci-app-snmpd |
| GPIO (управляемый через веб-интерфейс) | ppp-mod-pptp |
| RS-232 (управляемый через веб-интерфейс) | xl2tpd | Zabbix-extra-xxx |
| RS-485 (управляемый через веб-интерфейс) | ppp-mod-pppol2tp |
| GNSS | kmod-l2tp  |
|  | luci-app-openvpn |
| PPTP Client | openvpn-openssl |
| L2TPv2 Client | kmod-gre  |
| L2TPv3 tunnels | kmod-gre6 |
| OpenVPN tunnel | kmod-iptunnel  |
| GRE tunnels | kmod-iptunnel6 |
| IPSec tunnels | strongswan |
| EoIP tunnels | iptables-mod-nat-extra |
| VRRP | kmod-ipsec |
| DynDNS client | kmod-crypto-gcm |
| SNMP | keepalived |
|  | ddns-scripts |
| PPP | ddns-scripts-services |
| TinyProxy | snmpd |
| DMVPN / NHRP tunnels |  |
|  | luci-proto-ppp |
| Zabbix-агент | ppp-mod-pppoe |
| SSMTP - отправка Email из роутера (tsmail) | kmod-ppp |
| ICMP | tinyproxy |
|  | kmod-ipip |
|  | kmod-pppox |
|  |  |
|  | zabbix-agentd  |
|  | msmtp |
