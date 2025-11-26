
# Архив конфигурации

Опциональные пакеты по умолчанию не включены в сборку 
| Список опций | Включённые пакеты | Опциональные пакеты  |
|---|---|---|
| OpenWrt-22-03 | Applogic | kmod-ipsec |
| Web-интерфейс | tsm* | libreswan |
| Сервис управления GSM-модемом (Tsmodem) |  | openssl-util |
| Сервис приёма/передачи SMS (Tsmsms) | ppp-mod-pptp | ip-full |
| Сервис управления микроконтролером (Tsmstm) | xl2tpd | kmod-tun |
| Сервис основной логики работы прибора (Applogic) | ppp-mod-pppol2tp | wpa-supplicant-basic  |
| Доступ к роутеру по SSH | kmod-l2tp  | luci-app-ddns |
| Доступ к роутеру по Telnet | luci-app-openvpn | luci-app-snmpd |
| Журнал событий прибора (Tsmjournal) | openvpn-openssl |
|  | kmod-gre  | Zabbix-extra-xxx |
| PPTP Client | kmod-gre6 |
| L2TPv2 Client | kmod-iptunnel  |
| L2TPv3 tunnels | kmod-iptunnel6 |
| OpenVPN tunnel | strongswan |
| GRE tunnels | iptables-mod-nat-extra |
| IPSec tunnels | kmod-ipsec |
| EoIP tunnels | kmod-crypto-gcm |
| VRRP | keepalived |
| DynDNS client | ddns-scripts |
| SNMP | ddns-scripts-services |
|  | snmpd |
| Zabbix-агент |  |
| SSMTP - отправка Email из роутера (tsmail) | zabbix-agentd  |
| ICMP | msmtp |
