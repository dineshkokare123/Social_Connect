import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/widgets/glass_container.dart';
import 'tutoring_session_screen.dart';

class TutoringLandingScreen extends StatefulWidget {
  const TutoringLandingScreen({super.key});

  @override
  State<TutoringLandingScreen> createState() => _TutoringLandingScreenState();
}

class _TutoringLandingScreenState extends State<TutoringLandingScreen> {
  final _sessionIdController = TextEditingController();
  bool _isTutor = false;

  @override
  void initState() {
    super.initState();
    _sessionIdController.text = (Random().nextInt(900000) + 100000).toString();
  }

  @override
  void dispose() {
    _sessionIdController.dispose();
    super.dispose();
  }

  void _joinSession() {
    if (_sessionIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Session ID')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutoringSessionScreen(
          sessionID: _sessionIdController.text.trim(),
          isTutor: _isTutor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1-on-1 Tutoring')),
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
                const Icon(Icons.school, size: 80, color: Color(0xFF6C63FF)),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)],
                  ).createShader(bounds),
                  child: const Text(
                    '1-on-1 Tutoring',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with tutors or students',
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
                    controller: _sessionIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Session ID',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.numbers, color: Color(0xFF6C63FF)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GlassContainer(
                  borderRadius: 12,
                  blur: 10,
                  opacity: 0.1,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFF6C63FF)),
                      const SizedBox(width: 12),
                      const Text(
                        'Join as:',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(
                            value: false,
                            label: Text('Student'),
                            icon: Icon(Icons.person_outline),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text('Tutor'),
                            icon: Icon(Icons.school_outlined),
                          ),
                        ],
                        selected: {_isTutor},
                        onSelectionChanged: (Set<bool> newSelection) {
                          setState(() {
                            _isTutor = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _joinSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.video_call, color: Colors.white),
                    label: Text(
                      _isTutor ? 'Start Tutoring Session' : 'Join Session',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                      _buildFeatureItem('HD Video & Audio'),
                      _buildFeatureItem('Screen Sharing'),
                      _buildFeatureItem('Interactive Whiteboard'),
                      _buildFeatureItem('Chat & File Sharing'),
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
