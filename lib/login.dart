import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/home.dart';
import 'lupasandi.dart';
import 'signup.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginScreen({super.key});

  Future<void> loginUser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon masukkan email dan password")),
      );
      return;
    }

    try {
      // Attempt to sign in the user with Firebase
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Show success message and navigate to HomeScreen
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil Masuk")),
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided for that user.";
      } else {
        message = e.message ?? 'Login failed';
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      // Handle any other errors
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> passToggle = ValueNotifier<bool>(true);
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
                "Masuk",
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
                            value ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LupaSandiScreen()),
                        );
                      },
                      child: const Text(
                        "Lupa Kata Sandi?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 63, 144),
                        ),
                      ),
                    ),
                  ],
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
                      onTap: () => loginUser(context),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        child: Center(
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum mempunyai akun?",
                    style: TextStyle(
                      color: Color.fromARGB(79, 68, 63, 144),
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      "Daftar",
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
