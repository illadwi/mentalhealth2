import 'package:flutter/material.dart';
import 'package:myapp/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatKuisionerScreen extends StatefulWidget {
  const RiwayatKuisionerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RiwayatKuisionerScreenState createState() => _RiwayatKuisionerScreenState();
}

class _RiwayatKuisionerScreenState extends State<RiwayatKuisionerScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('kuisioner_history') ?? [];
    });
  }

  Future<void> _removeHistoryItem(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _history.remove(item);
      prefs.setStringList('kuisioner_history', _history);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Riwayat Kuisioner'),
        shadowColor: const Color.fromARGB(255, 68, 63, 144),
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
      body: _history.isEmpty
          ? const Center(child: Text('Belum ada riwayat kuisioner.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _history.map((historyItem) {
                  return HistoryCard(
                    historyItem: historyItem,
                    onDelete: () => _removeHistoryItem(historyItem),
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String historyItem;
  final VoidCallback onDelete;

  const HistoryCard({super.key, required this.historyItem, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    // Split the history item into lines
    var lines = historyItem.split('\n');
    var scoreLine = lines[0]; // The first line should be the score
    var questionsAndAnswers = lines.skip(1); // The rest are questions and answers

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hapus Riwayat'),
              content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
              actions: [
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Hapus'),
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(43, 68, 63, 144),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scoreLine,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ...questionsAndAnswers.map((item) {
              return Text(
                item,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
