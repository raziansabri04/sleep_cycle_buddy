import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Menghitung awal minggu ini (Senin) untuk mereset grafik setiap minggu
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        // Query: Ambil data milik user ini yang dibuat mulai hari Senin minggu ini
        stream: FirebaseFirestore.instance
            .collection('sleep_logs')
            .where('userId', isEqualTo: user?.uid)
            .where('date', isGreaterThanOrEqualTo: startOfWeek)
            .snapshots(),
        builder: (context, snapshot) {
          // Handle Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Error: ${snapshot.error}",
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 10)),
              ),
            );
          }

          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Inisialisasi data 7 hari dengan angka 0 (M T W T F S S)
          List<double> weeklyCaffeine = [0, 0, 0, 0, 0, 0, 0];
          double latestCaffeine = 0;

          // Mapping data dari Firestore ke dalam List 7 hari
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            for (var doc in snapshot.data!.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              if (data['date'] != null) {
                DateTime logDate = (data['date'] as Timestamp).toDate();
                // weekday: Senin=1, Selasa=2 ... Minggu=7
                int dayIndex = logDate.weekday - 1;
                if (dayIndex >= 0 && dayIndex < 7) {
                  weeklyCaffeine[dayIndex] = (data['caffeineCount'] ?? 0).toDouble();
                }
              }
            }
            // Mengambil angka kafein hari ini untuk kartu info
            latestCaffeine = weeklyCaffeine[now.weekday - 1];
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _buildHeader(user?.displayName ?? "User"),
                const SizedBox(height: 30),

                Text("Sleep Insights", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // 1. Kartu Dampak Nutrisi
                _buildInsightCard(
                  icon: Icons.fastfood,
                  title: "Nutritional Impact",
                  value: "${latestCaffeine.toInt()} Cups",
                  label: "Caffeine Today",
                  desc: latestCaffeine > 2
                      ? "Konsumsi kafein tinggi hari ini. Kurangi agar tidur lebih nyenyak."
                      : "Pola yang bagus! Konsumsi kafein Anda hari ini sangat ideal.",
                  isWarning: latestCaffeine > 2,
                ),
                const SizedBox(height: 15),

                // 2. Grafik Tren Kafein Mingguan
                _buildTrendCard(weeklyCaffeine),

                const SizedBox(height: 30),

                // 3. Rekomendasi Rutinitas (Lengkap)
                Text("Recommendation Routine", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildRoutineItem("15\nMIN", "Physical Reading", "Gunakan buku fisik untuk mengurangi paparan blue light."),
                _buildRoutineItem("10\nMIN", "Warm Shower", "Membantu menurunkan suhu tubuh inti untuk memicu kantuk."),
                _buildRoutineItem("05\nMIN", "Journaling", "Tulis kekhawatiran hari ini agar pikiran tenang saat tidur."),
                _buildRoutineItem("10\nMIN", "Meditation", "Lakukan meditasi pernapasan untuk merilekskan sistem saraf."),
                _buildRoutineItem("05\nMIN", "Light Stretching", "Peregangan otot ringan untuk melepas ketegangan tubuh."),
                _buildRoutineItem("30\nMIN", "Digital Detox", "Matikan semua gadget sebelum mulai menutup mata."),
                _buildRoutineItem("10\nMIN", "Deep Breathing", "Lakukan teknik 4-7-8 untuk menenangkan detak jantung."),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget untuk Header (Foto & Sapaan)
  Widget _buildHeader(String name) {
    return Row(
      children: [
        const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=riyan')
        ),
        const SizedBox(width: 12),
        Text("Good evening, $name", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Widget untuk Grafik Batang
  Widget _buildTrendCard(List<double> data) {
    final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Weekly Caffeine Trend", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Cups / Day", style: TextStyle(fontSize: 10, color: Colors.grey))
              ]
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))
                          )
                      )
                  ),
                ),
                barGroups: List.generate(7, (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                          toY: data[i],
                          color: data[i] > 2 ? Colors.orange : const Color(0xFFFFB95A),
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(show: true, toY: 0.2, color: Colors.white10)
                      )
                    ]
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Kartu Insight
  Widget _buildInsightCard({required IconData icon, required String title, required String value, required String label, required String desc, required bool isWarning}) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(20)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF252841), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: isWarning ? Colors.orange : const Color(0xFFFFB95A), size: 20)
              ),
              const SizedBox(width: 15),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text(value, style: TextStyle(color: isWarning ? Colors.orange : const Color(0xFFFFB95A), fontWeight: FontWeight.bold)),
                            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey))
                          ])
                        ]
                    ),
                    const SizedBox(height: 5),
                    Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFFC8C5CE)))
                  ]
              ))
            ]
        )
    );
  }

  // Widget untuk Item Rekomendasi
  Widget _buildRoutineItem(String time, String title, String desc) {
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
        child: Row(
            children: [
              Text(time, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFB95A), fontWeight: FontWeight.bold, fontSize: 11)),
              const SizedBox(width: 20),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFFC8C5CE)))
                  ]
              )),
              const Icon(Icons.chevron_right, color: Colors.grey)
            ]
        )
    );
  }
}