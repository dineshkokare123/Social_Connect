import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();

  // Mock data for reels
  final List<Map<String, String>> _reels = [
    {
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'user': 'nature_lover',
      'desc': 'Beautiful butterfly in the garden 🦋 #nature #beauty',
      'likes': '1.2k',
      'comments': '45',
    },
    {
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'user': 'macro_world',
      'desc': 'Busy bee collecting pollen 🐝 #macro #insect',
      'likes': '856',
      'comments': '23',
    },
    {
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'user': 'travel_diaries',
      'desc': 'Missing these summer vibes ☀️ #travel #summer',
      'likes': '2.5k',
      'comments': '120',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Moments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        itemBuilder: (context, index) {
          return ReelItem(data: _reels[index]);
        },
      ),
    );
  }
}

class ReelItem extends StatefulWidget {
  final Map<String, String> data;

  const ReelItem({super.key, required this.data});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.data['url']!))
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
            _controller.setLooping(true);
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Player
        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            color: Colors.black,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  ),
          ),
        ),

        // Play/Pause Icon Overlay
        if (!_isPlaying)
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 80,
              color: Colors.white54,
            ),
          ),

        // Overlay UI
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFF6C63FF),
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '@${widget.data['user']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Follow',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.data['desc']!,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.music_note, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Original Audio',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAction(
                      Icons.favorite,
                      widget.data['likes']!,
                      const Color(0xFFFF4081),
                    ),
                    const SizedBox(height: 20),
                    _buildAction(
                      Icons.comment,
                      widget.data['comments']!,
                      Colors.white,
                    ),
                    const SizedBox(height: 20),
                    _buildAction(Icons.share, 'Share', Colors.white),
                    const SizedBox(height: 20),
                    _buildAction(Icons.more_vert, '', Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
