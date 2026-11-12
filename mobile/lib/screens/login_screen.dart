import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/tokens.dart';
import '../widgets/spatial_glass_card.dart';

class LoginScreen extends StatefulWidget {
  final HermesAppState appState;

  const LoginScreen({super.key, required this.appState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'pro@hermes.ai');
  final _passCtrl = TextEditingController(text: 'password123');
  bool _obscurePass = true;
  bool _loading = false;

  Future<void> _handleLogin() async {
    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    final email = _emailCtrl.text.trim();
    await widget.appState.apiClient.login(email, _passCtrl.text);
    String targetRole = 'pro_creator';
    if (email.startsWith('admin')) targetRole = 'superadmin';
    if (email.startsWith('member')) targetRole = 'consumer';
    if (email.startsWith('guest')) targetRole = 'guest';
    widget.appState.loginWithRole(targetRole);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkTheme;
    return Scaffold(
      backgroundColor:
          isDark ? VisionTokens.bgSpatialCanvas : VisionTokens.bgAlabasterCanvas,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.6),
            radius: 1.2,
            colors: [
              VisionTokens.accentCyan.withOpacity(isDark ? 0.16 : 0.12),
              VisionTokens.accentIndigo.withOpacity(isDark ? 0.10 : 0.06),
              isDark
                  ? VisionTokens.bgSpatialCanvas
                  : VisionTokens.bgAlabasterCanvas,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: VisionTokens.prismGradient,
                      boxShadow: [
                        BoxShadow(
                          color: VisionTokens.accentCyan.withOpacity(0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'HERMES SUPER AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    color: isDark
                        ? VisionTokens.textPrimary
                        : VisionTokens.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'VisionOS Spatial Multimodal Suite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? VisionTokens.textSecondary
                        : VisionTokens.textDarkSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                SpatialGlassCard(
                  isDark: isDark,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Masuk ke Workspace',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? VisionTokens.textPrimary
                              : VisionTokens.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.alternate_email, size: 18),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 18),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() => _obscurePass = !_obscurePass);
                            },
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VisionTokens.accentCyan,
                            foregroundColor: VisionTokens.bgSpatialCanvas,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text(
                                  'Masuk Sekarang',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'QUICK DEMO ROLE LAUNCHER (1-KLIK)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: isDark
                        ? VisionTokens.textSecondary
                        : VisionTokens.textDarkSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: HermesAppState.roles.values.map((r) {
                    return ActionChip(
                      avatar: null,
                      label: Text(
                        r.badge,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: isDark
                          ? VisionTokens.bgGraphiteSurface
                          : Colors.white,
                      side: BorderSide(
                        color: VisionTokens.accentCyan.withOpacity(0.35),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        widget.appState.loginWithRole(r.slug);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
