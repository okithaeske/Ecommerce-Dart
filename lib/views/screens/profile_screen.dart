import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/providers/auth_provider.dart';
import 'package:ecommerce/routes/app_route.dart';
import 'package:ecommerce/services/profile_api.dart';
import 'package:ecommerce/utils/api_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;
  Map<String, dynamic>? _user;

  ProfileApi get _api => ProfileApi(baseUrl: ApiConfig.baseUrl);

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final cachedUser = auth.user;
    if (cachedUser != null) {
      _syncControllers(cachedUser);
      _user = cachedUser;
      _loading = false;
    }
    Future.microtask(() => _refreshProfile(forceLoading: cachedUser == null));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _refreshProfile({bool forceLoading = false}) async {
    final auth = context.read<AuthProvider>();
    final token = auth.token;
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Your session has expired. Please sign in again.';
      });
      return;
    }

    final shouldShowSpinner = forceLoading || _user == null;
    if (shouldShowSpinner && mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else if (mounted) {
      setState(() {
        _error = null;
      });
    }

    try {
      final user = await _api.fetchCurrentUser(
        token: token,
        tokenType: auth.tokenType,
        currentUserId: auth.user?['id']?.toString(),
      );
      if (!mounted) return;
      await auth.setAuth(token: token, tokenType: auth.tokenType, user: user);
      if (!mounted) return;
      _syncControllers(user);
      setState(() {
        _user = user;
        _loading = false;
        _error = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await auth.clear();
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
        return;
      }
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = context.read<AuthProvider>();
    final token = auth.token;
    final userId = (_user?['id'] ?? auth.user?['id'])?.toString();
    if (token == null || token.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please sign in again.')),
      );
      await auth.clear();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    final payload = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
    };

    // Add password if user filled it in
    if (_passwordController.text.trim().isNotEmpty) {
      payload['password'] = _passwordController.text.trim();
    }

    try {
      final updated = await _api.updateUser(
        token: token,
        tokenType: auth.tokenType,
        userId: userId,
        payload: payload,
        currentUser: _user,
      );
      if (!mounted) return;
      await auth.setAuth(
        token: token,
        tokenType: auth.tokenType,
        user: updated,
      );
      if (!mounted) return;
      _syncControllers(updated);
      setState(() {
        _user = updated;
        _saving = false;
        _error = null;
      });
      
      // Clear password fields after successful update
      _passwordController.clear();
      _confirmPasswordController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await auth.clear();
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
        return;
      }
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _syncControllers(Map<String, dynamic> user) {
    final name = user['name']?.toString() ?? '';
    final email = user['email']?.toString() ?? '';
    if (_nameController.text != name) {
      _nameController.text = name;
    }
    if (_emailController.text != email) {
      _emailController.text = email;
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 3) {
      return 'Name should be at least 3 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    // Password is optional, so if empty it's valid
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    // But if they start typing, it must be at least 8 characters
    if (value.trim().length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    // Only validate if password field has content
    if (_passwordController.text.trim().isEmpty) {
      return null;
    }
    
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value.trim() != _passwordController.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _saving ? null : () => _refreshProfile(forceLoading: true),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(colorScheme, textTheme),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, TextTheme textTheme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () => _refreshProfile(forceLoading: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    final initials = _initialsFromName(_nameController.text);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: colorScheme.primary.withOpacity(0.18),
              child: Text(
                initials,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _nameController.text.isEmpty
                  ? 'Your profile'
                  : _nameController.text,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 24),
                Text(
                  'Change Password (Optional)',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Leave blank to keep current password',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _saveProfile,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Saving...' : 'Save Changes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final initials = parts.map((p) => p[0].toUpperCase()).take(2).join();
    if (initials.isNotEmpty) return initials;
    return 'U';
  }
}