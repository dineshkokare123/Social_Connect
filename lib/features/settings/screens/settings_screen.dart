import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Appearance Section
            _buildSectionTitle('Appearance'),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Toggle dark/light theme',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 24),

            // Notifications Section
            _buildSectionTitle('Notifications'),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.notifications_active,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            _buildSettingTile(
              icon: Icons.message,
              title: 'Message Notifications',
              subtitle: 'Get notified for new messages',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            _buildSettingTile(
              icon: Icons.call,
              title: 'Call Notifications',
              subtitle: 'Get notified for incoming calls',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 24),

            // Privacy Section
            _buildSectionTitle('Privacy & Security'),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.lock,
              title: 'Biometric Lock',
              subtitle: 'Use biometrics to unlock app',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            _buildSettingTile(
              icon: Icons.visibility,
              title: 'Last Seen',
              subtitle: 'Show your last seen status',
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            _buildSettingTile(
              icon: Icons.location_on,
              title: 'Location Sharing',
              subtitle: 'Share your location with friends',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 24),

            // Data & Storage Section
            _buildSectionTitle('Data & Storage'),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.download,
              title: 'Auto Download Media',
              subtitle: 'Automatically download photos and videos',
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeThumbColor: const Color(0xFF6C63FF),
              ),
            ),
            _buildSettingTile(
              icon: Icons.storage,
              title: 'Storage Usage',
              subtitle: 'Manage app storage',
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // About Section
            _buildSectionTitle('About'),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.info,
              title: 'App Version',
              subtitle: '1.0.0',
            ),
            _buildSettingTile(
              icon: Icons.description,
              title: 'Terms & Conditions',
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF6C63FF),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: 12,
        blur: 10,
        opacity: 0.1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFF6C63FF)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null)
                    trailing
                  else if (onTap != null)
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
