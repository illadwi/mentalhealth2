
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'login.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  Future<void> signup(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'createdAt': DateTime.now(),
      });

      // Show success popup
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Selamat"),
          content: const Text("Anda berhasil mendaftar!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show error if signup fails
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saat signup: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> passToggle = ValueNotifier<bool>(true);
    final ValueNotifier<bool> confirmPassToggle = ValueNotifier<bool>(true);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "Selamat Datang",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 63, 144),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  wordSpacing: 2,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Daftar",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 63, 144),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  wordSpacing: 2,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  "images/mental.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ValueListenableBuilder(
                  valueListenable: passToggle,
                  builder: (context, value, child) {
                    return TextField(
                      controller: passwordController,
                      obscureText: value,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text("Password"),
                        suffixIcon: InkWell(
                          onTap: () {
                            passToggle.value = !passToggle.value;
                          },
                          child: Icon(
                            value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ValueListenableBuilder(
                  valueListenable: confirmPassToggle,
                  builder: (context, value, child) {
                    return TextField(
                      controller: confirmPasswordController,
                      obscureText: value,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text("Konfirmasi Password"),
                        suffixIcon: InkWell(
                          onTap: () {
                            confirmPassToggle.value = !confirmPassToggle.value;
                          },
                          child: Icon(
                            value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: const Color.fromARGB(255, 68, 63, 144),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Semua field harus diisi")),
                          );
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email tidak valid")),
                          );
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Password dan konfirmasi password tidak cocok")),
                          );
                        } else {
                          signup(context, emailController.text,
                              passwordController.text);
                        }
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        child: Center(
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah mempunyai akun?",
                    style: TextStyle(
                      color: Color.fromARGB(79, 68, 63, 144),
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        color: Color.fromARGB(255, 68, 63, 144),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
