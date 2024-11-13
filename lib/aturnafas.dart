import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/meditasi.dart';
import 'package:myapp/setting.dart';

class AturNafasScreen extends StatelessWidget {
  const AturNafasScreen({super.key});

  void _navigateToTimer(BuildContext context, int duration) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerScreen(duration: duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 68, 63, 144),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MeditasiScreen()));
          },
        ),
        title: const Text(
          'Atur Nafas',
          style: TextStyle(color: Color.fromARGB(255, 68, 63, 144)),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              _buildDurationOption(context, 5, "5 Menit"),
              _buildDurationOption(context, 10, "10 Menit"),
              _buildDurationOption(context, 20, "20 Menit"),
              _buildDurationOption(context, 30, "30 Menit"),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Color.fromARGB(255, 68, 63, 144),
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

  Widget _buildDurationOption(
      BuildContext context, int duration, String label) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () => _navigateToTimer(context, duration),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Warna latar belakang kotak
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Posisi bayangan
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 68, 63, 144),
                    fontSize: 20,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: Color.fromARGB(255, 68, 63, 144),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerScreen extends StatefulWidget {
  final int duration; // Durasi dalam menit

  const TimerScreen({super.key, required this.duration});

  @override
  // ignore: library_private_types_in_public_api
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int remainingSeconds;
  Timer? _timer;
  bool isRunning = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  double volume = 0.5; // Volume awal

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.duration * 60;
    _audioPlayer.setVolume(volume);
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    _audioPlayer.play(AssetSource('sound/musik.mp3'), volume: volume);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          _audioPlayer.stop();
          isRunning = false;
        }
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _audioPlayer.pause();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      remainingSeconds = widget.duration * 60;
    });
  }

  void toggleTimer() {
    if (isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void increaseVolume() {
    setState(() {
      volume = (volume + 0.1).clamp(0.0, 1.0);
      _audioPlayer.setVolume(volume);
    });
  }

  void decreaseVolume() {
    setState(() {
      volume = (volume - 0.1).clamp(0.0, 1.0);
      _audioPlayer.setVolume(volume);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String get timerText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Atur Nafas - ${widget.duration} Menit',
          style: const TextStyle(color: Color.fromARGB(255, 68, 63, 144)),
        ),
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 68, 63, 144),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Duduk tenang, pejamkan mata, berdiam diri, dan fokus pada keheningan tanpa merespon pikiran yang muncul.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 68, 63, 144)),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Column(
                    children: [
                      Text(
                        timerText,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 68, 63, 144),
                        ),
                      ),
                      const SizedBox(height: 80),
                      const Icon(
                        Icons.access_time,
                        size: 100,
                        color: Color.fromARGB(255, 68, 63, 144),
                      ),
                    ],
                  ),
                  const SizedBox(height: 200),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh,
                            size: 40, color: Color.fromARGB(255, 68, 63, 144)),
                        onPressed: resetTimer,
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: toggleTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 68, 63, 144),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25), // Mengurangi radius untuk mengurangi oval
                          ),
                        ),
                        child: Text(isRunning ? 'Pause' : 'Play'),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.volume_up,
                            size: 40, color: Color.fromARGB(255, 68, 63, 144)),
                        onPressed: increaseVolume,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Color.fromARGB(255, 68, 63, 144),
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
}
