import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // Header
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex')),
                const SizedBox(width: 12),
                Text("Good evening, Alex", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 30),

            Text("Sleep Insights", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // 1. Nutritional Impact Card
            _buildInsightCard(
              icon: Icons.fastfood,
              title: "Nutritional Impact",
              value: "-15%",
              label: "Quality",
              desc: "Caffeine after 4 PM reduces deep sleep cycles.",
            ),
            const SizedBox(height: 15),

            // 2. Environmental Temp Card
            _buildInsightCard(
              icon: Icons.thermostat,
              title: "Environmental Temp",
              value: "22° C",
              label: "Room Temp",
              desc: "Optimal range reached for consistent REM sleep.",
            ),
            const SizedBox(height: 15),

            // 3. Efficiency Trend (Grafik Batang)
            _buildTrendCard(),

            const SizedBox(height: 30),

            // 4. Recommendation Routine Section
            Text("Recommendation Routine", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildRoutineItem("15\nMIN", "Physical Reading", "Reduce dopamine, avoid blue light."),
            _buildRoutineItem("10\nMIN", "Warm Shower", "Signals your body it's time for rest."),
            _buildRoutineItem("20\nMIN", "Breathwork", "Guided 4-7-8 deep relaxation."),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({required IconData icon, required String title, required String value, required String label, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF252841), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFFFFB95A), size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(value, style: const TextStyle(color: Color(0xFFFFB95A), fontWeight: FontWeight.bold)),
                        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFFC8C5CE))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrendCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Efficiency Trend", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Deep sleep peak: 3:15 AM", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                barGroups: List.generate(7, (i) => BarChartGroupData(
                  x: i,
                  barRods: [BarChartRodData(toY: (i + 3).toDouble(), color: i == 4 ? const Color(0xFFFFB95A) : const Color(0xFF252841), width: 15, borderRadius: BorderRadius.circular(4))],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineItem(String time, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Text(time, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFB95A), fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFFC8C5CE))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}