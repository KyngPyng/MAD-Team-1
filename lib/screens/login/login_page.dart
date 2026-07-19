import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/glass_textfield.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Roles match the dynamic string checks in ProfileScreen ('Learner' / 'Admin')
  String role = "Learner"; 

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
                                    color: AppColors.primary.withValues(alpha: .18),
                                    blurRadius: 36,
                                    offset: const Offset(0, 18),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const LogoCard(),
                                  const SizedBox(height: 28),
                                  Text("Welcome Back", style: AppTextStyles.heading),
                                  const SizedBox(height: 8),
                                  Text("Sign in to continue", style: AppTextStyles.subtitle),
                                  const SizedBox(height: 32),

                                  // Animated Role Selector Pill
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final width = constraints.maxWidth;
                                      final isStudent = role == "Learner";

                                      return Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Sliding background selector highlight
                                            AnimatedPositioned(
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeInOutCubic,
                                              left: isStudent ? 4 : (width / 2),
                                              top: 4,
                                              bottom: 4,
                                              width: (width / 2) - 4,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.08),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 2),
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
                                                    onTap: () => setState(() => role = "Learner"),
                                                    borderRadius: BorderRadius.circular(14),
                                                    child: Center(
                                                      child: AnimatedDefaultTextStyle(
                                                        duration: const Duration(milliseconds: 200),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: isStudent ? AppColors.primary : Colors.grey.shade700,
                                                        ),
                                                        child: const Text("Student"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () => setState(() => role = "Admin"),
                                                    borderRadius: BorderRadius.circular(14),
                                                    child: Center(
                                                      child: AnimatedDefaultTextStyle(
                                                        duration: const Duration(milliseconds: 200),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: !isStudent ? AppColors.primary : Colors.grey.shade700,
                                                        ),
                                                        child: const Text("Admin"),
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
                                  GlassTextField(
                                    controller: emailController,
                                    hint: "Email",
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 18),
                                  GlassTextField(
                                    controller: passwordController,
                                    hint: "Password",
                                    prefixIcon: Icons.lock_outline,
                                    isPassword: true,
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
                                    onPressed: () {
                                      // Passes the current selected role forward into the navigation context stack
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MainNavigationPage(),
                                          settings: RouteSettings(arguments: role),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 26),
                                  Row(
                                    children: const [
                                      Expanded(child: Divider()),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
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
                                        onPressed: () {},
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