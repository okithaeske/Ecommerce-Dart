import 'package:ecommerce/routes/app_route.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
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
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;
    final horizontalPadding = isWide ? 0.0 : 24.0;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          // Subtle background gradient
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.surfaceVariant.withOpacity(
                        isDark ? 0.25 : 0.20,
                      ),
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
          // Responsive Layout
          isWide
              ? Row(
                children: [
                  // Left: Brand / Hero Image panel
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant,
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/hero_watchproduct.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.38),
                        child: Center(
                          child: Text(
                            'ZENATARA\nLUXURY WATCHES',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.93),
                              fontWeight: FontWeight.bold,
                              fontSize: 34,
                              letterSpacing: 2.5,
                              height: 1.15,
                              shadows: [
                                Shadow(color: Colors.black45, blurRadius: 6),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Right: Login Card - make sure it's scrollable!
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 42.0,
                          vertical: 34,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: _LoginCard(
                            fadeController: _fadeController,
                            emailController: widget.emailController,
                            passwordController: widget.passwordController,
                            obscurePassword: _obscurePassword,
                            emailFocused: _emailFocused,
                            passwordFocused: _passwordFocused,
                            onEmailFocus:
                                (v) => setState(() => _emailFocused = v),
                            onPasswordFocus:
                                (v) => setState(() => _passwordFocused = v),
                            onTogglePassword:
                                () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                            onSubmit: () => _submit(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _LoginCard(
                      fadeController: _fadeController,
                      emailController: widget.emailController,
                      passwordController: widget.passwordController,
                      obscurePassword: _obscurePassword,
                      emailFocused: _emailFocused,
                      passwordFocused: _passwordFocused,
                      onEmailFocus: (v) => setState(() => _emailFocused = v),
                      onPasswordFocus:
                          (v) => setState(() => _passwordFocused = v),
                      onTogglePassword:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                      onSubmit: () => _submit(context),
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

// --- Login Card split for reuse ---
class _LoginCard extends StatelessWidget {
  final AnimationController fadeController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool emailFocused;
  final bool passwordFocused;
  final ValueChanged<bool> onEmailFocus;
  final ValueChanged<bool> onPasswordFocus;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  const _LoginCard({
    required this.fadeController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.emailFocused,
    required this.passwordFocused,
    required this.onEmailFocus,
    required this.onPasswordFocus,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: fadeController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.lock_outline,
              size: 80,
              color:
                  emailFocused || passwordFocused
                      ? colorScheme.primary
                      : colorScheme.primary.withOpacity(0.8),
              shadows: [
                if (emailFocused || passwordFocused)
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
                    onFocusChange: onEmailFocus,
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(color: colorScheme.onSurface),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        fillColor: colorScheme.surface,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Focus(
                    onFocusChange: onPasswordFocus,
                    child: TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: colorScheme.primary,
                          ),
                          onPressed: onTogglePassword,
                          tooltip:
                              obscurePassword
                                  ? "Show password"
                                  : "Hide password",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        fillColor: colorScheme.surface,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => onSubmit(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSubmit,
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
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
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
    );
  }
}
