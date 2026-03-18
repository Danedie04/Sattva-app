import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../core/theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey            = GlobalKey<FormState>();

  bool _isLogin         = true;
  bool _loading         = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _errorMessage = null; });
    try {
      if (_isLogin) {
        await AuthService.signIn(
            email: _emailController.text, password: _passwordController.text);
      } else {
        await AuthService.signUp(
            email: _emailController.text, password: _passwordController.text);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _continueAnonymously() async {
    setState(() { _loading = true; _errorMessage = null; });
    await AuthService.signInAnonymously();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ambient glow background
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppTheme.accentGlow.withOpacity(0.15), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo
                      Animate(
                        effects: [FadeEffect(duration: 600.ms), ScaleEffect(duration: 600.ms)],
                        child: Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [AppTheme.accentGlow.withOpacity(0.4), AppTheme.bg],
                            ),
                            border: Border.all(
                                color: AppTheme.accent.withOpacity(0.4), width: 1.5),
                          ),
                          child: const Center(
                              child: Text("🪷", style: TextStyle(fontSize: 32))),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Animate(
                        effects: [FadeEffect(delay: 150.ms, duration: 500.ms)],
                        child: Text(
                          "SATTVA",
                          style: GoogleFonts.cormorantGaramond(
                            color: AppTheme.textPrimary,
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Animate(
                        effects: [FadeEffect(delay: 250.ms, duration: 500.ms)],
                        child: Text(
                          "your daily discipline companion",
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Toggle pill
                      Animate(
                        effects: [FadeEffect(delay: 350.ms, duration: 400.ms)],
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            children: [
                              _toggleBtn("Sign In", _isLogin, () => setState(() { _isLogin = true; _errorMessage = null; })),
                              _toggleBtn("Create Account", !_isLogin, () => setState(() { _isLogin = false; _errorMessage = null; })),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      Animate(
                        effects: [FadeEffect(delay: 400.ms), SlideEffect(begin: const Offset(0, 0.1), delay: 400.ms)],
                        child: _inputField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Email required';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Password
                      Animate(
                        effects: [FadeEffect(delay: 450.ms), SlideEffect(begin: const Offset(0, 0.1), delay: 450.ms)],
                        child: _inputField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppTheme.textMuted, size: 18,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password required';
                            if (v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Error
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(_errorMessage!,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12),
                              textAlign: TextAlign.center),
                        ),

                      const SizedBox(height: 8),

                      // CTA button
                      Animate(
                        effects: [FadeEffect(delay: 500.ms)],
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.accent, AppTheme.accentGlow],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentGlow.withOpacity(0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 20, height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : Text(
                                      _isLogin ? "Sign In" : "Create Account",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Divider(color: AppTheme.border),
                      const SizedBox(height: 12),

                      // Anonymous
                      TextButton.icon(
                        onPressed: _loading ? null : _continueAnonymously,
                        icon: Icon(Icons.person_outline_rounded,
                            color: AppTheme.textMuted, size: 16),
                        label: Text(
                          "Continue without account",
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: active ? AppTheme.accentGlow.withOpacity(0.25) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? AppTheme.accent : AppTheme.textMuted,
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
        prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 18),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppTheme.card,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.accent.withOpacity(0.5))),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
      validator: validator,
    );
  }
}


