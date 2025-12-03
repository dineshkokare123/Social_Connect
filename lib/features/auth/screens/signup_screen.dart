import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import '../../profile/services/profile_service.dart';
import '../../../core/widgets/glass_container.dart';
import '../../home/screens/home_screen.dart';

import '../../../core/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validate inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final profileService = ProfileService();
      final navigator = Navigator.of(context);

      // Create Auth User
      final userCredential = await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (userCredential?.user != null) {
        // Create Firestore Profile
        await profileService.createProfile(
          uid: userCredential!.user!.uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );

        // Update Display Name in Auth
        await userCredential.user!.updateDisplayName(
          _nameController.text.trim(),
        );

        if (!mounted) return;

        // Navigate to home
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Registration failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              right: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF03DAC6).withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Back Button
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Title
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)],
                              ).createShader(bounds),
                              child: Text(
                                'Create Account',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign up to get started',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            // Name Field
                            GlassContainer(
                              height: 80, // Increased height for error message
                              borderRadius: 12,
                              blur: 10,
                              opacity: 0.1,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  textCapitalization: TextCapitalization.words,
                                  validator: Validators.name,
                                  decoration: const InputDecoration(
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF6C63FF),
                                    ),
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Email Field
                            GlassContainer(
                              height: 80, // Increased height for error message
                              borderRadius: 12,
                              blur: 10,
                              opacity: 0.1,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.email,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF6C63FF),
                                    ),
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Password Field
                            GlassContainer(
                              height: 80, // Increased height for error message
                              borderRadius: 12,
                              blur: 10,
                              opacity: 0.1,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: const TextStyle(color: Colors.white),
                                  validator: Validators.strongPassword,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF6C63FF),
                                    ),
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Sign Up Button
                            GlassContainer(
                              height: 56,
                              borderRadius: 12,
                              blur: 15,
                              opacity: 0.2,
                              color: const Color(0xFF6C63FF),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _isLoading ? null : _handleSignUp,
                                  child: Center(
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Social Sign Up
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.grey[800]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'Or sign up with',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey[800]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSocialButton(
                                  icon: FontAwesomeIcons.google,
                                  color: Colors.red,
                                  onTap: () async {
                                    try {
                                      final authService = context
                                          .read<AuthService>();
                                      final navigator = Navigator.of(context);
                                      final userCredential = await authService
                                          .signInWithGoogle();
                                      if (userCredential != null && mounted) {
                                        navigator.pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        _showErrorSnackBar(
                                          'Google Sign-In failed',
                                        );
                                      }
                                    }
                                  },
                                ),
                                _buildSocialButton(
                                  icon: FontAwesomeIcons.facebookF,
                                  color: Colors.blue,
                                  onTap: () {
                                    _showErrorSnackBar(
                                      'Facebook Sign-In coming soon',
                                    );
                                  },
                                ),
                                _buildSocialButton(
                                  icon: FontAwesomeIcons.apple,
                                  color: Colors.white,
                                  onTap: () async {
                                    try {
                                      final authService = context
                                          .read<AuthService>();
                                      final navigator = Navigator.of(context);
                                      final userCredential = await authService
                                          .signInWithApple();
                                      if (userCredential != null && mounted) {
                                        navigator.pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        _showErrorSnackBar(
                                          'Apple Sign-In failed',
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      width: 60,
      height: 60,
      borderRadius: 30,
      blur: 10,
      opacity: 0.1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Center(child: FaIcon(icon, color: color, size: 24)),
        ),
      ),
    );
  }
}
