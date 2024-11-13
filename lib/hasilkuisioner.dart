import 'package:flutter/material.dart';
import 'package:myapp/setting.dart';
import 'home.dart';
import 'riwayatkuisioner.dart';

class HasilKuisionerScreen extends StatelessWidget {
  final int totalScore;

  const HasilKuisionerScreen({super.key, required this.totalScore});

  String getDepressionLevelMessage() {
    if (totalScore >= 20) {
      return 'Tingkat Depresi anda tergolong sangat berat, segera konsultasikan ke tenaga ahli.';
    } else if (totalScore >= 15) {
      return 'Tingkat Depresi anda tergolong berat, disarankan untuk mencari bantuan profesional.';
    } else if (totalScore >= 10) {
      return 'Tingkat Depresi anda tergolong sedang, pertimbangkan untuk melakukan konseling.';
    } else if (totalScore >= 5) {
      return 'Tingkat Depresi anda tergolong ringan, buka Tips Managemen Stres untuk mendapatkan informasi penanganan.';
    } else {
      return 'Depresi minimal, tetap jaga kesehatan mental dan lakukan kegiatan positif.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hasil Kuisioner',
            style: TextStyle(color: Color.fromARGB(255, 68, 63, 144))),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 68, 63, 144)),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Hasil Kuesioner Depresi',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 68, 63, 144)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Skor Anda: $totalScore',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 68, 63, 144)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Result List
              Expanded(
                child: ListView(
                  children: [
                    _buildResultItem('Depresi sangat Berat', '20-30'),
                    _buildDivider(),
                    _buildResultItem('Depresi Berat', '15-19'),
                    _buildDivider(),
                    _buildResultItem('Depresi Sedang', '10-14'),
                    _buildDivider(),
                    _buildResultItem('Depresi Ringan', '5-9'),
                    _buildDivider(),
                    _buildResultItem('Minimal Depresi', '0-4'),
                    _buildDivider(),
                  ],
                ),
              ),
              // Message based on score
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  getDepressionLevelMessage(),
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 68, 63, 144)),
                ),
              ),
              // Finish Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RiwayatKuisionerScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 68, 63, 144),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Ubah radius menjadi 4 atau nilai kecil lainnya
                    ),
                  ),
                  child: const Text('Selesai',
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home,
                  size: 24,
                  color: Color.fromARGB(255, 68, 63, 144),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  size: 24,
                  color: Color.fromARGB(43, 68, 63, 144),
                ),
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
      ),
    );
  }

  Widget _buildResultItem(String label, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Color.fromARGB(255, 68, 63, 144))),
          Text(range,
              style: const TextStyle(color: Color.fromARGB(255, 68, 63, 144))),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color.fromARGB(43, 68, 63, 144),
      thickness: 1,
    );
  }
}
