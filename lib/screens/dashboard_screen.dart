import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';    // Import Auth

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        // Mengambil 7 data terbaru milik user ini
        stream: FirebaseFirestore.instance
            .collection('sleep_logs')
            .where('userId', isEqualTo: user?.uid)
            .orderBy('date', descending: true)
            .limit(7)
            .snapshots(),
        builder: (context, snapshot) {
          // A. CEK JIKA TERJADI ERROR (Tambahkan ini)
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 10)),
            );
          }

          // B. Tampilan saat loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // C. Tampilan jika belum ada data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final logs = snapshot.data!.docs;
          // Ambil data terbaru untuk card "Last Night"
          final lastLog = logs.first.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _buildHeader(user?.displayName ?? "User"),
                const SizedBox(height: 30),

                // 3. Grafik dengan data nyata (mengambil list logs)
                _buildChartCard(logs.reversed.toList()),

                const SizedBox(height: 20),

                // 4. Card Last Night dengan data nyata
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

  // --- WIDGET HELPER ---

  Widget _buildHeader(String name) {
    return Row(
      children: [
        const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex')),
        const SizedBox(width: 12),
        Text("Good afternoon, $name", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildChartCard(List<QueryDocumentSnapshot> logs) {
    // Mapping data Firestore ke titik grafik (Spots)
    List<FlSpot> qualitySpots = [];
    for (int i = 0; i < logs.length; i++) {
      double rating = (logs[i].data() as Map<String, dynamic>)['sleepRating'].toDouble();
      qualitySpots.add(FlSpot(i.toDouble(), rating));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Weekly Rest", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: qualitySpots, // Data nyata dari Firestore
                    isCurved: true,
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
    // Konversi rating angka ke teks
    List<String> labels = ["Poor", "Fair", "Good", "Great", "Best"];
    String qualityText = labels[data['sleepRating'] ?? 2];

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Last Night (Real Data)", style: TextStyle(color: Color(0xFFC8C5CE))),
          const SizedBox(height: 8),
          // Karena kita belum buat input jam, kita pakai angka statis dulu atau ambil dari data
          Text("Input: ${data['caffeineCount']} Cups", style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFB95A), size: 18),
              const SizedBox(width: 4),
              Text(qualityText, style: const TextStyle(color: Color(0xFFFFB95A))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 50, color: Colors.grey),
          const SizedBox(height: 20),
          const Text("Belum ada data tidur."),
          const Text("Silakan isi di tab Log!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStartSleepingSection() {
    return Center(
      child: Column(
        children: [
          Text("Ready for restoration?", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_circle_fill, color: Colors.black),
            label: const Text("Start Sleeping", style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB95A),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}