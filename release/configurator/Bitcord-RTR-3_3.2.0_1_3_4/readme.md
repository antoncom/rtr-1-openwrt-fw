
# Архив конфигурации

Опциональные пакеты по умолчанию не включены в сборку 
| Список опций | Включённые пакеты | Опциональные пакеты  |
|---|---|---|
| OpenWrt-22-03 | Applogic | Kmod-usb-serial-xxx |
| Web-интерфейс | tsm* | kmod-ipsec |
| Сервис управления GSM-модемом (Tsmodem) | kmod-usb-hid-cp2112 | libreswan |
| Сервис приёма/передачи SMS (Tsmsms) | kmod-usb-serial-ftdi | openssl-util |
| Сервис управления микроконтролером (Tsmstm) | kmod-usb-serial-pl2303 | ip-full |
| Сервис основной логики работы прибора (Applogic) | Kmod-usb-serial-cp210x | kmod-tun |
| Доступ к роутеру по SSH | kmod-usb-serial-ch341 | wpa-supplicant-basic  |
| Доступ к роутеру по Telnet | kmod-usb-acm | luci-app-ddns |
| Журнал событий прибора (Tsmjournal) | ppp-mod-pptp | luci-app-snmpd |
| GPIO (управляемый через веб-интерфейс) | xl2tpd |
| RS-232 (управляемый через веб-интерфейс) | ppp-mod-pppol2tp |
| RS-485 (управляемый через веб-интерфейс) | kmod-l2tp  |
| GNSS | luci-app-openvpn |
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
|  | ddns-scripts-services |
|  | snmpd |
