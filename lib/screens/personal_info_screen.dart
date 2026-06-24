import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameController;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi input dengan nama dari Firebase saat ini
    _nameController = TextEditingController(text: user?.displayName);
  }

  // Fungsi ambil gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi simpan perubahan nama ke Firebase
  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      await user?.updateDisplayName(_nameController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
        Navigator.pop(context); // Kembali ke profil
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Personal Info", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 1. FOTO PROFIL (Bisa diganti)
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : NetworkImage(user?.photoURL ?? 'https://i.pravatar.cc/150?u=alex'),
                      ),
                      GestureDetector(
                        onTap: _pickImage, // Klik icon pensil untuk ganti gambar
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFFFFB95A), shape: BoxShape.circle),
                          child: const Icon(Icons.edit, size: 20, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Tap to change profile photo", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. INPUT NAMA (Bisa diubah)
            _buildInputField(label: "Full Name", controller: _nameController, icon: Icons.person_outline, isReadOnly: false),

            const SizedBox(height: 20),

            // 3. INPUT EMAIL (Hanya Baca / Read-Only)
            _buildInputField(label: "Email Address", initialValue: user?.email, icon: Icons.mail_outline, isReadOnly: true),

            const SizedBox(height: 50),

            // TOMBOL SAVE
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB95A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Save Changes", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, TextEditingController? controller, String? initialValue, required IconData icon, required bool isReadOnly}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
          child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            readOnly: isReadOnly, // Jika True, email tidak bisa diketik
            style: TextStyle(color: isReadOnly ? Colors.grey : Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(icon, color: Colors.white24, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}