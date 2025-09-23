import 'package:ecommerce/routes/app_route.dart';
import 'package:ecommerce/repositories/auth_repository.dart';
import 'package:ecommerce/services/auth_api.dart';
import 'package:ecommerce/providers/auth_provider.dart';
import 'package:provider/provider.dart';
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
  bool _isLoading = false;

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    // Rebuild the UI when text changes to update the button
    widget.emailController.addListener(() => setState(() {}));
    widget.passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    super.dispose();
  }

  // Check if both fields have values
  bool get canLogin =>
      widget.emailController.text.trim().isNotEmpty &&
      widget.passwordController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;
    final horizontalPadding = isWide ? 0.0 : 24.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Subtle background gradient
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.surfaceContainerHighest.withValues(
                        alpha: isDark ? 0.25 : 0.20,
                      ),
                      colorScheme.primary.withValues(alpha: 0.03),
                      colorScheme.surface,
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
                          color: colorScheme.surfaceContainerHighest,
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/hero_watchproduct.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.38),
                          child: Center(
                            child: Text(
                              'ZENATARA\nLUXURY WATCHES',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.93),
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
                              canLogin: canLogin,
                              isLoading: _isLoading,
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
                        canLogin: canLogin,
                        isLoading: _isLoading,
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

  Future<void> _submit(BuildContext context) async {
    if (_isLoading) return;
    if (!canLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both email and password are required.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    // Capture dependencies that use BuildContext before the async gap.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final auth = context.read<AuthProvider>();
    try {
      final email = widget.emailController.text.trim();
      final password = widget.passwordController.text.trim();
      // Point this to your Laravel API base URL (without trailing slash)
      const String apiBase = 'https://zentara.duckdns.org/api';
      final repo = AuthRepository(AuthApi(baseUrl: apiBase));

      final res = await repo.login(email: email, password: password);
      if (!mounted) return;
      auth.setAuth(
        token: res.token,
        tokenType: res.tokenType,
        user: res.user,
      );
      navigator.pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
  final bool canLogin;
  final bool isLoading;
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
    required this.canLogin,
    required this.isLoading,
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
                      : colorScheme.primary.withValues(alpha: 0.8),
              shadows: [
                if (emailFocused || passwordFocused)
                  Shadow(
                    color: colorScheme.primary.withValues(alpha: 0.22),
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
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 2.2,
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            shadowColor: colorScheme.primary.withValues(alpha: 0.08),
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
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
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
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
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
                      onSubmitted: (_) {
                        if (canLogin) {
                          onSubmit();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Both email and password are required.'),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (canLogin && !isLoading)
                          ? onSubmit
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Both email and password are required.'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
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
              color: colorScheme.onSurface.withValues(alpha: 0.55),
              letterSpacing: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
