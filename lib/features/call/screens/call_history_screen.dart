import 'package:flutter/material.dart';
import 'video_call_screen.dart';
import 'video_conference_screen.dart';

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calls')),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          final isVideoCall = index % 2 == 0;
          final isMissed = index % 5 == 0;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Colors.primaries[index % Colors.primaries.length],
              child: Text('U${index + 1}'),
            ),
            title: Text('User ${index + 1}'),
            subtitle: Row(
              children: [
                Icon(
                  isMissed ? Icons.call_missed : Icons.call_received,
                  size: 16,
                  color: isMissed ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  isMissed ? 'Missed' : 'Incoming',
                  style: TextStyle(color: isMissed ? Colors.red : Colors.grey),
                ),
                const SizedBox(width: 8),
                Text(
                  '${index + 1}:${(index * 5) % 60} PM',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isVideoCall ? Icons.videocam : Icons.call,
                color: const Color(0xFF6C63FF),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallScreen(
                      callId: 'call_user_${index + 1}',
                      userName: 'User ${index + 1}',
                      isVideoCall: isVideoCall,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showConferenceDialog(context);
        },
        icon: const Icon(Icons.video_call),
        label: const Text('New Conference'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
    );
  }

  void _showConferenceDialog(BuildContext context) {
    final TextEditingController conferenceIdController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join/Start Conference'),
        content: TextField(
          controller: conferenceIdController,
          decoration: const InputDecoration(
            labelText: 'Conference ID',
            hintText: 'Enter a unique ID',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (conferenceIdController.text.isNotEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoConferenceScreen(
                      conferenceId: conferenceIdController.text,
                      userId: DateTime.now().millisecondsSinceEpoch.toString(),
                      userName:
                          'User', // You might want to get the actual user name here
                    ),
                  ),
                );
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
