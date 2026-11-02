#!/bin/bash

set -e

SCRIPT_SRC="./src/enable-capslock"
SERVICE_SRC="./src/capslock-on-display-manager.service"

SCRIPT_DST="/usr/local/bin/enable-capslock"
SERVICE_DST="/etc/systemd/system/capslock-on-display-manager.service"

if [ "$EUID" -ne 0 ]; then
    echo "Необходимы права root, например: sudo $0"
    exit 1
fi

# Проверяем наличие исходников
for f in "$SCRIPT_SRC" "$SERVICE_SRC"; do
    if [ ! -f "$f" ]; then
        echo "Ошибка: не найден файл $f"
        exit 1
    fi
done

install -m 755 "$SCRIPT_SRC" "$SCRIPT_DST"
echo "Скрипт установлен: $SCRIPT_DST"

install -m 644 "$SERVICE_SRC" "$SERVICE_DST"
echo "Сервис установлен: $SERVICE_DST"

systemctl daemon-reload
systemctl enable capslock-on-display-manager.service

echo
echo "Готово! Сервис включён."
