import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/glass_container.dart';
import '../../settings/screens/settings_screen.dart';
import '../../auth/services/auth_service.dart';
import '../services/profile_service.dart';
import '../../../core/models/api_models.dart' as models;
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
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
        child: StreamBuilder<models.User?>(
          stream: _profileService.getUserStream(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = userSnapshot.data;
            // Fallback to FirebaseAuth user if Firestore doc doesn't exist yet
            final authUser = context.read<AuthService>().currentUser;

            final displayName = user?.name ?? authUser?.displayName ?? 'User';
            final email = user?.email ?? authUser?.email ?? 'No Email';
            final photoUrl = user?.avatar ?? authUser?.photoURL;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Picture
                  GlassContainer(
                    width: 120,
                    height: 120,
                    borderRadius: 60,
                    blur: 15,
                    opacity: 0.15,
                    child: photoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Color(0xFF6C63FF),
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF6C63FF),
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)],
                    ).createShader(bounds),
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 32),
                  // Stats
                  StreamBuilder<Map<String, String>>(
                    stream: _profileService.getUserStatsStream(),
                    builder: (context, statsSnapshot) {
                      final stats =
                          statsSnapshot.data ??
                          {'friends': '0', 'posts': '0', 'calls': '0'};
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            'Friends',
                            stats['friends']!,
                            Icons.people,
                          ),
                          _buildStatCard(
                            'Posts',
                            stats['posts']!,
                            Icons.article,
                          ),
                          _buildStatCard('Calls', stats['calls']!, Icons.call),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Profile Options
                  _buildProfileOption(
                    context,
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                     
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        await context.read<AuthService>().signOut();
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GlassContainer(
      width: 100,
      height: 100,
      borderRadius: 12,
      blur: 10,
      opacity: 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF6C63FF), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        height: 60,
        borderRadius: 12,
        blur: 10,
        opacity: 0.1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFF6C63FF)),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
