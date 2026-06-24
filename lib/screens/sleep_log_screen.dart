import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepLogScreen extends StatefulWidget {
  const SleepLogScreen({super.key});

  @override
  State<SleepLogScreen> createState() => _SleepLogScreenState();
}

class _SleepLogScreenState extends State<SleepLogScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // --- STATE DATA ---
  int selectedEmoji = 2; // Default: Good
  int caffeineCount = 2;
  bool isLimitedScreenTime = true;
  int sleepHours = 7;
  int sleepMinutes = 20;
  int remMinutes = 45;
  int deepMinutes = 120;

  // Variabel untuk Jadwal Istirahat (Bisa Diubah)
  TimeOfDay bedtime = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay wakeUpTime = const TimeOfDay(hour: 6, minute: 45);

  bool _isSaving = false;

  // --- FUNGSI PICKER JAM ---
  Future<void> _selectBedtime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: bedtime);
    if (picked != null) setState(() => bedtime = picked);
  }

  Future<void> _selectWakeTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: wakeUpTime);
    if (picked != null) setState(() => wakeUpTime = picked);
  }

  // --- FUNGSI SIMPAN ---
  Future<void> _saveLog() async {
    if (user == null) return;
    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('sleep_logs').add({
        'userId': user!.uid,
        'date': DateTime.now(),
        'sleepRating': selectedEmoji,
        'caffeineCount': caffeineCount,
        'isLimitedScreenTime': isLimitedScreenTime,
        'sleepHours': sleepHours,
        'sleepMinutes': sleepMinutes,
        'remMinutes': remMinutes,
        'deepMinutes': deepMinutes,
        // Simpan juga jadwal istirahatnya
        'targetBedtime': "${bedtime.hour}:${bedtime.minute}",
        'targetWakeTime': "${wakeUpTime.hour}:${wakeUpTime.minute}",
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data tidur berhasil disimpan!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

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
            // 1. Rest Schedule Card (INTERAKTIF & TANPA TANGGAL)
            _buildScheduleCard(),
            const SizedBox(height: 25),

            // 2. Input Durasi
            _sectionTitle("Sleep Duration Today"),
            _buildDurationInput(),
            const SizedBox(height: 30),

            // 3. Rating Emoji (Satu Judul Saja)
            _sectionTitle("How did you sleep?"),
            _buildEmojiRating(),
            const SizedBox(height: 30),

            // 4. Daily Influencers
            _sectionTitle("Daily Influencers"),
            _buildInfluencerItem(
              icon: Icons.coffee,
              title: "Caffeine",
              trailing: Row(children: [
                _circleBtn(Icons.remove, () => setState(() => caffeineCount > 0 ? caffeineCount-- : 0)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("$caffeineCount")),
                _circleBtn(Icons.add, () => setState(() => caffeineCount++)),
              ]),
            ),

            const SizedBox(height: 40),

            // Tombol Save
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveLog,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB95A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Save", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Rest Schedule", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Bedtime Klikable
              GestureDetector(
                onTap: _selectBedtime,
                child: _timeInfo(Icons.bed, "Bedtime", bedtime.format(context)),
              ),
              Container(width: 1, height: 40, color: Colors.white10),
              // WakeTime Klikable
              GestureDetector(
                onTap: _selectWakeTime,
                child: _timeInfo(Icons.wb_sunny, "Wake Time", wakeUpTime.format(context)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Tap time to change your target", style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _timeInfo(IconData icon, String title, String time) {
    return Column(
      children: [
        Row(children: [Icon(icon, size: 14, color: Colors.blue[200]), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 12))]),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFB95A))),
      ],
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _buildDurationInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _timeCounter("HOURS", sleepHours, (v) => setState(() => sleepHours = v)),
          _timeCounter("MINUTES", sleepMinutes, (v) => setState(() => sleepMinutes = v)),
        ],
      ),
    );
  }

  Widget _timeCounter(String label, int val, Function(int) onUpdate) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    Row(children: [
      _circleBtn(Icons.remove, () => onUpdate(val > 0 ? val - 1 : 0)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: Text("$val", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      _circleBtn(Icons.add, () => onUpdate(val + 1)),
    ])
  ]);

  Widget _buildEmojiRating() {
    List<String> emojis = ["😫", "😐", "🙂", "😊", "🤩"];
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(5, (i) => GestureDetector(
      onTap: () => setState(() => selectedEmoji = i),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selectedEmoji == i ? const Color(0xFF5356FB).withValues(alpha: 0.3) : Colors.transparent,
          shape: BoxShape.circle,
          border: selectedEmoji == i ? Border.all(color: const Color(0xFF5356FB)) : null,
        ),
        child: Text(emojis[i], style: const TextStyle(fontSize: 24)),
      ),
    )));
  }

  Widget _buildInfluencerItem({required IconData icon, required String title, required Widget trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [Icon(icon, color: const Color(0xFFFFB95A)), const SizedBox(width: 15), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))), trailing]),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24)), child: Icon(icon, size: 16, color: Colors.white)));
}