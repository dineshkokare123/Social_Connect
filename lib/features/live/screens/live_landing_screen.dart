import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/widgets/glass_container.dart';
import 'live_page.dart';

class LiveLandingScreen extends StatefulWidget {
  const LiveLandingScreen({super.key});

  @override
  State<LiveLandingScreen> createState() => _LiveLandingScreenState();
}

class _LiveLandingScreenState extends State<LiveLandingScreen> {
  final _liveIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _liveIdController.text = (Random().nextInt(900000) + 100000).toString();
  }

  @override
  void dispose() {
    _liveIdController.dispose();
    super.dispose();
  }

  void _joinLive(bool isHost) {
    if (_liveIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a Live ID')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LivePage(liveID: _liveIdController.text.trim(), isHost: isHost),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Streaming')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF121212),
              const Color(0xFF6C63FF).withValues(alpha: 0.2),
              const Color(0xFF121212),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.live_tv, size: 80, color: Color(0xFF6C63FF)),
                const SizedBox(height: 32),
                GlassContainer(
                  height: 60,
                  borderRadius: 12,
                  blur: 10,
                  opacity: 0.1,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _liveIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Live ID',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.numbers, color: Color(0xFF6C63FF)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _joinLive(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.videocam, color: Colors.white),
                        label: const Text(
                          'Start Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _joinLive(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF03DAC6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Watch Live',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
