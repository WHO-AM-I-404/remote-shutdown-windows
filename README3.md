# Panduan Ultra-Mendetail: Menghubungkan Windows 10/11 dari HP via Termux Menggunakan SSH Tanpa Password

Panduan ini menjelaskan cara mengatur SSH key agar Anda dapat mengakses atau mengendalikan Windows 10/11 dari HP (Termux) **tanpa memasukkan password setiap kali**, dengan skenario:

* Koneksi dalam **jaringan Wi-Fi yang sama** (misalnya Wi-Fi kelas).
* Komputer target adalah milik Anda (Windows 10/11).
* HP Android menjalankan Termux.
* Menggunakan metode **SSH dengan key authentication**.

---

## 1. Persiapan di Windows 10/11

### 1.1 Aktifkan OpenSSH Server

1. **Buka Settings** → `Apps` → `Optional features`.
2. Klik **Add a feature**.
3. Cari **OpenSSH Server** → klik **Install**.
4. Tunggu hingga selesai.

### 1.2 Aktifkan Service SSH

1. Tekan **Win + R**, ketik `services.msc`, tekan **Enter**.
2. Cari **OpenSSH SSH Server**.
3. Klik kanan → **Properties**.
4. Ubah **Startup type** menjadi **Automatic**.
5. Klik **Start**, lalu **Apply**.

---

## 2. Mengetahui IP Address Windows

1. Tekan **Win + R**, ketik `cmd`.
2. Jalankan perintah:

   ```cmd
   ipconfig
   ```
3. Catat **IPv4 Address** (contoh: `192.168.1.50`).

---

## 3. Menyiapkan SSH Key di Termux (HP)

### 3.1 Instal OpenSSH di Termux

```bash
pkg update && pkg upgrade
pkg install openssh
```

### 3.2 Membuat SSH Key Pair

```bash
ssh-keygen -t rsa -b 4096
```

* **File akan disimpan di:**

  * Private key: `/data/data/com.termux/files/home/.ssh/id_rsa`
  * Public key: `/data/data/com.termux/files/home/.ssh/id_rsa.pub`
* Saat diminta passphrase, tekan **Enter** saja (biar tidak ada password).

### 3.3 Menyalin Public Key ke Windows

Gunakan perintah untuk menampilkan key:

```bash
cat ~/.ssh/id_rsa.pub
```

Salin hasilnya.

---

## 4. Memasukkan Public Key ke Windows

### 4.1 Buat Folder `.ssh` di Windows

1. Buka **File Explorer**.
2. Masuk ke:

   ```
   C:\Users\<USERNAME>
   ```

   Ganti `<USERNAME>` dengan nama user Windows Anda.
3. Buat folder baru bernama:

   ```
   .ssh
   ```

### 4.2 Buat File `authorized_keys`

1. Buka **Notepad**.
2. Paste **public key** yang tadi Anda salin.
3. Simpan dengan nama:

   ```
   authorized_keys
   ```
4. Pastikan file ini tersimpan di:

   ```
   C:\Users\<USERNAME>\.ssh\authorized_keys
   ```

### 4.3 Atur Permission File `.ssh`

1. Klik kanan folder `.ssh` → **Properties** → **Security**.
2. Pastikan hanya **user Anda** yang punya akses **Full Control**.

---

## 5. Menguji Koneksi SSH Tanpa Password

Di Termux jalankan:

```bash
ssh <USERNAME>@<IP-WINDOWS>
```

Contoh:

```bash
ssh dave@192.168.1.50
```

Jika berhasil, Anda akan langsung masuk ke Windows Command Prompt tanpa diminta password.

---

## 6. Perintah untuk Shutdown/Restart dari HP

### 6.1 Shutdown

```bash
ssh <USERNAME>@<IP-WINDOWS> "shutdown /s /f /t 0"
```

### 6.2 Restart

```bash
ssh <USERNAME>@<IP-WINDOWS> "shutdown /r /f /t 0"
```

---

## 7. Lokasi File Penting

| Perangkat   | Fungsi          | Lokasi                                             |
| ----------- | --------------- | -------------------------------------------------- |
| HP (Termux) | Private key     | `/data/data/com.termux/files/home/.ssh/id_rsa`     |
| HP (Termux) | Public key      | `/data/data/com.termux/files/home/.ssh/id_rsa.pub` |
| Windows     | Authorized keys | `C:\Users\<USERNAME>\.ssh\authorized_keys`         |

---

## 8. Tips Keamanan

* **Jangan bagikan file private key** (`id_rsa`).
* Gunakan jaringan aman (Wi-Fi sekolah bisa diintip orang lain).
* Matikan SSH Server jika tidak digunakan.

---

Dengan cara ini, Anda bisa **restart atau shutdown laptop dari HP** tanpa password, selama keduanya berada di jaringan Wi-Fi yang sama.


# Panduan Mematikan & Mengaktifkan Kembali Server SSH di Windows

Berikut adalah panduan **ultra-detail** untuk mematikan dan mengaktifkan kembali server SSH di Windows.

---

## 1. Mematikan Server SSH

**Langkah 1:** Buka **Command Prompt** atau **PowerShell** dengan hak administrator.

* Klik **Start** → ketik `cmd` atau `powershell`
* Klik kanan → pilih **Run as administrator**

**Langkah 2:** Jalankan perintah untuk menghentikan layanan SSH.

```powershell
net stop sshd
```

Jika berhasil, akan muncul pesan:

```
The OpenSSH SSH Server service was stopped successfully.
```

**Langkah 3 (Opsional):** Jika ingin menonaktifkan agar SSH tidak otomatis berjalan saat Windows menyala:

```powershell
sc config sshd start= disabled
```

---

## 2. Mengaktifkan Kembali Server SSH

**Langkah 1:** Buka **Command Prompt** atau **PowerShell** sebagai administrator (seperti langkah sebelumnya).

**Langkah 2:** Aktifkan kembali layanan SSH jika sebelumnya dinonaktifkan:

```powershell
sc config sshd start= auto
```

**Langkah 3:** Jalankan perintah untuk memulai layanan SSH:

```powershell
net start sshd
```

Jika berhasil, akan muncul pesan:

```
The OpenSSH SSH Server service was started successfully.
```

---

## 3. Lokasi File Konfigurasi SSH di Windows

* File konfigurasi utama: `C:\ProgramData\ssh\sshd_config`
* Folder kunci host SSH: `C:\ProgramData\ssh`
* Lokasi executable: `C:\Windows\System32\OpenSSH\sshd.exe`

---

## 4. Tips Keamanan

* Gunakan password yang kuat atau **SSH key**.
* Jika SSH hanya untuk jaringan lokal, pertimbangkan untuk memblokir akses dari internet melalui **Windows Firewall**.

---

Dengan panduan ini, kamu bisa mematikan server SSH saat tidak digunakan untuk keamanan, dan mengaktifkannya kembali saat diperlukan.

