import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../call/screens/video_call_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String userId;

  const ChatDetailScreen({
    super.key,
    required this.userName,
    required this.userId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;

  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _messages.add({
          'type': 'image',
          'content': image.path,
          'isSent': true,
          'time': DateTime.now(),
        });
      });
    }
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
      return;
    }

    final path = '/tmp/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _audioRecorder.start(const RecordConfig(), path: path);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      if (path != null) {
        _messages.add({
          'type': 'audio',
          'content': path,
          'isSent': true,
          'time': DateTime.now(),
        });
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'type': 'text',
        'content': _messageController.text,
        'isSent': true,
        'time': DateTime.now(),
      });
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF6C63FF),
              child: Text(widget.userName[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName, style: const TextStyle(fontSize: 16)),
                  const Text(
                    'Online',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                    callId: 'call_${widget.userId}',
                    userName: widget.userName,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                    callId: 'call_${widget.userId}',
                    userName: widget.userName,
                    isVideoCall: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isSent = message['isSent'] as bool;
    final type = message['type'] as String;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isSent ? const Color(0xFF6C63FF) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _buildMessageContent(type, message['content']),
      ),
    );
  }

  Widget _buildMessageContent(String type, dynamic content) {
    switch (type) {
      case 'text':
        return Text(
          content as String,
          style: const TextStyle(color: Colors.white),
        );
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(content as String),
            width: 200,
            fit: BoxFit.cover,
          ),
        );
      case 'audio':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () async {
                await _audioPlayer.play(DeviceFileSource(content as String));
              },
            ),
            const Text('Audio message', style: TextStyle(color: Colors.white)),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.image), onPressed: _pickImage),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          if (_isRecording)
            IconButton(
              icon: const Icon(Icons.stop, color: Colors.red),
              onPressed: _stopRecording,
            )
          else
            IconButton(icon: const Icon(Icons.mic), onPressed: _startRecording),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF6C63FF)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
