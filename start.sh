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

# ۴. تنظیمات بهینه منابع و اتصالات
ROUTE_PREF="${ROUTE_PREF:-prefer-ipv4}"
MAX_WORKERS="${MAX_WORKERS:-8192}"
BUFFER_SIZE="${BUFFER_SIZE:-128kb}"

# ۵. شناسایی خودکار آی‌پی عمومی سرور
PUB_IP="${PUBLIC_IPV4:-}"
if [ -z "$PUB_IP" ] && [ -n "$RAILWAY_TCP_PROXY_DOMAIN" ]; then
  PUB_IP="$(getent hosts "$RAILWAY_TCP_PROXY_DOMAIN" | awk '{print $1}' | head -n 1 || true)"
fi
if [ -z "$PUB_IP" ]; then
  PUB_IP="1.1.1.1"
fi

# ۶. تنظیم DNS سریع Cloudflare جهت جلوگیری از اختلال در لود مدیا
if [ -w /etc/resolv.conf ]; then
  echo "nameserver 1.1.1.1" > /etc/resolv.conf
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf
fi

# ۷. ساخت فایل کانفیگ بهینه‌شده با ضد Replay، بافر پرسرعت و آپدیت خودکار دیتاسنترها
cat <<EOF > /tmp/config.toml
secret = "${KEY}"
bind-to = "0.0.0.0:${PORT}"
concurrency = ${MAX_WORKERS}
prefer-ip = "${ROUTE_PREF}"
public-ipv4 = "${PUB_IP}"
auto-update = true
allow-fallback-on-unknown-dc = true
anti-replay = true
buffer-size = "${BUFFER_SIZE}"
debug = false
EOF

if [ -n "$TAG" ]; then
  echo "ad-tag = \"${TAG}\"" >> /tmp/config.toml
fi

# لاگ‌های استتار شده
echo "=========================================================="
echo " [System] Microservice Gateway Daemon v2.5 (High Stability)"
echo " [System] Fake-TLS Cloaking Domain: www.cloudflare.com"
echo " [System] Listening on: 0.0.0.0:${PORT}"
echo " [System] Concurrency Pool: ${MAX_WORKERS} | Buffer: ${BUFFER_SIZE}"
echo " [System] Anti-Replay Protection: Enabled"
echo " [System] Status: Active & Ready"
echo "=========================================================="

# اجرای موتور اصلی با فایل کانفیگ بهینه‌سازی شده
exec /usr/local/bin/sys-daemon run /tmp/config.toml
