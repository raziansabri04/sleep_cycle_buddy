import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart'; // Tambahkan ini

class DashboardScreen extends StatelessWidget {
  final VoidCallback onStartSleeping;
  const DashboardScreen({super.key, required this.onStartSleeping});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Menghitung awal minggu (Senin) untuk filter data
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sleep_logs')
            .where('userId', isEqualTo: user?.uid)
            .where('date', isGreaterThanOrEqualTo: startOfWeek) // Ambil data minggu ini saja
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error"));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState();

          final logs = snapshot.data!.docs;
          final lastLog = logs.first.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _buildHeader(user?.displayName ?? "User"),
                const SizedBox(height: 30),

                // GRAFIK DENGAN LABEL HARI (M T W T F S S)
                _buildChartCard(logs),

                const SizedBox(height: 20),
                _buildLastNightCard(lastLog),
                const SizedBox(height: 40),
                _buildStartSleepingSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartCard(List<QueryDocumentSnapshot> logs) {
    // Gunakan Map agar satu hari (0-6) hanya memiliki satu nilai (data terbaru)
    Map<int, double> qualityMap = {};
    Map<int, double> durationMap = {};

    final List<String> dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    for (var doc in logs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['date'] != null) {
        DateTime date = (data['date'] as Timestamp).toDate();
        int dayIndex = date.weekday - 1; // Senin = 0, Minggu = 6

        // Ambil data
        double rating = (data['sleepRating'] ?? 0).toDouble();
        double h = (data['sleepHours'] ?? 0).toDouble();
        double m = (data['sleepMinutes'] ?? 0).toDouble() / 60;

        // LOGIKA: Jika hari ini sudah ada isinya, jangan ditimpa (karena query kita descending, data pertama adalah yang terbaru)
        if (!qualityMap.containsKey(dayIndex)) {
          qualityMap[dayIndex] = rating;
          durationMap[dayIndex] = h + m;
        }
      }
    }

    // Ubah Map kembali menjadi List FlSpot agar bisa digambar grafik
    List<FlSpot> qualitySpots = [];
    List<FlSpot> durationSpots = [];

    qualityMap.forEach((day, val) => qualitySpots.add(FlSpot(day.toDouble(), val)));
    durationMap.forEach((day, val) => durationSpots.add(FlSpot(day.toDouble(), val)));

    // WAJIB: Urutkan dari kiri ke kanan (Senin ke Minggu) agar garis tidak zig-zag
    qualitySpots.sort((a, b) => a.x.compareTo(b.x));
    durationSpots.sort((a, b) => a.x.compareTo(b.x));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weekly Rest", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _chartIndicator(const Color(0xFF9E97FF), "DURATION"),
                  const SizedBox(width: 10),
                  _chartIndicator(const Color(0xFFFFB95A), "QUALITY"),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < 7) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(dayLabels[index], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: durationSpots,
                    isCurved: durationSpots.length > 1,
                    color: const Color(0xFF9E97FF),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: durationSpots.length > 1, color: const Color(0xFF9E97FF).withOpacity(0.1)),
                  ),
                  LineChartBarData(
                    spots: qualitySpots,
                    isCurved: qualitySpots.length > 1,
                    color: const Color(0xFFFFB95A),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastNightCard(Map<String, dynamic> data) {
    List<String> labels = ["Poor quality", "Fair quality", "Good quality", "Great quality", "Best quality"];
    String qualityText = labels[data['sleepRating'] ?? 2];

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Last Night", style: TextStyle(color: Color(0xFFC8C5CE), fontSize: 12)),
          const SizedBox(height: 8),
          Text("${data['sleepHours'] ?? 0}h ${data['sleepMinutes'] ?? 0}m",
              style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFB95A), size: 18),
              const SizedBox(width: 4),
              Text(qualityText, style: const TextStyle(color: Color(0xFFFFB95A), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildSleepChip("Rem: 1h 45m"),
              const SizedBox(width: 10),
              _buildSleepChip("Deep: 2h 10m"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStartSleepingSection() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 150, child: Lottie.asset('assets/lottie/sleep_moon.json')),
          const SizedBox(height: 10),
          Text("Ready for restoration?", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: onStartSleeping,
            icon: const Icon(Icons.play_circle_fill, color: Colors.black),
            label: const Text("Start Sleeping", style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB95A), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String name) => Row(children: [const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=riyan')), const SizedBox(width: 12), Text("Good afternoon, $name", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600))]);
  Widget _chartIndicator(Color color, String label) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey))]);
  Widget _buildSleepChip(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF252841), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)), child: Text(text, style: const TextStyle(color: Color(0xFFC8C5CE), fontSize: 10, fontWeight: FontWeight.w500)));
  Widget _buildEmptyState() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.cloud_off, size: 50, color: Colors.grey), const SizedBox(height: 20), const Text("Belum ada data tidur."), const Text("Silakan isi di tab Log!", style: TextStyle(color: Colors.grey))]));
}