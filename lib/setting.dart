import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myapp/akun.dart';
import 'package:myapp/logout.dart';
import 'home.dart';
import 'riwayatkuisioner.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  File? _imageFile;

  Future<void> _pickImage() async {
    // Meminta izin akses foto di perangkat
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // ignore: avoid_print
        print("Foto berhasil dipilih: ${pickedFile.path}");
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _uploadProfileImage();
      } else {
        // ignore: avoid_print
        print("Tidak ada foto yang dipilih");
      }
    } else {
      // ignore: avoid_print
      print('Permission denied');
    }
  }

  Future<void> _uploadProfileImage() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
      await ref.putFile(_imageFile!);
      final url = await ref.getDownloadURL();

      // Simpan URL gambar di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImageUrl': url});
    } catch (e) {
      // ignore: avoid_print
      print("Error uploading profile image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
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
          final String profileImageUrl =
              userData['profileImageUrl'] ?? 'images/PROFILE.jpeg';

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 50,
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : NetworkImage(profileImageUrl)
                                          as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.edit, color: Colors.black),
                                      onPressed: _pickImage,
                                    ),
                                  ),
                                ),
                              ],
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
                                color: Color.fromARGB(43, 68, 63, 144),
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
                                    builder: (context) => const AkunScreen()));
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
                                    builder: (context) => const LogoutScreen()));
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
              icon: const Icon(Icons.home, color: Color.fromARGB(43, 68, 63, 144)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.settings, color: Color.fromARGB(255, 68, 63, 144)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SettingScreen()));
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
