import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelaxScreen extends StatefulWidget {
  const RelaxScreen({super.key});

  @override
  State<RelaxScreen> createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> {
  // State untuk kontrol suara dummy
  bool isPlayingRain = false;
  double rainVolume = 0.6;
  bool isPlayingOcean = false;

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

            // 1. Gentle Wake Alarm Card
            Text("Gentle Wake Alarm", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildAlarmCard(),

            const SizedBox(height: 30),

            // 2. Relaxation Sounds Section
            Text("Relaxation Sounds", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Sound 1: Rain
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

            // Sound 2: Ocean
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

  Widget _buildAlarmCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [Icon(Icons.alarm, color: Color(0xFFFFB95A), size: 20)],
          ),
          Text("07:30",
              style: GoogleFonts.plusJakartaSans(fontSize: 56, fontWeight: FontWeight.bold, letterSpacing: 2)
          ),
          const Text("Tomorrow Morning", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF252841),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.music_note, size: 16, color: Color(0xFFFFB95A)),
                SizedBox(width: 8),
                Text("Birds & Morning Dew", style: TextStyle(fontSize: 12)),
                SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
          )
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