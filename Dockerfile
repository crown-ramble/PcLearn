# ==============================================================================
# مرحله دریافت باینری بهینه با پشتیبانی کامل از Fake-TLS و ضد فیلترینگ
# ==============================================================================
FROM ghcr.io/mhsanaei/mtg-multi:latest AS binary_source

# ==============================================================================
# Production Runtime: ایمیج سبک و پایدار Alpine با بهینه‌سازی شبکه
# ==============================================================================
FROM alpine:3.19

WORKDIR /app

# نصب ابزارهای مورد نیاز برای پردازش شبکه و اسکریپت
RUN apk add --no-cache ca-certificates tzdata dos2unix curl bind-tools

# کپی باینری و تغییر نام آن به sys-daemon (جهت استتار کامل در مانیتورینگ پردازه‌ها)
COPY --from=binary_source /mtg /usr/local/bin/sys-daemon

# کپی اسکریپت استارت و تبدیل فرمت به LF یونیکس
COPY start.sh /app/start.sh
RUN dos2unix /app/start.sh && chmod +x /app/start.sh

# متغیرهای محیطی بهینه‌سازی شده (دامنه Fake-TLS پیش‌فرض: www.cloudflare.com)
ENV PORT=21544
ENV AUTH_KEY=ee11223344556677889900aabbccddeeff7777772e77696b6970656469612e6f7267
ENV ROUTE_PREF=prefer-ipv4
ENV MAX_WORKERS=8192
ENV BUFFER_SIZE=128kb
ENV GODEBUG=netdns=go

EXPOSE 21544

ENTRYPOINT ["/app/start.sh"]
