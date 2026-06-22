import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_cycle_buddy/screens/personal_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_cycle_buddy/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: Text("Profile", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Header Profil
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFFFFB95A), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text("Alex Reston", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Dreamer since Oct 2023", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. Account Settings Section
            _buildSectionTitle("ACCOUNT SETTINGS"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                );
              },
              child: _buildSettingsItem(Icons.person_outline, "Personal Information"),
            ),

            const SizedBox(height: 25),

            // 3. Preferences Section
            _buildSectionTitle("PREFERENCES"),
            _buildSettingsItem(
              Icons.notifications_none,
              "Notification Settings",
              trailing: Switch(
                value: isNotificationEnabled,
                activeColor: const Color(0xFFFFB95A),
                onChanged: (val) => setState(() => isNotificationEnabled = val),
              ),
            ),
            _buildSettingsItem(
              Icons.color_lens_outlined,
              "Theme",
              subtitle: "Midnight Comfort",
            ),

            const SizedBox(height: 40),

            // 4. Log Out Button
            TextButton.icon(
              onPressed: () async {
                // 1. Jalankan fungsi Sign Out dari Firebase
                await FirebaseAuth.instance.signOut();

                // 2. Jika proses berhasil, pindah ke halaman Login
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false, // Hapus semua riwayat halaman agar tidak bisa 'back'
                  );
                }
              },
              icon: const Icon(Icons.logout, color: Colors.white70),
              label: const Text("Log Out", style: TextStyle(color: Colors.white70)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white10),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.5)),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {String? subtitle, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFB95A), size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                if (subtitle != null)
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          trailing ?? const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}