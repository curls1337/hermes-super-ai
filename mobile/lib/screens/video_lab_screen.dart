import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/tokens.dart';
import '../widgets/spatial_glass_card.dart';

class VideoLabScreen extends StatefulWidget {
  final HermesAppState appState;

  const VideoLabScreen({super.key, required this.appState});

  @override
  State<VideoLabScreen> createState() => _VideoLabScreenState();
}

class _VideoLabScreenState extends State<VideoLabScreen> {
  final _storyCtrl = TextEditingController(
    text:
        'Peluncuran Hermes Super AI: 5 Pilar Kecerdasan Spasial dalam Estetika VisionOS Glassmorphism.',
  );
  String _voicePair = 'Fola & Brio (Dual-Speaker)';
  String _visualMedium = 'WebGL Spatial';
  bool _isPlaying = false;
  double _scrubProgress = 0.35;
  Timer? _playTimer;

  @override
  void dispose() {
    _playTimer?.cancel();
    _storyCtrl.dispose();
    super.dispose();
  }

  void _togglePlay() {
    HapticFeedback.selectionClick();
    setState(() => _isPlaying = !_isPlaying);
    _playTimer?.cancel();
    if (_isPlaying) {
      _playTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _scrubProgress += 0.01;
          if (_scrubProgress >= 1.0) {
            _scrubProgress = 0.0;
            _isPlaying = false;
            timer.cancel();
          }
        });
      });
    }
  }

  void _openAddBeatSheet() {
    final titleCtrl = TextEditingController();
    final scriptCtrl = TextEditingController();
    String speaker = _voicePair.contains('Fola')
        ? 'Fola (Narrator)'
        : 'Alpha Male (Ardi)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = widget.appState.isDarkTheme;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            decoration: BoxDecoration(
              color: isDark ? VisionTokens.bgGraphiteElevated : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tambah Adegan Storyboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? VisionTokens.textPrimary
                        : VisionTokens.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleCtrl,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Judul Adegan',
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: scriptCtrl,
                  maxLines: 2,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Naskah Narasi Dialog ($speaker)',
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {
                    if (titleCtrl.text.trim().isNotEmpty &&
                        scriptCtrl.text.trim().isNotEmpty) {
                      HapticFeedback.selectionClick();
                      widget.appState.addStoryboardBeat(
                        titleCtrl.text.trim(),
                        speaker,
                        scriptCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VisionTokens.accentCyan,
                    foregroundColor: VisionTokens.bgSpatialCanvas,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Adegan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkTheme;
    final policy = widget.appState.currentRole;
    const mediums = ['WebGL Spatial', 'Editorial 60fps', 'Cinema Noir'];
    const voices = [
      'Fola & Brio (Dual-Speaker)',
      'Ardi & Gadis (ID Neural)',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Video Lab',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? Colors.white : VisionTokens.textDarkPrimary,
                  ),
                ),
                Text(
                  'Remotion React Engine 60 FPS • Dual-Speaker',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? VisionTokens.textSecondary
                        : VisionTokens.textDarkSecondary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: VisionTokens.accentPurple.withOpacity(0.2),
                border: Border.all(
                  color: VisionTokens.accentPurple.withOpacity(0.4),
                ),
              ),
              child: Text(
                policy.videoResolution,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: VisionTokens.accentPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Remotion Canvas Simulated Player Card
        SpatialGlassCard(
          isDark: isDark,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const RadialGradient(
                    center: Alignment(0.0, -0.3),
                    radius: 1.1,
                    colors: [
                      Color(0xFF1E1B4B),
                      Color(0xFF0F172A),
                      Color(0xFF030712),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$_visualMedium • ${policy.videoWatermark ? "Watermark" : "Clean Export"}',
                              style: const TextStyle(
                                  fontSize: 10, color: VisionTokens.accentCyan),
                            ),
                          ),
                          const Text(
                            '00:14.2 / 00:30.0',
                            style:
                                TextStyle(fontSize: 10, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _voicePair.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: VisionTokens.accentCyan,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isPlaying
                                ? '"Implementasi VisionOS Glassmorphism pada Remotion menggabungkan BackdropFilter blur(40px)..."'
                                : '"Selamat datang di era baru kecerdasan spasial. Ini adalah Hermes Super AI."',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _speakerBadge('🎙️ Fola / Ardi', true),
                              const SizedBox(width: 6),
                              _speakerBadge('🎙️ Brio / Gadis', false),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Slider(
                value: _scrubProgress,
                activeColor: VisionTokens.accentCyan,
                onChanged: (val) {
                  setState(() => _scrubProgress = val);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(_isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled),
                        color: VisionTokens.accentCyan,
                        iconSize: 34,
                        onPressed: _togglePlay,
                      ),
                      Text(
                        _isPlaying ? 'Playing 60fps' : 'Preview Remotion',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: widget.appState.isRenderingVideo
                        ? null
                        : () {
                            HapticFeedback.mediumImpact();
                            widget.appState.startVideoRender();
                          },
                    icon: const Icon(Icons.movie_creation_outlined, size: 16),
                    label: Text(
                      widget.appState.isRenderingVideo
                          ? 'Rendering...'
                          : 'Render MP4',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VisionTokens.accentPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (widget.appState.isRenderingVideo) ...[
          const SizedBox(height: 14),
          SpatialGlassCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rendering Headless Chromium MP4...',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${(widget.appState.videoRenderProgress * 100).toInt()}%',
                      style: const TextStyle(
                          fontSize: 12, color: VisionTokens.accentCyan),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: widget.appState.videoRenderProgress,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation(VisionTokens.accentCyan),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 14),

        // Story Prompt & Options
        SpatialGlassCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Story Prompt',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? VisionTokens.textSecondary
                      : VisionTokens.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _storyCtrl,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: const InputDecoration(
                  hintText: 'Tulis konsep cerita video...',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Visual Medium',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? VisionTokens.textSecondary
                      : VisionTokens.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: mediums.map((m) {
                  final active = m == _visualMedium;
                  return ChoiceChip(
                    label: Text(
                      m,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: active
                            ? VisionTokens.bgSpatialCanvas
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    selected: active,
                    selectedColor: VisionTokens.accentCyan,
                    backgroundColor: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.05),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _visualMedium = m);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text(
                'Dual-Speaker Voice Pair',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? VisionTokens.textSecondary
                      : VisionTokens.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: voices.map((v) {
                  final active = v == _voicePair;
                  return ChoiceChip(
                    label: Text(
                      v,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: active
                            ? VisionTokens.bgSpatialCanvas
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    selected: active,
                    selectedColor: VisionTokens.accentViolet,
                    backgroundColor: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.05),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _voicePair = v);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Storyboard Beats (${widget.appState.beats.length} Scene)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : VisionTokens.textDarkPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: VisionTokens.accentCyan),
              onPressed: _openAddBeatSheet,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.appState.beats.map((b) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: SpatialGlassCard(
              isDark: isDark,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: VisionTokens.accentCyan.withOpacity(0.15),
                    ),
                    child: Center(
                      child: Text(
                        '#${b.beat}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: VisionTokens.accentCyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              b.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : VisionTokens.textDarkPrimary,
                              ),
                            ),
                            Text(
                              b.timeRange,
                              style: const TextStyle(
                                fontSize: 10,
                                color: VisionTokens.accentCyan,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          b.script,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? VisionTokens.textSecondary
                                : VisionTokens.textDarkSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _speakerBadge(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: active
            ? VisionTokens.accentCyan.withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active
              ? VisionTokens.accentCyan
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}
