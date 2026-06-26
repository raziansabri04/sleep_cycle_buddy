# 🌙 SleepCycle Buddy

**SleepCycle Buddy** adalah aplikasi asisten kesehatan tidur modern yang dirancang untuk membantu pengguna melacak, menganalisis, dan memperbaiki kualitas istirahat mereka melalui pendekatan data harian.

---

## 📖 Deskripsi Singkat
SleepCycle Buddy mengintegrasikan pelacakan durasi tidur harian, analisis konsumsi kafein, dan fitur relaksasi dalam satu platform. Dengan tampilan *Dark Mode* yang menenangkan, aplikasi ini memudahkan pengguna mencatat pola hidup mereka dan mendapatkan wawasan (insight) tentang bagaimana kebiasaan harian memengaruhi kualitas tidur.

---

## 🎯 Tujuan Pengembangan
Aplikasi ini dikembangkan untuk:
1.  Memberikan kesadaran kepada pengguna mengenai durasi dan kualitas tidur nyata mereka.
2.  Membantu pengguna mengidentifikasi hubungan antara konsumsi kafein dengan kesehatan tidur.
3.  Menyediakan alat bantu relaksasi sebelum tidur melalui audio dan sistem alarm yang terintegrasi.
4.  Menerapkan ekosistem *Full-Stack* (Mobile & Cloud) menggunakan teknologi terbaru.

---

## ✨ Daftar Fitur
*   **Dashboard Interaktif:** Grafik 2-garis (Durasi & Kualitas) untuk melihat tren tidur mingguan secara *real-time*.
*   **Daily Sleep Log:** Input durasi tidur (jam/menit) dan rating kualitas menggunakan sistem emoji.
*   **Caffeine Tracker:** Pencatatan jumlah gelas kafein harian untuk analisis dampak nutrisi.
*   **Smart Sleep Insights:** Grafik batang mingguan konsumsi kafein dan daftar rutinitas tidur sehat.
*   **Relaxation Sound:** Pemutar suara hujan dengan fitur *Sleep Timer* (15/30/60 menit).
*   **Gentle Alarm:** Penjadwalan alarm dengan notifikasi sistem dan getaran yang dapat disesuaikan.
*   **Profile & Personal Info:** Manajemen akun pengguna (Firebase Auth) dan perubahan foto profil secara lokal.

---

## 🛠️ Teknologi dan Library
*   **Framework Utama:** [Flutter](https://flutter.dev) (Dart)
*   **Backend & Database:** [Firebase](https://firebase.google.com) (Authentication & Cloud Firestore)
*   **Library & Komponen Utama:**
    *   `fl_chart`: Visualisasi data grafik garis dan batang.
    *   `audioplayers`: Pemrosesan audio suara hujan.
    *   `flutter_local_notifications`: Sistem notifikasi dan pemicu alarm.
    *   `lottie`: Animasi halus pada Dashboard.
    *   `image_picker`: Pengambilan foto profil dari galeri.
    *   `shared_preferences`: Penyimpanan preferensi lokal dan alamat foto profil.
    *   `intl`: Pemformatan tanggal dan nama hari secara otomatis.

---

## 🗄️ Struktur Database (Cloud Firestore)
Aplikasi menggunakan database NoSQL dengan koleksi utama sebagai berikut:

### 1. Koleksi `users`
Menyimpan pengaturan spesifik setiap pengguna.
*   `userId` (String): ID Unik pengguna.
*   `alarmTime` (String): Waktu alarm tersimpan (Format: HH:mm).
*   `selectedSound` (String): Nama nada alarm yang dipilih.

### 2. Koleksi `sleep_logs`
Menyimpan riwayat harian pengguna.
*   `userId` (String): Referensi ke pengguna.
*   `date` (Timestamp): Tanggal pencatatan.
*   `sleepHours` (Int): Jumlah jam tidur.
*   `sleepMinutes` (Int): Jumlah menit tidur.
*   `sleepRating` (Int): Indeks kualitas tidur (0-4).
*   `caffeineCount` (Int): Jumlah gelas kafein harian.
*   `isLimitedScreenTime` (Bool): Status pembatasan layar sebelum tidur.

---

## 🛠️ Panduan Instalasi dan Menjalankan Aplikasi

1.  **Persyaratan:** Pastikan Flutter SDK dan Android Studio sudah terinstall.
2.  **Clone Project:**
    ```bash
    git clone https://github.com/username-anda/sleep_cycle_buddy.git
    ```
3.  **Install Library:**
    ```bash
    flutter pub get
    ```
4.  **Setup Firebase:**
    *   Daftarkan aplikasi ke [Firebase Console](https://console.firebase.google.com/).
    *   Masukkan file `google-services.json` ke folder `android/app/`.
5.  **Jalankan Aplikasi:**
    *   Hubungkan HP (aktifkan USB Debugging).
    *   Klik **Run** di Android Studio atau ketik `flutter run` di terminal.

---

## 📸 Screenshot Tampilan
*(Klik untuk memperbesar)*

| Dashboard | Sleep Log | Insights | Relax |
| :---: | :---: | :---: | :---: |
| ![Home](https://via.placeholder.com/150) | ![Log](https://via.placeholder.com/150) | ![Insights](https://via.placeholder.com/150) | ![Relax](https://via.placeholder.com/150) |

---
Developed by 
Razian Sabri       = 2308107010050
Riyan Hadi Samudra = 2308107010068
