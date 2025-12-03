import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import '../../../core/widgets/glass_container.dart';
import '../../home/screens/home_screen.dart';
import 'signup_screen.dart';

import '../../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final navigator = Navigator.of(context);

      await authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      // Navigate to home
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Login failed: ${e.toString()}');
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
              right: -100,
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
              left: -100,
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
                            // Logo with glass effect
                            Center(
                              child: GlassContainer(
                                width: 100,
                                height: 100,
                                borderRadius: 50,
                                blur: 15,
                                opacity: 0.15,
                                child: const Icon(
                                  Icons.connect_without_contact,
                                  size: 50,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF03DAC6)],
                              ).createShader(bounds),
                              child: Text(
                                'Welcome Back',
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
                              'Sign in to continue',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            // Email field with glass effect
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
                            // Password field with glass effect
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
                                  validator: Validators.password,
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
                            // Sign in button with glass effect
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
                                  onTap: _isLoading ? null : _handleLogin,
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
                                            'Sign In',
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
                            const SizedBox(height: 24),
                            // Biometric Auth
                            Center(
                              child: IconButton(
                                onPressed: () async {
                                  final authenticated = await context
                                      .read<AuthService>()
                                      .authenticateWithBiometrics();
                                  if (authenticated && context.mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.fingerprint,
                                  size: 40,
                                  color: Color(0xFF03DAC6),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Social Login
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
                                    'Or continue with',
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
                                        navigator.pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
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
                                        navigator.pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
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
                            const SizedBox(height: 32),
                            // Sign Up Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFF6C63FF),
                                      fontWeight: FontWeight.bold,
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
