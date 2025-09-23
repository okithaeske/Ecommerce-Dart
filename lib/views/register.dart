import 'package:ecommerce/routes/app_route.dart';
import 'package:ecommerce/services/auth_api.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _emailFocused = false;
  bool _passwordFocused = false;
  bool _nameFocused = false;
  bool _confirmFocused = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late AnimationController _fadeController;

  // --- Live validation ---
  bool get canRegister {
    return widget.nameController.text.isNotEmpty &&
        widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty &&
        widget.confirmPasswordController.text.isNotEmpty &&
        widget.passwordController.text == widget.confirmPasswordController.text;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    // Add listeners for live validation
    widget.nameController.addListener(() => setState(() {}));
    widget.emailController.addListener(() => setState(() {}));
    widget.passwordController.addListener(() => setState(() {}));
    widget.confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    widget.nameController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    widget.confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!canRegister) {
      String error = "All fields required and passwords must match.";
      if (widget.passwordController.text != widget.confirmPasswordController.text) {
        error = "Passwords do not match.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      const String apiBase = 'https://zentara.duckdns.org/api';
      final api = AuthApi(baseUrl: apiBase);
      final name = widget.nameController.text.trim();
      final email = widget.emailController.text.trim();
      final password = widget.passwordController.text;
      await api.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: widget.confirmPasswordController.text,
      );
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Registration successful. Please sign in.')));
      navigator.pushReplacementNamed(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;
    final horizontalPadding = isWide ? 0.0 : 24.0;
    // Local alias avoids analyzer oddities across closures
    final bool isLoadingLocal = _isLoading;

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
                      colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.25 : 0.20),
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
                            image: AssetImage('assets/images/hero_watchproduct.jpg'),
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
                                shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Right: Register Card
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 34),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: _RegisterCard(
                              fadeController: _fadeController,
                              nameController: widget.nameController,
                              emailController: widget.emailController,
                              passwordController: widget.passwordController,
                              confirmPasswordController: widget.confirmPasswordController,
                              obscurePassword: _obscurePassword,
                              obscureConfirm: _obscureConfirm,
                              nameFocused: _nameFocused,
                              emailFocused: _emailFocused,
                              passwordFocused: _passwordFocused,
                              confirmFocused: _confirmFocused,
                              canRegister: canRegister,
                              isLoading: _isLoading,
                              onNameFocus: (v) => setState(() => _nameFocused = v),
                              onEmailFocus: (v) => setState(() => _emailFocused = v),
                              onPasswordFocus: (v) => setState(() => _passwordFocused = v),
                              onConfirmFocus: (v) => setState(() => _confirmFocused = v),
                              onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                              onToggleConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              onSubmit: () => _submit(context),
                              onGoToLogin: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: _RegisterCard(
                        fadeController: _fadeController,
                        nameController: widget.nameController,
                        emailController: widget.emailController,
                        passwordController: widget.passwordController,
                        confirmPasswordController: widget.confirmPasswordController,
                        obscurePassword: _obscurePassword,
                        obscureConfirm: _obscureConfirm,
                        nameFocused: _nameFocused,
                        emailFocused: _emailFocused,
                        passwordFocused: _passwordFocused,
                        confirmFocused: _confirmFocused,
                        canRegister: canRegister,
                        isLoading: _isLoading,
                        onNameFocus: (v) => setState(() => _nameFocused = v),
                        onEmailFocus: (v) => setState(() => _emailFocused = v),
                        onPasswordFocus: (v) => setState(() => _passwordFocused = v),
                        onConfirmFocus: (v) => setState(() => _confirmFocused = v),
                        onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                        onToggleConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        onSubmit: () => _submit(context),
                        onGoToLogin: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// --- Register Card split for reuse ---
class _RegisterCard extends StatelessWidget {
  final AnimationController fadeController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool nameFocused;
  final bool emailFocused;
  final bool passwordFocused;
  final bool confirmFocused;
  final bool canRegister;
  final bool isLoading;
  final ValueChanged<bool> onNameFocus;
  final ValueChanged<bool> onEmailFocus;
  final ValueChanged<bool> onPasswordFocus;
  final ValueChanged<bool> onConfirmFocus;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;

  const _RegisterCard({
    required this.fadeController,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.nameFocused,
    required this.emailFocused,
    required this.passwordFocused,
    required this.confirmFocused,
    required this.canRegister,
    required this.isLoading,
    required this.onNameFocus,
    required this.onEmailFocus,
    required this.onPasswordFocus,
    required this.onConfirmFocus,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onSubmit,
    required this.onGoToLogin,
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
              Icons.person_add_alt_1,
              size: 80,
              color: nameFocused || emailFocused || passwordFocused || confirmFocused
                  ? colorScheme.primary
                   : colorScheme.primary.withValues(alpha: 0.8),
              shadows: [
                if (nameFocused || emailFocused || passwordFocused || confirmFocused)
                  Shadow(
                    color: colorScheme.primary.withValues(alpha: 0.22),
                    blurRadius: 18,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Create Account",
            style: TextStyle(
              fontSize: 26,
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
                  // Name
                  Focus(
                    onFocusChange: onNameFocus,
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                        prefixIcon: Icon(Icons.person, color: colorScheme.primary),
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
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Email
                  Focus(
                    onFocusChange: onEmailFocus,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
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
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password
                  Focus(
                    onFocusChange: onPasswordFocus,
                    child: TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                        prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: colorScheme.primary,
                          ),
                          onPressed: onTogglePassword,
                          tooltip: obscurePassword ? "Show password" : "Hide password",
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
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password
                  Focus(
                    onFocusChange: onConfirmFocus,
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirm,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                        prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirm ? Icons.visibility_off : Icons.visibility,
                            color: colorScheme.primary,
                          ),
                          onPressed: onToggleConfirm,
                          tooltip: obscureConfirm ? "Show password" : "Hide password",
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
                      onSubmitted: (_) => onSubmit(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canRegister && !isLoading ? onSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text(
                                "Create Account",
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: onGoToLogin,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: colorScheme.secondary,
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
