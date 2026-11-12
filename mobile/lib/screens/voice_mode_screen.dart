import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/tokens.dart';
import '../widgets/orb_visualizer.dart';
import '../widgets/spatial_glass_card.dart';

class VoiceModeScreen extends StatefulWidget {
  final HermesAppState appState;

  const VoiceModeScreen({super.key, required this.appState});

  @override
  State<VoiceModeScreen> createState() => _VoiceModeScreenState();
}

class _VoiceModeScreenState extends State<VoiceModeScreen> {
  final _inputCtrl = TextEditingController();
  bool _isMuted = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final isDark = appState.isDarkTheme;

    String stateLabel = '⚪ IDLE / READY';
    Color stateColor = Colors.grey;
    if (_isMuted) {
      stateLabel = '🔇 MIC MUTED';
      stateColor = VisionTokens.colorWarning;
    } else if (appState.voiceState == 'listening') {
      stateLabel = '🟢 LISTENING';
      stateColor = VisionTokens.colorSuccess;
    } else if (appState.voiceState == 'thinking') {
      stateLabel = '🟣 THINKING';
      stateColor = VisionTokens.accentPurple;
    } else if (appState.voiceState == 'speaking') {
      stateLabel = '🔵 SPEAKING';
      stateColor = VisionTokens.accentCyan;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: stateColor.withOpacity(0.18),
                        border: Border.all(color: stateColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        stateLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: stateColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hands-Free Conversational Duplex • VAD 750ms',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? VisionTokens.textSecondary
                            : VisionTokens.textDarkSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Central 3D Spatial Orb
                Center(
                  child: SpatialOrbVisualizer(
                    state: _isMuted ? 'idle' : appState.voiceState,
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 16),

                // Transcript HUD & Voice Control Dock
                Column(
                  children: [
                    SpatialGlassCard(
                      isDark: isDark,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'LIVE SYNCHRONIZED TRANSCRIPT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: VisionTokens.accentCyan,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isMuted
                                ? '"Mikrofon dibisukan sementara. Ketuk ikon mic untuk melanjutkan."'
                                : '"${appState.voiceTranscript}"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                              color: isDark
                                  ? VisionTokens.textPrimary
                                  : VisionTokens.textDarkPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _inputCtrl,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Bicara lewat mic atau ketik di sini...',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (val) {
                                if (val.trim().isNotEmpty) {
                                  _inputCtrl.clear();
                                  appState.sendVoiceQuery(val.trim());
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send_rounded, size: 18, color: VisionTokens.accentCyan),
                            onPressed: () {
                              final text = _inputCtrl.text.trim();
                              if (text.isNotEmpty) {
                                _inputCtrl.clear();
                                appState.sendVoiceQuery(text);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Mute / Unmute Secondary Button
                        _dockSecondaryButton(
                          icon: _isMuted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          tooltip: _isMuted ? 'Unmute Mic' : 'Mute Mic',
                          isDark: isDark,
                          active: _isMuted,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _isMuted = !_isMuted);
                            appState.setVoiceMuted(_isMuted);
                          },
                        ),
                        const SizedBox(width: 20),

                        // Primary Spatial Mic Button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            if (_isMuted) {
                              setState(() => _isMuted = false);
                            }
                            appState.toggleVoiceState();
                          },
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: VisionTokens.prismGradient,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      VisionTokens.accentCyan.withOpacity(0.4),
                                  blurRadius: 28,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              appState.voiceState == 'idle'
                                  ? Icons.mic_rounded
                                  : Icons.pause_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // End Voice Session -> Back to Chat
                        _dockSecondaryButton(
                          icon: Icons.close_rounded,
                          tooltip: 'Akhiri Sesi Suara',
                          isDark: isDark,
                          active: false,
                          isDanger: true,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            if (appState.voiceState != 'idle') {
                              appState.toggleVoiceState();
                            }
                            appState.setTab(0);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dockSecondaryButton({
    required IconData icon,
    required String tooltip,
    required bool isDark,
    required bool active,
    bool isDanger = false,
    required VoidCallback onTap,
  }) {
    final color = isDanger
        ? VisionTokens.colorDanger
        : (active
            ? VisionTokens.colorWarning
            : (isDark ? Colors.white70 : Colors.black87));

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDanger
                ? VisionTokens.colorDanger.withOpacity(0.14)
                : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06)),
            border: Border.all(
              color: isDanger
                  ? VisionTokens.colorDanger.withOpacity(0.35)
                  : (active
                      ? VisionTokens.colorWarning
                      : Colors.white.withOpacity(0.18)),
            ),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
