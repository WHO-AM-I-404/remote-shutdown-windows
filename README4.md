# Panduan Lengkap Remote Shutdown / Restart Windows 10/11 Tanpa Aplikasi Tambahan

(Target Laptop Windows 10/11, Pengendali PC atau HP di Jaringan Sama)

---

## 1. Aktifkan File & Printer Sharing dan Network Discovery di Laptop Target

**Tujuan:** Agar laptop bisa ditemukan dan diakses oleh perangkat lain dalam jaringan.

**Langkah:**
- Tekan tombol **Windows**, ketik dan buka **Control Panel**.
- Pilih **Network and Internet** → klik **Network and Sharing Center**.
- Di sebelah kiri, klik **Change advanced sharing settings**.
- Pilih profil jaringan yang sedang digunakan (biasanya **Private**).
- Di bagian **Network discovery**, pilih **Turn on network discovery**.
- Di bagian **File and printer sharing**, pilih **Turn on file and printer sharing**.
- Klik **Save changes** di bagian bawah.

---

## 2. Atur Kebijakan Agar Remote Shutdown Dapat Dilakukan Tanpa Password (Opsional)

> *Windows secara default menolak login jaringan tanpa password demi keamanan.*

### Langkah untuk Windows 10/11 Pro (Group Policy Editor):
- Tekan **Win + R**, ketik `secpol.msc`, tekan **Enter**.
- Buka **Local Policies → Security Options**.
- Cari opsi:  
  `Accounts: Limit local account use of blank passwords to console logon only`
- Klik dua kali, ubah menjadi **Disabled**.
- Tutup jendela.

### Langkah untuk Windows 10/11 Home (tanpa Group Policy Editor):
- Jalankan **Command Prompt** sebagai Administrator:
- ipconfig

- Cari bagian **IPv4 Address** (contoh: `192.168.0.55`).
- Catat alamat IP ini.

---

## 7. Uji Remote Shutdown dari PC Pengendali

- Di PC pengendali (Windows atau Termux Android):
- Buka **Command Prompt** atau Terminal.
- Ketik perintah shutdown:
- Untuk shutdown:
  ```
  shutdown /s /m \\192.168.0.55 /t 0
  ```
- Untuk restart:
  ```
  shutdown /r /m \\192.168.0.55 /t 0
  ```
- Jika konfigurasi benar, laptop akan langsung mati/restart tanpa konfirmasi.

---

## 8. Buat File .BAT di PC Pengendali untuk Eksekusi Sekali Klik

- Buka **Notepad**.
- Ketik perintah berikut (ubah IP sesuai laptop target):

@echo off
shutdown /s /m \192.168.0.55 /t 0

- Simpan file dengan nama `matikan_laptop.bat` (tipe file: **All Files**).
- Sekarang cukup double-click file ini → laptop langsung mati.

---

## 9. Cara Remote dari HP Menggunakan Termux (Advanced)

- Install aplikasi **Termux** di HP Android.
- Install paket Samba Client:
- pkg install samba-client
- - Sambungkan ke PC target dengan perintah:
smbclient //192.168.0.55/C$ -U username

- Untuk perintah shutdown via PowerShell Remoting atau tools lain, diperlukan setup lanjutan.

---

# Tips dan Catatan Penting

- Jangan hapus password kalau laptop dipakai di jaringan publik/berbahaya (risiko keamanan).
- Pastikan hanya kamu atau orang terpercaya yang punya akses ke PC pengendali.
- Jaringan harus stabil agar perintah shutdown dapat dijalankan.

  - Klik Start, ketik `cmd`, klik kanan, pilih **Run as administrator**.
- Ketik perintah berikut, lalu tekan Enter:
