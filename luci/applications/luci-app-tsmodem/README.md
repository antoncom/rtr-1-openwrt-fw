# tsmodem

OpenWrt LuCI page for Sim7600 modem management.

## Структура файлов

```bash
├── dev
├── luasrc
│   └── luci
│       ├── controller
│       │   └── ts_skw92a
│       ├── model
│       │   └── cbi
│       │       └── ts_skw92a
│       └── view
│           └── ts_skw92a
│               ├── ui_overrides
│               ├── ui_utils
│               └── ui_widgets
├── root
│   └── etc
│       ├── config
│       └── ts_skw92a
│           └── template
└── www
    └── luci-static
        └── resources
            └── ts_skw92a
                ├── fonts
                ├── icons
                ├── jquery
                └── utils

```

## Инструкция по установке

1. git clone https://github.com/antoncom/tsmodem.git
2. cd tsmodem
3. make install
4. Установить пакет luci_compat при помощи следующих команд:
* **opkg update**
* **opkg install luci-compat**
5. Перезапустить виртуальную машину
