# ==============================================================================
# مرحله دریافت باینری اصلی
# ==============================================================================
FROM nineseconds/mtg:2 AS binary_source

# ==============================================================================
# Production Runtime: ایمیج رسمی و سبک آلپاین با استتار کامل پروسه
# ==============================================================================
FROM alpine:3.19

WORKDIR /app
RUN apk add --no-cache ca-certificates tzdata dos2unix

# کپی باینری و تغییر نام آن به sys-daemon (جهت استتار کامل در مانیتورینگ پردازه‌ها)
COPY --from=binary_source /mtg /usr/local/bin/sys-daemon

# کپی اسکریپت استارت و تبدیل فرمت به LF یونیکس
COPY start.sh /app/start.sh
RUN dos2unix /app/start.sh && chmod +x /app/start.sh

# متغیرهای محیطی استتار شده
ENV PORT=21544
ENV AUTH_KEY=eed34e5658e41a995252834b92b6a95f7c676f6f676c652e636f6d

EXPOSE 21544

ENTRYPOINT ["/app/start.sh"]
