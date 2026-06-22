import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. TAMBAHKAN IMPORT INI
import 'package:sleep_cycle_buddy/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // 2. TAMBAHKAN VARIABLE LOADING
  bool _isLoading = false;

  // 3. TAMBAHKAN FUNGSI SIGN UP INI
  Future<void> _signUp() async {
    // Validasi input kosong
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi")),
      );
      return;
    }

    setState(() => _isLoading = true); // Mulai loading

    try {
      // Perintah mendaftarkan email ke Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update nama user di profil Firebase
      await userCredential.user?.updateDisplayName(_nameController.text);

      if (mounted) {
        // Jika sukses, pindah ke halaman utama (MainNavigation)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Tangkap pesan error dari Firebase
      String message = "Terjadi kesalahan";
      if (e.code == 'weak-password') {
        message = "Password terlalu lemah (minimal 6 karakter).";
      } else if (e.code == 'email-already-in-use') {
        message = "Email ini sudah terdaftar.";
      } else if (e.code == 'invalid-email') {
        message = "Format email tidak valid.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Koneksi gagal")));
    } finally {
      if (mounted) setState(() => _isLoading = false); // Matikan loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SleepCycle Buddy",
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFFB95A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Join the Journey",
              style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Step into a world of restorative rest and discover your natural sleep rhythm.",
              style: TextStyle(color: Color(0xFFC8C5CE), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 40),

            _buildLabel("Name"),
            _buildTextField(controller: _nameController, hint: "Elias Thorne", icon: Icons.person_outline),
            const SizedBox(height: 20),

            _buildLabel("Email Address"),
            _buildTextField(controller: _emailController, hint: "dreamer@sleepcycle.com", icon: Icons.mail_outline),
            const SizedBox(height: 20),

            _buildLabel("Password"),
            _buildTextField(
              controller: _passwordController,
              hint: "••••••••",
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: !_isPasswordVisible,
              onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 4),
              child: Text("Must be at least 8 characters long.", style: TextStyle(color: Colors.grey, fontSize: 10)),
            ),

            const SizedBox(height: 50),

            // 4. UBAH BAGIAN TOMBOL INI
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                // Jika sedang loading, tombol tidak bisa diklik (null)
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB95A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                )
                    : const Text("Create My Account",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already part of the dream? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("Sign in", style: TextStyle(color: Color(0xFFFFB95A), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white54, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white54, size: 20),
            onPressed: onToggleVisibility,
          )
              : null,
        ),
      ),
    );
  }
}