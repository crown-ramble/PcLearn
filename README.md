# Telegram MTProto Proxy (High-Stability Edition)

پروکسی اختصاصی و فوق‌پایدار تلگرام با پروتکل Fake-TLS برای استقرار روی Railway.

---

## 🚀 ویژگی‌های نسخه پایدار (v2.5):
1. **استتار Fake-TLS روی دامنه `www.cloudflare.com`** جهت عبور بی‌دردسر از فیلترینگ و کاهش چشمگیر پکت‌دراپ.
2. **قابلیت Anti-Replay Protection** جهت جلوگیری از شناسایی توسط فایروال‌های هوشمند (DPI).
3. **تنظیم هوشمند بافر شبکه (128kb)** جهت دانلود فوق‌سریع ویدیوها و فایل‌های حجیم در تلگرام.
4. **رزولوشن سریع DNS با Cloudflare (`1.1.1.1`)** برای جلوگیری از ارورهای Updating.
5. **بهینه‌سازی مصرف حافظه رم (Concurrency Pool)** برای جلوگیری از کرش کانتینر در Railway.

---

## 🛠️ سکرت اتصال جدید:
```text
ee11223344556677889900aabbccddeeff7777772e636c6f7564666c6172652e636f6d
```

---

## 💻 دستورات ارسال به گیت‌هاب (Git Push):
```powershell
git add .
git commit -m "feat: upgrade to high stability fake-tls cloudflare and anti-replay"
git push origin main
```
