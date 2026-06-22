import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Untuk grafik
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Agar halaman bisa di-scroll
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // 1. Header: Foto Profil & Greeting
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'), // Foto dummy
                ),
                const SizedBox(width: 12),
                Text(
                  "Good afternoon, Alex",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Card Grafik (Weekly Rest)
            _buildChartCard(),

            const SizedBox(height: 20),

            // 3. Card Ringkasan Tidur (Last Night)
            _buildLastNightCard(),

            const SizedBox(height: 40),

            // 4. Bagian Bawah: Ready for restoration?
            Center(
              child: Column(
                children: [
                  Text(
                    "Ready for restoration?",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Prepare your environment for a deeper,\nmore restorative rest cycle tonight.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFC8C5CE), height: 1.5),
                  ),
                  const SizedBox(height: 30),

                  // Tombol Start Sleeping
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_circle_fill, color: Colors.black),
                      label: const Text("Start Sleeping",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB95A), // Warna Aksen
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Card Grafik
  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sleep History", style: TextStyle(color: Color(0xFFC8C5CE), fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weekly Rest", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)),
              const Row(
                children: [
                  _Indicator(color: Color(0xFF9E97FF), text: "DURATION"),
                  SizedBox(width: 10),
                  _Indicator(color: Color(0xFFFFB95A), text: "QUALITY"),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          // Area Grafik
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Garis Ungu (Duration)
                  LineChartBarData(
                    spots: const [FlSpot(0, 3), FlSpot(1, 2), FlSpot(2, 5), FlSpot(3, 3), FlSpot(4, 4), FlSpot(5, 3), FlSpot(6, 4)],
                    isCurved: true,
                    color: const Color(0xFF9E97FF),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  // Garis Kuning (Quality)
                  LineChartBarData(
                    spots: const [FlSpot(0, 1), FlSpot(1, 4), FlSpot(2, 3), FlSpot(3, 2), FlSpot(4, 5), FlSpot(5, 1), FlSpot(6, 3)],
                    isCurved: true,
                    color: const Color(0xFFFFB95A),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("M"), Text("T"), Text("W"), Text("T"), Text("F"), Text("S"), Text("S")],
          )
        ],
      ),
    );
  }

  // Widget untuk Card Ringkasan
  Widget _buildLastNightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0xFF1A1C2E),
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: AssetImage('assets/moon_bg.png'), // Opsional: Tambahkan aset gambar bulan nanti
            alignment: Alignment.topRight,
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Last Night", style: TextStyle(color: Color(0xFFC8C5CE))),
          const SizedBox(height: 8),
          Text("7h 20m", style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.bold)),
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFFFB95A), size: 18),
              SizedBox(width: 4),
              Text("Good quality", style: TextStyle(color: Color(0xFFFFB95A))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildChip("Rem: 1h 45m"),
              const SizedBox(width: 10),
              _buildChip("Deep: 2h 10m"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF252841),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFC8C5CE))),
    );
  }
}

// Komponen Kecil untuk Legenda Grafik
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  const _Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 8, color: Color(0xFFC8C5CE))),
      ],
    );
  }
}