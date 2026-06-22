import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepLogScreen extends StatefulWidget {
  const SleepLogScreen({super.key});

  @override
  State<SleepLogScreen> createState() => _SleepLogScreenState();
}

class _SleepLogScreenState extends State<SleepLogScreen> {
  // State untuk menyimpan pilihan user
  int selectedEmoji = 2; // Default: Good
  int caffeineCount = 2;
  bool isLimitedScreenTime = true;

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

            // 1. Rest Schedule Card
            _buildScheduleCard(),
            const SizedBox(height: 25),

            // 2. Sleep Rating Section
            Text("How did you sleep?", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildEmojiRating(),
            const SizedBox(height: 30),

            // 3. Daily Influencers Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Daily Influencers", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text("Edit Habits", style: TextStyle(color: Color(0xFFC8C5CE), fontSize: 12))),
              ],
            ),
            _buildInfluencerItem(
              icon: Icons.coffee,
              title: "Caffeine",
              subtitle: "Caps today",
              trailing: Row(
                children: [
                  _circleBtn(Icons.remove, () => setState(() => caffeineCount--)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: Text("$caffeineCount")),
                  _circleBtn(Icons.add, () => setState(() => caffeineCount++)),
                ],
              ),
            ),
            _buildInfluencerItem(
              icon: Icons.phonelink_erase,
              title: "Limited Screen Time",
              subtitle: "No screens 1h before bed",
              trailing: Switch(
                value: isLimitedScreenTime,
                activeThumbColor: const Color(0xFFFFB95A),
                onChanged: (val) => setState(() => isLimitedScreenTime = val),
              ),
            ),
            _buildInfluencerItem(
              icon: Icons.directions_run,
              title: "Physical Activity",
              subtitle: "Active minutes",
              trailing: const Row(
                children: [
                  Text("45m", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.edit, size: 16, color: Color(0xFFC8C5CE)),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 4. Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Log Saved!")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB95A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Rest Schedule", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("July 24", style: TextStyle(color: Colors.blue[200], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _timeInfo(Icons.bed, "Bedtime", "22:30 PM"),
              Container(width: 1, height: 40, color: Colors.white10),
              _timeInfo(Icons.wb_sunny, "Wake Time", "06:45 AM"),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeInfo(IconData icon, String title, String time) {
    return Column(
      children: [
        Row(children: [Icon(icon, size: 14, color: Colors.blue[200]), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 12))]),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEmojiRating() {
    List<String> emojis = ["😫", "😐", "🙂", "😊", "🤩"];
    List<String> labels = ["Poor", "Fair", "Good", "Great", "Best"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        bool isSelected = selectedEmoji == index;
        return GestureDetector(
          onTap: () => setState(() => selectedEmoji = index),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF5356FB).withValues(alpha: 0.3) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: const Color(0xFF5356FB)) : null,
                ),
                child: Text(emojis[index], style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 4),
              Text(labels[index], style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.grey)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfluencerItem({required IconData icon, required String title, required String subtitle, required Widget trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFB95A)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFFC8C5CE))),
              ],
            ),
          ),
          trailing
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}