import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/akun.dart';
import 'package:myapp/logout.dart';
import 'package:myapp/home.dart';
import 'package:myapp/riwayatkuisioner.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: userId.isEmpty
          ? const Center(child: Text('User not logged in'))
          : FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('User data not found'));
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final String username = userData['username'] ?? 'User';
                final String email = userData['email'] ?? 'No Email';
                final String? profileImageUrl = userData['profileImageUrl'];

                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 68, 63, 144),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 50,
                                    backgroundImage: _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : (profileImageUrl != null &&
                                                    profileImageUrl.isNotEmpty
                                                ? NetworkImage(profileImageUrl)
                                                : const AssetImage(
                                                    'images/imagefoto.png'))
                                            as ImageProvider,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 68, 63, 144),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      color: Color.fromARGB(79, 11, 8, 53),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              SettingsItem(
                                icon: Icons.person,
                                title: 'Akun',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AkunScreen()));
                                },
                              ),
                              SettingsItem(
                                icon: Icons.notifications,
                                title: 'Riwayat Kuisioner',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RiwayatKuisionerScreen()));
                                },
                              ),
                              SettingsItem(
                                icon: Icons.logout,
                                title: 'Logout',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LogoutScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home,
                  color: Color.fromARGB(43, 68, 63, 144)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 68, 63, 144)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Position shadow
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon,
                      size: 24, color: const Color.fromARGB(255, 68, 63, 144)),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 68, 63, 144),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right,
                  color: Color.fromARGB(255, 68, 63, 144)),
            ],
          ),
        ),
      ),
    );
  }
}
