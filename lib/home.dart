import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/kuisioner.dart';
import 'package:myapp/meditasi.dart';
import 'package:myapp/setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String? username;
  String? selectedEmotion; // Variable to track the selected emotion

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    if (userId.isNotEmpty) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        setState(() {
          username = userDoc['username'];
        });
      } catch (e) {
        // ignore: avoid_print
        print("Error fetching username: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              20.0, 40.0, 20.0, 20.0), // Menambahkan padding atas lebih besar
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi ${username ?? "User"}!',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 68, 63, 144),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _buildGreetingSection(),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildGridButton(
                      context,
                      Icons.list_alt,
                      'Kuesioner',
                      const KuisionerScreen(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildGridButton(
                      context,
                      Icons.psychology,
                      'Meditasi',
                      const MeditasiScreen(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(43, 68, 63, 144),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Artikel & Berita',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildArticleCard(
                      'Apa Itu Kecemasan?',
                      'Perasaan cemas yang dialami dapat\ndicegah dan diatasi',
                    ),
                    _buildArticleCard(
                      'Cara Mengatasi Kecemasan',
                      'Pelajari beberapa cara untuk mengurangi\nkecemasan',
                    ),
                    _buildArticleCard(
                      'Apa Itu meditasi?',
                      'Teknik menjernihkan pikiran untuk\nmempertajam fokus',
                    ),
                    _buildArticleCard(
                      'Pentingnya Meditasi',
                      'Meditasi sebagai metode untuk mengelola\nkecemasan',
                    ),
                    _buildArticleCard(
                      'Apa Itu Serangan Panik?',
                      'Serangan panik adalah perasaan takut dan\ncemas yang sangat hebat.',
                    ),
                    _buildArticleCard(
                      'Apa penyebab serangan panik?',
                      'Cemas, stress, dan pengalaman\nmengerikan',
                    ),
                    _buildArticleCard(
                      'Apa Itu Anxiety Disorder?',
                      'Anxiety disorder adalah masalah kejiwaan\nberupa gangguan kecemasan.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 68, 63, 144),
              ),
              onPressed: () {
                // Aksi ketika tombol "Home" ditekan
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Color.fromARGB(43, 68, 63, 144),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    String greeting = _getGreetingMessage();
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(43, 68, 63, 144),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bagaimana perasaanmu?',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEmotionIcon(Icons.sentiment_dissatisfied, 'sedih'),
              _buildEmotionIcon(Icons.sentiment_neutral, 'biasa saja'),
              _buildEmotionIcon(Icons.sentiment_satisfied, 'senang'),
              _buildEmotionIcon(
                  Icons.sentiment_very_satisfied, 'sangat senang'),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi!';
    } else if (hour < 18) {
      return 'Selamat Siang!';
    } else {
      return 'Selamat Malam!';
    }
  }

  Widget _buildEmotionIcon(IconData icon, String emotion) {
    bool isSelected = selectedEmotion == emotion;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmotion = emotion;
        });
        // ignore: avoid_print
        print('Clicked on $emotion');
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: isSelected ? 50 : 40,
            color: isSelected
                ? const Color.fromARGB(255, 68, 63, 144)
                : Colors.black,
          ),
          const SizedBox(height: 5),
          Text(emotion),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          const Icon(Icons.article, size: 40),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                overflow: TextOverflow.fade,
                maxLines: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(43, 68, 63, 144),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 5),
            Text(label),
          ],
        ),
      ),
    );
  }
}