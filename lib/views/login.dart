import 'package:ecommerce/routes/app_route.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _emailFocused = false;
  bool _passwordFocused = false;

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          // Subtle gradient for luxury look
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.surfaceVariant.withOpacity(isDark ? 0.25 : 0.20),
                      colorScheme.primary.withOpacity(0.03),
                      colorScheme.background,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: _emailFocused || _passwordFocused
                            ? colorScheme.primary
                            : colorScheme.primary.withOpacity(0.8),
                        shadows: [
                          if (_emailFocused || _passwordFocused)
                            Shadow(
                              color: colorScheme.primary.withOpacity(0.22),
                              blurRadius: 18,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 2.2,
                      color: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      shadowColor: colorScheme.primary.withOpacity(0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Focus(
                              onFocusChange: (v) => setState(() => _emailFocused = v),
                              child: TextField(
                                controller: widget.emailController,
                                style: TextStyle(color: colorScheme.onSurface),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.email, color: colorScheme.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
                                  ),
                                  fillColor: colorScheme.surface,
                                  filled: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Focus(
                              onFocusChange: (v) => setState(() => _passwordFocused = v),
                              child: TextField(
                                controller: widget.passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(color: colorScheme.onSurface),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      color: colorScheme.primary,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    tooltip: _obscurePassword ? "Show password" : "Hide password",
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
                                  ),
                                  fillColor: colorScheme.surface,
                                  filled: true,
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(context),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _submit(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: colorScheme.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "© 2025 Zentara Luxury Watches",
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onBackground.withOpacity(0.55),
                        letterSpacing: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    // Add validation/authentication logic here if needed
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }
}
