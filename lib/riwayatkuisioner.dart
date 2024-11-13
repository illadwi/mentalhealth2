import 'package:flutter/material.dart';
import 'package:myapp/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

class RiwayatKuisionerScreen extends StatefulWidget {
  const RiwayatKuisionerScreen({super.key});

  @override
  _RiwayatKuisionerScreenState createState() => _RiwayatKuisionerScreenState();
}

class _RiwayatKuisionerScreenState extends State<RiwayatKuisionerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Riwayat Kuisioner',
          style: TextStyle(
            color: Color.fromARGB(255, 68, 63, 144),
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 68, 63, 144),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kuisioner_history')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final historyDocs = snapshot.data!.docs;
          if (historyDocs.isEmpty) {
            return const Center(child: Text('Belum ada riwayat kuisioner.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: historyDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                // Periksa apakah field 'date' adalah Timestamp atau String
                dynamic dateData = data['date'];
                DateTime date;
                if (dateData is Timestamp) {
                  date =
                      dateData.toDate(); // Jika Timestamp, konversi ke DateTime
                } else if (dateData is String) {
                  date = DateTime.parse(
                      dateData); // Jika String, gunakan DateTime.parse
                } else {
                  date = DateTime.now(); // Default, jika tidak sesuai
                }

                String formattedDate = DateFormat('EEEE, dd MMMM yyyy')
                    .format(date); // Format hari dan tanggal
                String formattedTime =
                    DateFormat('HH:mm').format(date); // Format waktu
                String historyItem =
                    'Score: ${data['score']}\n${data['results']}\nHari: $formattedDate\nWaktu: $formattedTime';
                return HistoryCard(historyItem: historyItem);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String historyItem;

  const HistoryCard({
    required this.historyItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 245, 245, 255),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              historyItem,
              style: const TextStyle(color: Color.fromARGB(255, 68, 63, 144)),
            ),
          ],
        ),
      ),
    );
  }
}
