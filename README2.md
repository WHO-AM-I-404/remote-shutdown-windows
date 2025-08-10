# Remote Shutdown/Restart PC dari Termux Tanpa Password (Jaringan Lokal)

Panduan ini menjelaskan secara **lengkap dan sangat mendetail** bagaimana melakukan **shutdown** atau **restart** PC Windows dari HP Android menggunakan Termux, tanpa perlu memasukkan password Windows. Metode ini memanfaatkan fitur bawaan Windows, dan berlaku jika PC dan HP berada di **jaringan yang sama** (LAN atau Wi-Fi).

---

## 1. Prasyarat

* **PC Windows** (Home/Pro) di jaringan yang sama dengan HP
* **HP Android** dengan **Termux** terinstall
* Koneksi LAN atau Wi-Fi yang sama (Private network)
* Akses admin di PC Windows (untuk mengubah pengaturan)

---

## 2. Konfigurasi Windows Agar Tidak Meminta Password

### 2.1 Matikan Password Protected Sharing

1. Buka **Control Panel**
2. Pilih **Network and Sharing Center**
3. Klik **Change advanced sharing settings**
4. Scroll ke bagian **All Networks**
5. Pada **Password protected sharing**, pilih **Turn off password protected sharing**
6. Klik **Save changes**

### 2.2 Aktifkan File and Printer Sharing

* Di menu yang sama, untuk profil **Private**, aktifkan **Turn on file and printer sharing**

### 2.3 Izinkan Remote Shutdown Tanpa Login

1. Tekan `Win + R`, ketik `secpol.msc` lalu tekan Enter

   * (Jika tidak ada, Windows Home bisa mengubah registry secara manual atau gunakan `gpedit.msc` jika tersedia)
2. Masuk ke **Local Policies → User Rights Assignment**
3. Buka **Force shutdown from a remote system**
4. Klik **Add User or Group**
5. Ketik **Everyone** lalu klik **OK**

### 2.4 Aktifkan Remote Registry Service

1. Tekan `Win + R`, ketik `services.msc` lalu tekan Enter
2. Cari **Remote Registry**
3. Klik kanan → **Properties**
4. Ubah **Startup type** menjadi **Automatic**
5. Klik **Start**

### 2.5 Buka Firewall untuk Remote Shutdown

1. Buka **Windows Defender Firewall → Advanced Settings**
2. Pilih **Inbound Rules**
3. Cari **File and Printer Sharing (SMB-In)** untuk **Private** profile
4. Pastikan statusnya **Enabled**

---

## 3. Instalasi Tools di Termux

### 3.1 Update & Install Paket yang Dibutuhkan

Buka Termux di HP dan jalankan:

```bash
pkg update && pkg upgrade -y
pkg install samba-utils -y
```

`net rpc` dari paket `samba-utils` akan digunakan untuk mengirim perintah shutdown/restart ke PC.

---

## 4. Menjalankan Shutdown/Restart dari Termux

### 4.1 Shutdown PC

```bash
net rpc shutdown -I 192.168.1.5 -U ""%
```

Ganti `192.168.1.5` dengan IP atau hostname PC target.

### 4.2 Restart PC

```bash
net rpc shutdown -r -I 192.168.1.5 -U ""%
```

Keterangan:

* `-I` → IP address atau hostname target
* `-r` → Restart (hapus jika hanya shutdown)
* `-U ""%` → Username kosong + password kosong (karena sudah dimatikan proteksi password)

---

## 5. Membuat Script Otomatis di Termux

Agar tidak mengetik perintah panjang setiap kali, buat file script:

1. Buat file:

```bash
nano ~/pc-control.sh
```

2. Isi dengan:

```bash
#!/data/data/com.termux/files/usr/bin/sh

PC_IP="192.168.1.5"  # Ganti dengan IP PC target
ACTION=${1:-shutdown} # default shutdown, bisa "restart"

if [ "$ACTION" = "shutdown" ]; then
    net rpc shutdown -I $PC_IP -U ""%
elif [ "$ACTION" = "restart" ]; then
    net rpc shutdown -r -I $PC_IP -U ""%
else
    echo "Gunakan: ./pc-control.sh [shutdown|restart]"
fi
```

3. Simpan (CTRL + O, Enter, CTRL + X)
4. Jadikan file bisa dieksekusi:

```bash
chmod +x ~/pc-control.sh
```

5. Contoh pemakaian:

```bash
./pc-control.sh shutdown
./pc-control.sh restart
```

---

## 6. Troubleshooting

* **Perintah tidak jalan** → Pastikan PC dan HP ada di jaringan yang sama.
* **Error: NT\_STATUS\_ACCESS\_DENIED** → Cek lagi apakah Password Protected Sharing sudah dimatikan.
* **Timeout** → Cek IP target dengan `ping 192.168.x.x` dari Termux.
* **Command not found** → Pastikan `samba-utils` sudah terinstall.

---

## 7. Tips Keamanan

* Metode ini membuka akses shutdown ke semua orang di jaringan. Gunakan **hanya di jaringan pribadi**.
* Untuk keamanan lebih, gunakan VLAN atau firewall untuk membatasi IP yang bisa mengakses PC.
* Matikan kembali fitur ini jika sudah tidak diperlukan.

---

Dengan mengikuti panduan ini, kamu bisa **shutdown atau restart PC Windows dari Termux** hanya dengan sekali ketik, tanpa password, selama berada di jaringan yang sama.
