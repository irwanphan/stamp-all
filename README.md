# 📦 STAMP Pertamina Dashboard (Offline First)

Aplikasi lintas platform untuk mengelola data stakeholder secara offline dan aman, dengan fitur pencarian, pengelompokan individu & instansi, serta backup terenkripsi.

---

## 🚀 Fitur Utama
- CRUD data **Individu** dan **Instansi** secara offline
- Navigasi melalui **sidebar** antar modul
- Backup dan Restore data SQLite dengan **AES-256 encryption**
- UI responsif untuk **desktop dan mobile**

---

## 🛠️ Teknologi yang Digunakan
- [Flutter](https://flutter.dev/) (>=3.10)
- SQLite via `sqflite`
- `path_provider` untuk path file
- `encrypt` untuk enkripsi backup

---

## 📁 Struktur Folder
```bash
lib/
├── main.dart
├── screens/
│   ├── individu_page.dart
│   ├── instansi_page.dart
│   └── manage_page.dart
├── widgets/
│   └── sidebar.dart
```

---

## 🧪 Cara Menjalankan Lokal
### 1. Pastikan Flutter sudah terpasang:
```bash
flutter --version
```
Jika belum, ikuti petunjuk [Flutter install](https://docs.flutter.dev/get-started/install).

### 2. Jalankan Project:
```bash
flutter pub get
flutter run -d windows   # atau -d android / -d chrome
```

---

## 🖥️ Cara Build Installer untuk Windows
### 1. Aktifkan support Windows (sekali saja):
```bash
flutter config --enable-windows-desktop
```
### 2. Build executable:
```bash
flutter build windows
```
### 3. File dapat ditemukan di:
```
build/windows/runner/Release/
```
Gunakan tools seperti [Inno Setup](https://jrsoftware.org/isinfo.php) atau [NSIS](https://nsis.sourceforge.io/) untuk membuat installer `.exe`

---

## 📱 Cara Build APK untuk Android
```bash
flutter build apk --release
```
File `.apk` akan muncul di `build/app/outputs/flutter-apk/app-release.apk` dan dapat dibagikan via USB atau email ke device Android untuk diuji.

---

## 🗂️ Catatan Data
- Data tersimpan di folder aplikasi lokal (`getApplicationDocumentsDirectory()`)
- File backup terenkripsi disimpan sebagai `backup_stamp.enc`
- Password default backup: `pertamina_secure`

> Ganti password sebelum produksi untuk menjaga keamanan data

---

## ✉️ Kontak
Jika ada masukan atau request tambahan, silakan hubungi tim pengembang internal.
# stampede-xlsm
