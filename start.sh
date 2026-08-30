#!/bin/sh
set -e

# ۱. تثبیت پورت داخلی روی ۲۱۵۴۴ (مطابق با TCP Proxy در ریل‌وی)
PORT="21544"

# ۲. کلید احراز هویت Fake-TLS (پیش‌فرض: www.cloudflare.com)
KEY="${AUTH_KEY:-${SECRET:-eed34e5658e41a995252834b92b6a95f7777772e636c6f7564666c6172652e636f6d}}"
KEY="$(echo "$KEY" | tr -d '[:space:]' | tr -d '\r' | tr -d '\n')"

# ۳. پالایش تگ اسپانسر تلگرام (اختیاری)
TAG="${AD_TAG:-${TAG:-}}"
TAG="$(echo "$TAG" | tr -d '[:space:]' | tr -d '\r' | tr -d '\n')"

ROUTE_PREF="${ROUTE_PREF:-prefer-ipv4}"
MAX_WORKERS="${MAX_WORKERS:-8192}"

# لاگ‌های استتار شده
echo "=========================================================="
echo " [System] Microservice Gateway Daemon v2.5 (Active)"
echo " [System] Fake-TLS Secret: Configured"
echo " [System] Listening on: 0.0.0.0:${PORT}"
echo " [System] Routing: ${ROUTE_PREF} | Concurrency: ${MAX_WORKERS}"
echo " [System] Service Status: Running & Ready"
echo "=========================================================="

if [ -n "$TAG" ]; then
  cat <<EOF > /tmp/config.toml
secret = "${KEY}"
bind-to = "0.0.0.0:${PORT}"
concurrency = ${MAX_WORKERS}
prefer-ip = "${ROUTE_PREF}"
auto-update = true
allow-fallback-on-unknown-dc = true
ad-tag = "${TAG}"
debug = false
EOF
  exec /usr/local/bin/sys-daemon run /tmp/config.toml
else
  # حالت استاندارد و فوق‌سریع simple-run بدون ایجاد تداخل در هندشیک تلگرام
  exec /usr/local/bin/sys-daemon simple-run -i "${ROUTE_PREF}" -c "${MAX_WORKERS}" "0.0.0.0:${PORT}" "${KEY}"
fi
