import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Kembali ke halaman Profile
        ),
        title: Text("Personal Info",
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 1. Bagian Foto Profil (Besar)
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFB95A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: Colors.black),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Tap to change profile photo",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. Form Input Nama
            _buildInputField(
              label: "Full Name",
              initialValue: "Alex Reston",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            // 3. Form Input Email
            _buildInputField(
              label: "Email Address",
              initialValue: "alex.reston@email.com",
              icon: Icons.mail_outline,
            ),

            const SizedBox(height: 50),

            // Tombol Simpan Perubahan (Tambahan agar fungsional)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB95A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Save Changes",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required String initialValue, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1C2E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(icon, color: Colors.grey, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}