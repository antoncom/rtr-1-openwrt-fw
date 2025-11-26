
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
| PPTP Client | ppp-mod-pptp |
| L2TPv2 Client | xl2tpd |
| L2TPv3 tunnels | ppp-mod-pppol2tp |
| OpenVPN tunnel | kmod-l2tp  |
| GRE tunnels | luci-app-openvpn |
| IPSec tunnels | openvpn-openssl |
| EoIP tunnels | kmod-gre  |
| VRRP | kmod-gre6 |
| DynDNS client | kmod-iptunnel  |
| SNMP | kmod-iptunnel6 |
|  | strongswan |
|  | iptables-mod-nat-extra |
|  | kmod-ipsec |
|  | kmod-crypto-gcm |
|  | keepalived |
|  | ddns-scripts |
|  | ddns-scripts-services |
|  | snmpd |
