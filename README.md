
# 📚 Sistem Pelaporan Kerusakan Sekolah (MPLJJ25-138-KEL-1)

[🇮🇩 Baca dalam Bahasa Indonesia](#bahasa-indonesia) | [🇬🇧 Read in English](#english)

---

## 🇮🇩 Bahasa Indonesia

### 📝 Deskripsi Singkat

Sistem ini merupakan platform pelaporan dan analisis kerusakan fasilitas sekolah berbasis mobile dan web, terdiri dari tiga komponen utama:

- 📱 **Aplikasi Flutter** untuk pelaporan oleh masyarakat
- 🌐 **Backend Laravel** sebagai API & logika bisnis
- 🧠 **Model AI (Flask + Roboflow)** untuk analisis otomatis tingkat kerusakan dari gambar

Pengguna dapat mengirim laporan kerusakan, melihat status, serta memberikan progres dan rating. Admin bertugas memverifikasi laporan, menganalisis dengan AI, dan memberikan tanggapan atau progres pembangunan.

---

### 🧱 Struktur Proyek

```
📁 backend/       → Laravel API
📁 model_ai/      → Python Flask + Roboflow AI
📁 report_school/ → Flutter mobile app
```

---

### ⚙️ Backend (Laravel)

#### Fitur Utama
- Autentikasi pengguna & admin
- CRUD laporan, progres, sekolah, dan foto
- Rating laporan & analisis AI
- Endpoint lengkap (`routes/web.php`)

#### Setup Singkat
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan serve
```

---

### 🤖 AI Model (Flask + Roboflow)
- Menerima gambar via `POST /predict`
- Memberikan klasifikasi: Rusak Ringan / Sedang / Berat
- Gunakan key dan workflow Roboflow (bisa disesuaikan)

#### Setup Singkat
```bash
cd model_ai
python -m venv venv
source venv/bin/activate
pip install -r requirement.txt
python main.py
```

---

### 📱 Aplikasi Mobile (Flutter)

#### Fitur Utama
- Login & Registrasi
- Tambah laporan dengan gambar
- Lihat status & progres
- Rating laporan & upload progres baru
- Khusus admin: analisis laporan & status

#### Setup Singkat
```bash
cd report_school
flutter pub get
flutter run
```

---

## 🇬🇧 English

### 📝 Overview

This is a mobile and web-based school issue reporting and analysis system consisting of:

- 📱 **Flutter mobile app** for user reporting
- 🌐 **Laravel backend API**
- 🧠 **AI image analysis using Flask + Roboflow**

Users can submit damage reports, track progress, and rate repairs. Admins verify reports, run AI-based analysis, and manage repair updates.

---

### 🧱 Project Structure

```
📁 backend/       → Laravel API
📁 model_ai/      → Python Flask + Roboflow AI
📁 report_school/ → Flutter mobile app
```

---

### ⚙️ Backend (Laravel)

#### Key Features
- Authentication (User/Admin)
- Report, progress, school, and photo management
- AI analysis integration
- Full API coverage via `routes/web.php`

#### Quick Setup
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan serve
```

---

### 🤖 AI Model (Flask + Roboflow)

- Receives image via `POST /predict`
- Returns classifications: Minor / Moderate / Severe Damage
- Uses Roboflow API Key & workflow (editable in `main.py`)

#### Quick Setup
```bash
cd model_ai
python -m venv venv
source venv/bin/activate
pip install -r requirement.txt
python main.py
```

---

### 📱 Mobile App (Flutter)

#### Key Features
- Login & registration
- Submit reports with images
- View progress and status
- Rate reports & upload progress
- Admin features: report analysis & status control

#### Quick Setup
```bash
cd report_school
flutter pub get
flutter run
```

---

## 👨‍💻 Team Members

- **Rosul Iman** – Backend & AI Integration  
- **Olza Raflita** – UI/UX & Laporan  
- **Frans Pigai** – Progress & Dokumentasi

---

> 🎯 Proyek ini dikembangkan untuk memenuhi Tugas Akhir Mobile Programming Lanjut di Universitas Negeri Padang – 2025.
