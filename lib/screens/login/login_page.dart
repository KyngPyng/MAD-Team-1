import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../data/app_session_service.dart';
import '../../data/local_auth_service.dart';
import '../../widgets/glass_textfield.dart';
import '../register/register_page.dart';
import '../main_navigation_page.dart';
import '../../widgets/google_button.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/logo_card.dart';
import '../../widgets/background_wave.dart';
import '../../widgets/particle_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Roles match the dynamic string checks in ProfileScreen ('Learner' / 'Admin')
  String role = "Learner";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final session = await LocalAuthService.instance.authenticate(
      email: emailController.text.trim(),
      password: passwordController.text,
      fallbackRole: role,
    );

    if (!mounted) return;

    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No matching account found. Register first or use the demo login.',
          ),
        ),
      );
      return;
    }

    AppSessionService.instance.setCurrentUser(session);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationPage(),
        settings: RouteSettings(arguments: session.role),
      ),
    );
  }

  Future<void> _openRegistration() async {
    final result = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const RegistrationPage()));

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      emailController.text = result;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account saved. Sign in now.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _LoginBackdrop(),
          const ParticleBackground(),
          const BackgroundWave(),

          SafeArea(
            child: Column(
              children: [
                Expanded(
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
                                    color: AppColors.primary.withValues(
                                      alpha: .18,
                                    ),
                                    blurRadius: 36,
                                    offset: const Offset(0, 18),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const LogoCard(),
                                  const SizedBox(height: 28),
                                  Text(
                                    "Welcome Back",
                                    style: AppTextStyles.heading,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Sign in to continue",
                                    style: AppTextStyles.subtitle,
                                  ),
                                  const SizedBox(height: 32),

                                  // Animated Role Selector Pill
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final width = constraints.maxWidth;
                                      final isStudent = role == "Learner";

                                      return Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Sliding background selector highlight
                                            AnimatedPositioned(
                                              duration: const Duration(
                                                milliseconds: 250,
                                              ),
                                              curve: Curves.easeInOutCubic,
                                              left: isStudent ? 4 : (width / 2),
                                              top: 4,
                                              bottom: 4,
                                              width: (width / 2) - 4,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.08,
                                                          ),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Interactive text overlay options
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () => setState(
                                                      () => role = "Learner",
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    child: Center(
                                                      child:
                                                          AnimatedDefaultTextStyle(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      200,
                                                                ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isStudent
                                                                  ? AppColors
                                                                        .primary
                                                                  : Colors
                                                                        .grey
                                                                        .shade700,
                                                            ),
                                                            child: const Text(
                                                              "Student",
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () => setState(
                                                      () => role = "Admin",
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    child: Center(
                                                      child:
                                                          AnimatedDefaultTextStyle(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      200,
                                                                ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: !isStudent
                                                                  ? AppColors
                                                                        .primary
                                                                  : Colors
                                                                        .grey
                                                                        .shade700,
                                                            ),
                                                            child: const Text(
                                                              "Admin",
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 18),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        GlassTextField(
                                          controller: emailController,
                                          hint: "Email",
                                          prefixIcon: Icons.email_outlined,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Email is required';
                                            }
                                            if (!value.contains('@')) {
                                              return 'Enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 18),
                                        GlassTextField(
                                          controller: passwordController,
                                          hint: "Password",
                                          prefixIcon: Icons.lock_outline,
                                          isPassword: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Password is required';
                                            }
                                            if (value.trim().length < 6) {
                                              return 'Use at least 6 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text("Forgot Password?"),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GradientButton(
                                    text: "Login",
                                    onPressed: _login,
                                  ),
                                  const SizedBox(height: 26),
                                  Row(
                                    children: const [
                                      Expanded(child: Divider()),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text("OR"),
                                      ),
                                      Expanded(child: Divider()),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  GoogleButton(onPressed: () {}),
                                  const SizedBox(height: 28),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Flexible(
                                        child: Text("Don't have an account? "),
                                      ),
                                      TextButton(
                                        onPressed: _openRegistration,
                                        child: const Text("Sign Up"),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBackdrop extends StatelessWidget {
  const _LoginBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9F8FF), Color(0xFFECEAFF), Color(0xFFDCD7FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -70,
            child: _Glow(color: AppColors.secondary.withValues(alpha: .38)),
          ),
          Positioned(
            bottom: 80,
            left: -100,
            child: _Glow(color: const Color(0xFFBFE9FF).withValues(alpha: .62)),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  const _Glow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
