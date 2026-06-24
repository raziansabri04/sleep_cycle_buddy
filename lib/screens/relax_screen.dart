import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. Tambah import
import 'package:firebase_auth/firebase_auth.dart';    // 2. Tambah import

class RelaxScreen extends StatefulWidget {
  const RelaxScreen({super.key});

  @override
  State<RelaxScreen> createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // 3. Tambahkan variable waktu default (07:30)
  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 30);

  bool isPlayingRain = false;
  double rainVolume = 0.6;
  bool isPlayingOcean = false;

  @override
  void initState() {
    super.initState();
    _loadAlarmFromFirebase(); // Ambil jam yang tersimpan saat halaman dibuka
  }

  // 4. FUNGSI UNTUK MEMUNCULKAN PILIHAN JAM (Time Picker)
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      _saveAlarmToFirebase(picked); // Langsung simpan ke cloud
    }
  }

  // 5. FUNGSI SIMPAN JAM KE FIREBASE
  Future<void> _saveAlarmToFirebase(TimeOfDay time) async {
    try {
      String timeStr = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'alarmTime': timeStr,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alarm updated!")),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // 6. FUNGSI AMBIL JAM DARI FIREBASE
  Future<void> _loadAlarmFromFirebase() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    if (doc.exists && doc.data()?['alarmTime'] != null) {
      String timeStr = doc.data()?['alarmTime'];
      List<String> parts = timeStr.split(':');
      setState(() {
        selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format jam agar selalu 2 digit (misal 07:30)
    String formattedTime = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // Header (Nama sesuai akun)
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex')),
                const SizedBox(width: 12),
                Text("Good evening, ${user?.displayName ?? 'User'}", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 30),

            Text("Gentle Wake Alarm", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // 7. BUNGKUS DENGAN GESTURE DETECTOR AGAR BISA DIKLIK
            GestureDetector(
              onTap: _pickTime,
              child: _buildAlarmCard(formattedTime),
            ),

            const SizedBox(height: 30),
            Text("Relaxation Sounds", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildSoundCard(
              title: "Rain",
              subtitle: "Soft pitter on a window",
              icon: Icons.umbrella,
              isPlaying: isPlayingRain,
              volume: rainVolume,
              onPlayTap: () => setState(() => isPlayingRain = !isPlayingRain),
              onVolumeChanged: (val) => setState(() => rainVolume = val),
            ),
            const SizedBox(height: 15),
            _buildSoundCard(
              title: "Ocean",
              subtitle: "Distant rolling tides",
              icon: Icons.waves,
              isPlaying: isPlayingOcean,
              volume: 0.3,
              onPlayTap: () => setState(() => isPlayingOcean = !isPlayingOcean),
              onVolumeChanged: (val) {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 8. UPDATE FUNGSI _buildAlarmCard UNTUK MENERIMA DATA WAKTU
  Widget _buildAlarmCard(String time) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Icon(Icons.alarm, color: Color(0xFFFFB95A), size: 20)],
          ),
          Text(time,
              style: GoogleFonts.plusJakartaSans(fontSize: 56, fontWeight: FontWeight.bold, letterSpacing: 2)
          ),
          const Text("Tap to set alarm time", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 20),
          _buildSoundSelector(),
        ],
      ),
    );
  }

  Widget _buildSoundSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF252841),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.music_note, size: 16, color: Color(0xFFFFB95A)),
          SizedBox(width: 8),
          Text("Birds & Morning Dew", style: TextStyle(fontSize: 12)),
          SizedBox(width: 8),
          Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSoundCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isPlaying,
    required double volume,
    required VoidCallback onPlayTap,
    required ValueChanged<double> onVolumeChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF252841), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: const Color(0xFFFFB95A)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              IconButton(
                onPressed: onPlayTap,
                icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                color: const Color(0xFFFFB95A),
                iconSize: 40,
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("VOLUME", style: TextStyle(fontSize: 8, color: Colors.grey, letterSpacing: 1)),
              Expanded(
                child: Slider(
                  value: volume,
                  activeColor: const Color(0xFFFFB95A),
                  inactiveColor: Colors.white10,
                  onChanged: onVolumeChanged,
                ),
              ),
              Text("${(volume * 100).toInt()}%", style: const TextStyle(fontSize: 8, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}