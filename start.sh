#!/bin/sh
set -e

# ۱. پورت داخلی سرور
PORT="${PORT:-21544}"
PORT="$(echo "$PORT" | tr -d '[:space:]')"

# ۲. سکرت Fake-TLS گوگل
KEY="${AUTH_KEY:-${SECRET:-eed34e5658e41a995252834b92b6a95f7c676f6f676c652e636f6d}}"
KEY="$(echo "$KEY" | tr -d '[:space:]' | tr -d '\r' | tr -d '\n')"

# لاگ‌های استتار شده
echo "=========================================================="
echo " [System] Microservice Gateway Daemon v2.4 (Debug Mode)"
echo " [System] Listening on: 0.0.0.0:${PORT}"
echo " [System] Service Status: Active & Ready"
echo "=========================================================="

# اجرای مستقیم با حالت دیباگ کامل جهت مشاهده دقیق هندشیک تلگرام
exec /usr/local/bin/sys-daemon simple-run --debug "0.0.0.0:${PORT}" "${KEY}"
