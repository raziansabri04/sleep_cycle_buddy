# 🌙 SleepCycle Buddy

**SleepCycle Buddy** adalah aplikasi asisten kesehatan tidur modern yang membantu pengguna melacak, menganalisis, dan memperbaiki kualitas istirahat mereka. Dibangun dengan **Flutter** dan **Firebase**, aplikasi ini menggabungkan desain *Dark Mode* yang elegan dengan fitur fungsional nyata.

---

## ✨ Fitur Utama

### 📊 Dashboard Cerdas
*   **Grafik Real-time:** Menampilkan tren durasi dan kualitas tidur selama 7 hari terakhir menggunakan `fl_chart`.
*   **Sapaan Dinamis:** Menyapa pengguna secara otomatis sesuai waktu (Pagi/Siang/Malam).
*   **Animasi Lottie:** Visual bulan yang menenangkan untuk meningkatkan pengalaman pengguna.

### 📝 Log Tidur Harian
*   **Input Presisi:** Catat durasi tidur (Jam & Menit) dan kualitas tidur lewat rating emoji.
*   **Pelacak Influencer:** Pantau konsumsi kafein dan kebiasaan layar sebelum tidur.
*   **Sinkronisasi Cloud:** Data tersimpan aman secara otomatis di **Firebase Firestore**.

### 📈 Insight & Rekomendasi
*   **Analisis Kafein:** Grafik batang mingguan yang menunjukkan pola konsumsi kafein harian.
*   **Tips Kesehatan:** Daftar rekomendasi rutinitas sebelum tidur yang dipersonalisasi.

### 🧘 Relaksasi & Alarm
*   **Suara Hujan:** Pemutar audio suara hujan berkualitas tinggi dengan kontrol volume nyata.
*   **Sleep Timer:** Matikan suara relaksasi secara otomatis (15/30/60 menit).
*   **Sistem Alarm:** Penjadwalan alarm yang terintegrasi dengan notifikasi sistem Android.

### 👤 Manajemen Profil
*   **Autentikasi Firebase:** Sistem Login & Register yang aman.
*   **Personal Info:** Ubah nama dan foto profil dengan penyimpanan lokal yang persisten.

---

## 🚀 Teknologi yang Digunakan

*   **Frontend:** [Flutter](https://flutter.dev) (Dart)
*   **Backend:** [Firebase](https://firebase.google.com) (Authentication & Firestore)
*   **State Management:** StatefulWidget & Streams
*   **Library Utama:**
    *   `fl_chart` - Untuk grafik analitik.
    *   `audioplayers` - Untuk pemutar suara relaksasi.
    *   `lottie` - Untuk animasi interaktif.
    *   `flutter_local_notifications` - Untuk sistem alarm.
    *   `shared_preferences` & `path_provider` - Untuk penyimpanan profil lokal.

---

## 📸 Tampilan Aplikasi
*(Saran: Masukkan screenshot aplikasi Anda di sini agar lebih menarik)*

| Home | Log | Insights | Relax |
| :---: | :---: | :---: | :---: |
| ![Home](https://via.placeholder.com/150) | ![Log](https://via.placeholder.com/150) | ![Insights](https://via.placeholder.com/150) | ![Relax](https://via.placeholder.com/150) |

---

## 🛠️ Cara Menjalankan Project

1.  **Clone repositori ini:**
    ```bash
    git clone https://github.com/username-anda/sleep_cycle_buddy.git
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Setup Firebase:**
    *   Buat project baru di [Firebase Console](https://console.firebase.google.com/).
    *   Aktifkan *Authentication* dan *Firestore*.
    *   Jalankan `flutterfire configure` untuk menghubungkan aplikasi.
4.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

---

## 👨‍💻 Kontributor
*   Razian Sabri
*   Riyan Hadi Samudra

---
Developed with ❤️ for better sleep.
