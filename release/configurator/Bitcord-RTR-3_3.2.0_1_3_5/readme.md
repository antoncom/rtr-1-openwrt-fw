
# Архив конфигурации

Опциональные пакеты по умолчанию не включены в сборку 
| Список опций | Включённые пакеты | Опциональные пакеты  |
|---|---|---|
| OpenWrt-22-03 | Applogic | Kmod-usb-serial-xxx |
| Web-интерфейс | tsm* |
| Сервис управления GSM-модемом (Tsmodem) |  | ppp-mod-pppol2tp |
| Сервис приёма/передачи SMS (Tsmsms) | kmod-usb-hid-cp2112 |
| Сервис управления микроконтролером (Tsmstm) | kmod-usb-serial-ftdi |
| Сервис основной логики работы прибора (Applogic) | kmod-usb-serial-pl2303 |
| Доступ к роутеру по SSH | Kmod-usb-serial-cp210x |
| Доступ к роутеру по Telnet | kmod-usb-serial-ch341 |
| Журнал событий прибора (Tsmjournal) | kmod-usb-acm |
|  |  |
| GPIO (управляемый через веб-интерфейс) | luci-proto-ppp |
| RS-232 (управляемый через веб-интерфейс) | ppp-mod-pptp |
| RS-485 (управляемый через веб-интерфейс) | ppp-mod-pppoe |
| GNSS | kmod-ppp |
|  | Kmod-pppox |
| PPP | tinyproxy |
| TinyProxy | kmod-ipip |
| DMVPN / NHRP tunnels | kmod-pppox |
|  | strongswan |
