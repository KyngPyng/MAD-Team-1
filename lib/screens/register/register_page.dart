import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../data/local_auth_service.dart';
import '../../widgets/background_wave.dart';
import '../../widgets/glass_textfield.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/logo_card.dart';
import '../../widgets/particle_background.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _role = 'Learner';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await LocalAuthService.instance.saveRegistration(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _role,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account saved locally for demo login.')),
    );
    Navigator.of(context).pop(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _RegistrationBackdrop(),
          const ParticleBackground(),
          const BackgroundWave(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .58),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: .18),
                              blurRadius: 36,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const LogoCard(),
                              const SizedBox(height: 28),
                              Text(
                                'Create Account',
                                style: AppTextStyles.heading,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Saved locally on this device for demo login.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.subtitle,
                              ),
                              const SizedBox(height: 24),
                              GlassTextField(
                                controller: _nameController,
                                hint: 'Full name',
                                prefixIcon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              GlassTextField(
                                controller: _emailController,
                                hint: 'Email',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              GlassTextField(
                                controller: _passwordController,
                                hint: 'Password',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.trim().length < 6) {
                                    return 'Use at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              GlassTextField(
                                controller: _confirmPasswordController,
                                hint: 'Confirm password',
                                prefixIcon: Icons.lock_reset_outlined,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _role,
                                decoration: const InputDecoration(
                                  labelText: 'Role',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Learner',
                                    child: Text('Learner'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Admin',
                                    child: Text('Admin'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _role = value);
                                  }
                                },
                              ),
                              const SizedBox(height: 24),
                              GradientButton(
                                text: 'Save Account',
                                icon: Icons.save_alt_rounded,
                                onPressed: _saveAccount,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationBackdrop extends StatelessWidget {
  const _RegistrationBackdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9F8FF), Color(0xFFECEAFF), Color(0xFFDCD7FF)],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
