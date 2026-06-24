import 'dart:io'; // 1. TAMBAH IMPORT INI
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_cycle_buddy/screens/personal_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_cycle_buddy/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 2. TAMBAH IMPORT INI

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationEnabled = true;
  File? _imageFile; // 3. VARIABLE UNTUK FOTO LOKAL

  @override
  void initState() {
    super.initState();
    _loadLocalImage(); // 4. AMBIL FOTO SAAT START
  }

  // 5. FUNGSI UNTUK MENGAMBIL FOTO DARI MEMORI HP
  Future<void> _loadLocalImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('user_profile_path');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(), // Hilangkan tombol back karena ini tab utama
        title: Text("Profile", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[900],
                    // 6. TAMPILKAN FOTO LOKAL JIKA ADA
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : const NetworkImage('https://i.pravatar.cc/150?u=riyan'),
                  ),
                  const SizedBox(height: 15),
                  Text(user?.displayName ?? "No Name", style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(user?.email ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            _buildSectionTitle("ACCOUNT SETTINGS"),
            GestureDetector(
              onTap: () {
                // 7. TRIK AGAR AUTO-REFRESH SAAT BALIK DARI EDIT
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                ).then((value) {
                  // Jalankan fungsi load lagi setelah user kembali
                  _loadLocalImage();
                  setState(() {}); // Refresh nama juga
                });
              },
              child: _buildSettingsItem(Icons.person_outline, "Personal Information"),
            ),

            const SizedBox(height: 25),

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

            // Log Out Button
            TextButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.5)),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {String? subtitle, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
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