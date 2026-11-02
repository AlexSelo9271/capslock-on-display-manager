#!/bin/bash
set -e

SERVICE_NAME="capslock-on-display-manager.service"
SCRIPT_DST="/usr/local/bin/enable-capslock"
SERVICE_DST="/etc/systemd/system/$SERVICE_NAME"

if [ "$EUID" -ne 0 ]; then
    echo "Необходимы права root, например: sudo $0"
    exit 1
fi

if systemctl list-unit-files "$SERVICE_NAME" &>/dev/null; then
    systemctl disable --now "$SERVICE_NAME" 2>/dev/null || true
    echo "Сервис остановлен и отключён: $SERVICE_NAME"
else
    echo "Сервис $SERVICE_NAME не зарегистрирован, пропускаем."
fi

if [ -f "$SERVICE_DST" ]; then
    rm -f "$SERVICE_DST"
    echo "Удалён: $SERVICE_DST"
else
    echo "Файл $SERVICE_DST не найден, пропускаем."
fi

if [ -f "$SCRIPT_DST" ]; then
    rm -f "$SCRIPT_DST"
    echo "Удалён: $SCRIPT_DST"
else
    echo "Файл $SCRIPT_DST не найден, пропускаем."
fi

systemctl daemon-reload
systemctl reset-failed 2>/dev/null || true

echo
echo "Готово! Сервис удалён."
