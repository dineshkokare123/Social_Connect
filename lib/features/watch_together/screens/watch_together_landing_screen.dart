import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/widgets/glass_container.dart';
import 'watch_room_screen.dart';

class WatchTogetherLandingScreen extends StatefulWidget {
  const WatchTogetherLandingScreen({super.key});

  @override
  State<WatchTogetherLandingScreen> createState() =>
      _WatchTogetherLandingScreenState();
}

class _WatchTogetherLandingScreenState
    extends State<WatchTogetherLandingScreen> {
  final _roomIdController = TextEditingController();
  final _videoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roomIdController.text = (Random().nextInt(900000) + 100000).toString();
  }

  @override
  void dispose() {
    _roomIdController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  void _createRoom() {
    if (_roomIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a Room ID')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WatchRoomScreen(
          roomID: _roomIdController.text.trim(),
          videoUrl: _videoUrlController.text.trim(),
          isHost: true,
        ),
      ),
    );
  }

  void _joinRoom() {
    if (_roomIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a Room ID')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WatchRoomScreen(
          roomID: _roomIdController.text.trim(),
          isHost: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watch Together')),
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
                const Icon(
                  Icons.play_circle_filled,
                  size: 80,
                  color: Color(0xFF6C63FF),
                ),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)],
                  ).createShader(bounds),
                  child: const Text(
                    'Watch Together',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Watch videos with friends in sync',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
                const SizedBox(height: 32),
                GlassContainer(
                  height: 60,
                  borderRadius: 12,
                  blur: 10,
                  opacity: 0.1,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _roomIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Room ID',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.meeting_room,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GlassContainer(
                  height: 60,
                  borderRadius: 12,
                  blur: 10,
                  opacity: 0.1,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _videoUrlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Video URL (Optional for host)',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.link, color: Color(0xFF6C63FF)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _createRoom,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle, color: Colors.white),
                        label: const Text(
                          'Create Room',
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
                        onPressed: _joinRoom,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF03DAC6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.group, color: Colors.black),
                        label: const Text(
                          'Join Room',
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
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF03DAC6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF03DAC6).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF03DAC6),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Features',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem('Synchronized playback'),
                      _buildFeatureItem('Video chat while watching'),
                      _buildFeatureItem('Shared controls'),
                      _buildFeatureItem('Real-time reactions'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF03DAC6), size: 16),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        ],
      ),
    );
  }
}
