# 🌙 SleepCycle Buddy

**SleepCycle Buddy** adalah aplikasi asisten kesehatan tidur modern yang dirancang untuk membantu pengguna melacak, menganalisis, dan memperbaiki kualitas istirahat mereka melalui pendekatan data harian dan fitur relaksasi.

---

## 📖 Deskripsi Singkat
SleepCycle Buddy adalah solusi *all-in-one* untuk manajemen tidur. Aplikasi ini mengintegrasikan pelacakan durasi tidur harian, analisis konsumsi kafein, fitur relaksasi suara hujan, hingga sistem alarm pintar dalam satu platform berbasis *Cloud*. Dengan tampilan *Dark Mode* yang menenangkan, aplikasi ini dirancang untuk meminimalkan ketegangan mata sebelum tidur.

---

## 🎯 Tujuan Pengembangan
Aplikasi ini dikembangkan untuk:
1.  Meningkatkan kesadaran pengguna mengenai durasi dan kualitas tidur nyata melalui visualisasi grafik.
2.  Membantu pengguna mengidentifikasi hubungan antara gaya hidup (seperti konsumsi kafein) dengan kualitas istirahat.
3.  Menyediakan alat bantu relaksasi audio dan sistem alarm yang terintegrasi untuk memperbaiki rutinitas tidur.
4.  Menerapkan ekosistem aplikasi *Full-Stack* menggunakan **Flutter** dan **Firebase**.

---

## ✨ Daftar Fitur

### 🔐 Autentikasi Pengguna
*   **Login & Register:** Sistem masuk dan daftar akun yang aman terintegrasi dengan **Firebase Authentication**.

### 📊 Monitoring & Analisis
*   **Dashboard Cerdas:** Grafik 2-garis (Durasi & Kualitas) yang menampilkan tren tidur 7 hari terakhir secara *real-time*.
*   **Smart Sleep Insights:** Grafik batang konsumsi kafein mingguan yang otomatis tereset setiap Senin pagi.
*   **Rekomendasi Rutinitas:** Daftar tips kesehatan tidur yang dipersonalisasi berdasarkan input pengguna.

### 📝 Pencatatan Data (Logging)
*   **Daily Sleep Log:** Input presisi durasi tidur (Jam & Menit), fase REM/Deep Sleep, serta rating kualitas melalui emoji.
*   **Habit Tracker:** Melacak konsumsi kafein harian dan kedisiplinan membatasi waktu layar (*screen time*).

### 🧘 Relaksasi & Alarm
*   **Relaxation Sound:** Pemutar audio suara hujan berkualitas tinggi dengan kontrol volume dan *Sleep Timer* otomatis.
*   **Gentle Wake Alarm:** Sistem penjadwalan alarm yang terintegrasi dengan notifikasi sistem dan getaran kustom.

### 👤 Manajemen Akun
*   **Profile & Personal Info:** Mengelola data profil, mengubah nama akun, dan mengganti foto profil dengan sistem penyimpanan lokal yang persisten.

---

## 🛠️ Teknologi dan Library
*   **Framework Utama:** [Flutter](https://flutter.dev) (Dart)
*   **Backend & Database:** [Firebase](https://firebase.google.com) (Auth, Firestore)
*   **Library Utama:**
    *   `fl_chart`: Visualisasi analitik data tidur dan kafein.
    *   `audioplayers`: Pemrosesan audio untuk fitur relaksasi.
    *   `lottie`: Animasi interaktif pada Dashboard.
    *   `flutter_local_notifications`: Mesin notifikasi dan pemicu alarm.
    *   `shared_preferences` & `path_provider`: Penyimpanan data profil lokal.
    *   `intl`: Manajemen waktu dan format tanggal dinamis.

---

## 🗄️ Struktur Database (Cloud Firestore)

### 1. Koleksi `sleep_logs`
| Field | Tipe Data | Deskripsi |
| :--- | :--- | :--- |
| `userId` | String | ID Unik pengguna dari Firebase Auth |
| `date` | Timestamp | Waktu data disimpan |
| `sleepHours` | Integer | Jumlah jam tidur |
| `sleepMinutes` | Integer | Jumlah menit tidur |
| `sleepRating` | Integer | Skala kualitas tidur (0-4) |
| `caffeineCount` | Integer | Jumlah gelas kafein harian |
| `remMinutes` | Integer | Estimasi durasi fase REM |
| `deepMinutes` | Integer | Estimasi durasi fase Deep Sleep |

### 2. Koleksi `users`
| Field | Tipe Data | Deskripsi |
| :--- | :--- | :--- |
| `alarmTime` | String | Waktu alarm (Format HH:mm) |
| `selectedSound` | String | Label nada alarm yang dipilih |

---

## 🛠️ Panduan Instalasi dan Menjalankan Aplikasi

1.  **Clone Project:**
    ```bash
    git clone https://github.com/username-anda/sleep_cycle_buddy.git
    ```
2.  **Install Library:**
    ```bash
    flutter pub get
    ```
3.  **Setup Firebase:**
    *   Masukkan file `google-services.json` milik Anda ke folder `android/app/`.
4.  **Jalankan Aplikasi:**
    *   Ketik `flutter run` pada terminal atau tekan **F5** di VS Code / Android Studio.

---

## 📸 Screenshot Tampilan Aplikasi

| Login Page | Register Page | Home Dashboard | Sleep Log |
| :---: | :---: | :---: | :---: |
| ![Login](screenshots/login.png) | ![Register](screenshots/register.png) | ![Home](screenshots/home.png) | ![Log](screenshots/log.png) |

| Sleep Insights | Relax & Sound | Profile | Personal Info |
| :---: | :---: | :---: | :---: |
| ![Insights](screenshots/insight.png) | ![Relax](screenshots/relax.png) | ![Profile](screenshots/profile.png) | ![PersonalInfo](screenshots/personal_info.png) |

---
Developed by
Razian Sabri (2308107010050)      
Riyan Hadi Samudra (2308107010068)
