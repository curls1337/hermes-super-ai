import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/tokens.dart';
import '../widgets/spatial_glass_card.dart';

class ImageStudioScreen extends StatefulWidget {
  final HermesAppState appState;

  const ImageStudioScreen({super.key, required this.appState});

  @override
  State<ImageStudioScreen> createState() => _ImageStudioScreenState();
}

class _ImageStudioScreenState extends State<ImageStudioScreen> {
  final _promptCtrl = TextEditingController(
    text: 'kucing astronot di planet mars dengan helm kaca bercahaya neon',
  );

  final List<String> _quickIdeas = [
    '🐱 Kucing astronot neon di Mars',
    '🏰 Istana kaca melayang di awan',
    '🏎️ Mobil balap cyberpunk malam hari',
    '☕ Kedai kopi cozy di tengah hutan salju',
  ];

  void _openLightbox(GeneratedImageItem item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: SpatialGlassCard(
          isDark: true,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  item.url,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 260,
                    color: VisionTokens.bgGraphiteSurface,
                    child: const Icon(Icons.image, size: 48, color: Colors.white38),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.prompt,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                'Ratio ${item.ratio} • ${item.resolution} • Seed #${item.seed}',
                style: const TextStyle(color: VisionTokens.accentCyan, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Disimpan ke Photos / Camera Roll')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Save to Photos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VisionTokens.accentCyan,
                        foregroundColor: VisionTokens.bgSpatialCanvas,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkTheme;
    const ratios = ['1:1', '16:9', '9:16', '4:3'];
    const styleOptions = [
      {'id': 'auto', 'label': '✨ Auto'},
      {'id': 'photorealistic_8k', 'label': '📸 Photoreal'},
      {'id': 'visionos_cyber_glass', 'label': '🪟 VisionOS'},
      {'id': 'cyberpunk_neon', 'label': '🌆 Cyberpunk'},
      {'id': 'anime_studio', 'label': '🎨 Anime'},
    ];

    return RefreshIndicator(
      onRefresh: widget.appState.refreshServerData,
      color: VisionTokens.accentCyan,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Image Studio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : VisionTokens.textDarkPrimary,
                  ),
                ),
                Text(
                  'Diffusion Text-to-Image Multi-Rasio',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? VisionTokens.textSecondary
                        : VisionTokens.textDarkSecondary,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                _promptCtrl.text =
                    '${_promptCtrl.text.trim()}, volumetric lighting, 8K octane render, hyperminimalist';
              },
              icon: const Icon(Icons.auto_fix_high, size: 16),
              label: const Text('Magic Polish'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _quickIdeas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, idx) {
              final idea = _quickIdeas[idx];
              return ActionChip(
                label: Text(idea, style: const TextStyle(fontSize: 11)),
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.05),
                side: BorderSide(
                  color: VisionTokens.accentCyan.withOpacity(0.3),
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _promptCtrl.text = idea.substring(idea.indexOf(' ') + 1);
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SpatialGlassCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _promptCtrl,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: const InputDecoration(
                  hintText: 'Deskripsikan gambar sinematik...',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: ratios.map((r) {
                  final active = r == widget.appState.selectedRatio;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        widget.appState.setRatio(r);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: active
                              ? Colors.white
                              : Colors.white.withOpacity(0.06),
                          border: Border.all(
                            color: active
                                ? Colors.white
                                : Colors.white.withOpacity(0.14),
                          ),
                        ),
                        child: Text(
                          r,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: active
                                ? VisionTokens.bgSpatialCanvas
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: styleOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (_, idx) {
                    final opt = styleOptions[idx];
                    final active = widget.appState.selectedImageStyle == opt['id'];
                    return ChoiceChip(
                      label: Text(opt['label']!, style: const TextStyle(fontSize: 11)),
                      selected: active,
                      selectedColor: VisionTokens.accentCyan.withOpacity(0.25),
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        widget.appState.setImageStyle(opt['id']!);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: widget.appState.isGeneratingImage
                      ? null
                      : () async {
                          HapticFeedback.mediumImpact();
                          final err = await widget.appState.generateImage(_promptCtrl.text);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(err ?? '✅ Gambar AI berhasil dibuat!'),
                              backgroundColor: err != null ? Colors.red.shade700 : const Color(0xFF10B981),
                            ),
                          );
                        },
                  icon: const Icon(Icons.brush_rounded, size: 18),
                  label: Text(
                    widget.appState.isGeneratingImage
                        ? 'Synthesizing Diffusion...'
                        : 'Generate Visual Image',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VisionTokens.accentCyan,
                    foregroundColor: VisionTokens.bgSpatialCanvas,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.appState.isGeneratingImage) ...[
          const SizedBox(height: 14),
          SpatialGlassCard(
            isDark: isDark,
            child: const Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                SizedBox(width: 14),
                Text('Merender Neural Diffusion (Step 18/25)...'),
              ],
            ),
          ),
        ],
        if (widget.appState.imageFeedbackMsg != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: widget.appState.imageFeedbackIsError
                  ? Colors.red.withOpacity(0.16)
                  : Colors.green.withOpacity(0.16),
              border: Border.all(
                color: widget.appState.imageFeedbackIsError
                    ? Colors.redAccent
                    : Colors.greenAccent,
              ),
            ),
            child: Text(
              widget.appState.imageFeedbackMsg!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.appState.imageFeedbackIsError
                    ? Colors.redAccent
                    : Colors.greenAccent,
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),
        Text(
          'Koleksi Visual Studio',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : VisionTokens.textDarkPrimary,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: widget.appState.images.length,
          itemBuilder: (context, idx) {
            final img = widget.appState.images[idx];
            return GestureDetector(
              onTap: () => _openLightbox(img),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      img.url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: VisionTokens.bgGraphiteSurface,
                        child: const Icon(Icons.image, color: Colors.white38),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${img.ratio} • #${img.seed}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: VisionTokens.accentCyan,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            img.prompt,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
      ),
    );
  }
}
