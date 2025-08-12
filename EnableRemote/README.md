# Panduan Lengkap Penggunaan Remote Shutdown Script

## Instalasi & Menjalankan Script

1. **Salin kode script** dan simpan sebagai file `.ps1` (misal: `EnableRemote.ps1`).
2. Klik kanan file tersebut dan pilih **"Run with PowerShell"**.
3. Jika muncul peringatan keamanan, pilih **"Yes"** atau **"More info" → "Run anyway"**.

## Hasil Eksekusi Script

Setelah dijalankan:

* Akan muncul **alamat IP laptop target** (catat alamat ini).
* Terdapat 3 file baru di desktop:

  * `RemoteShutdown.lnk` → Untuk mematikan PC.
  * `RemoteRestart.lnk` → Untuk restart PC.
  * `Petunjuk Remote.txt` → Panduan lengkap penggunaan.

## Menggunakan Command Prompt

```cmd
:: Untuk mematikan PC target
shutdown /s /m \\[IP-TARGET] /t 0

:: Untuk restart PC target
shutdown /r /m \\[IP-TARGET] /t 0
```

> Ganti `[IP-TARGET]` dengan alamat IP yang didapat dari program.

## Menggunakan Termux (Android)

```bash
# 1. Install Termux dari Play Store
# 2. Buka Termux dan ketik:
pkg update && pkg install busybox

# 3. Untuk mematikan PC target:
busybox shutdown -s -f -t 0 now \\[IP-TARGET]

# 4. Untuk restart PC target:
busybox shutdown -r -f -t 0 now \\[IP-TARGET]
```

> Ganti `[IP-TARGET]` dengan alamat IP yang didapat dari program.

## Catatan Penting

* Pastikan PC target dan perangkat pengendali berada **dalam jaringan WiFi yang sama**.
* Untuk akun tanpa password, gunakan **Microsoft Account**.
* Jika terjadi masalah, coba **nonaktifkan sementara Windows Defender Firewall**.
* Untuk akun lokal tanpa password, aktifkan fitur **Tambahkan akun Microsoft** di Windows Settings.

## Fitur Script

* Mengaktifkan semua fitur jaringan yang diperlukan.
* Mengkonfigurasi firewall secara otomatis.
* Memberikan hak akses remote shutdown.
* Menampilkan alamat IP target.
* Membuat shortcut 1-klik di desktop.
* Membuat panduan penggunaan otomatis.
* Kompatibel dengan Windows 10/11 Home dan Pro.

## FAQ

**Q:** Apakah bisa dijalankan di Termux?
**A:** Ya! Dengan menginstal paket busybox di Termux, Anda bisa menggunakan perintah `busybox shutdown` untuk mengontrol PC target.

**Q:** Apakah perlu menjalankan program setiap kali?
**A:** Tidak, cukup jalankan sekali. Konfigurasi bersifat permanen sampai diubah manual.

**Q:** Bagaimana jika IP berubah?
**A:** Jalankan kembali program untuk mendapatkan IP baru, shortcut akan otomatis diperbarui.

**Q:** Apakah aman?
**A:** Konfigurasi ini hanya membuka akses di jaringan lokal. Pastikan jaringan WiFi Anda aman.

---

 *Program ini akan menghemat waktu Anda dan membuat remote access menjadi sangat mudah tanpa perlu konfigurasi manual yang rumit!*
