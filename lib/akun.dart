import 'package:flutter/material.dart';
import 'package:myapp/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AkunScreen extends StatefulWidget {
  const AkunScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AkunScreenState createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  Future<void> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        namaController.text = data['username'] ?? '';
        emailController.text = data['email'] ?? '';
        passwordController.text = data['password'] ?? '';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingScreen()));
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Color.fromARGB(255, 68, 63, 144),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Akun',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 68, 63, 144),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField('Nama', namaController, false),
                _buildTextField('Email', emailController, false),
                _buildTextField('Password', passwordController, true),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _updateUserData(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 68, 63, 144),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      textStyle:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: isPassword && !isPasswordVisible,
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _updateUserData(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': namaController.text,
        'email': emailController.text,
        'password': passwordController.text, // Enkripsi password di database
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const SettingScreen()),
          (Route<dynamic> route) => false,
        );
      });
    }
  }
}
