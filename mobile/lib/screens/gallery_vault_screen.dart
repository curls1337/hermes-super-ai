import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/tokens.dart';
import '../widgets/spatial_glass_card.dart';

class GalleryVaultScreen extends StatefulWidget {
  final HermesAppState appState;

  const GalleryVaultScreen({super.key, required this.appState});

  @override
  State<GalleryVaultScreen> createState() => _GalleryVaultScreenState();
}

class _GalleryVaultScreenState extends State<GalleryVaultScreen> {
  final _urlCtrl = TextEditingController(text: 'http://localhost:3000/api/v1');

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkTheme;
    final role = widget.appState.currentRole;
    const filters = ['all', 'image', 'video', 'audio', 'fav'];

    final filteredItems = widget.appState.vaultItems.where((it) {
      if (widget.appState.vaultFilter == 'all') return true;
      if (widget.appState.vaultFilter == 'fav') return it.isFavorite;
      return it.type == widget.appState.vaultFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // User Profile Bento Card
        SpatialGlassCard(
          isDark: isDark,
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: VisionTokens.accentCyan,
                child: Text(
                  role.fullName.substring(0, 1),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: VisionTokens.bgSpatialCanvas,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.fullName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      role.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quota: ${(role.quotaTokens / 1000).toInt()}k TKN • ${role.quotaRenders} Renders',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: VisionTokens.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Unified Vault Filter Chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Unified Media Vault',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : VisionTokens.textDarkPrimary,
              ),
            ),
            Text(
              '${filteredItems.length} Aset',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((f) {
              final active = f == widget.appState.vaultFilter;
              final label = f == 'fav' ? '⭐ FAV' : f.toUpperCase();
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.appState.setVaultFilter(f);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: active
                          ? VisionTokens.accentCyan
                          : (isDark
                              ? Colors.white.withOpacity(0.06)
                              : Colors.black.withOpacity(0.05)),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
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
        ),
        const SizedBox(height: 12),

        if (filteredItems.isEmpty)
          SpatialGlassCard(
            isDark: isDark,
            child: Column(
              children: [
                const Icon(Icons.auto_awesome_mosaic_outlined,
                    size: 32, color: VisionTokens.accentCyan),
                const SizedBox(height: 8),
                Text(
                  'Belum ada aset pada filter ini.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          )
        else
          ...filteredItems.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: SpatialGlassCard(
                isDark: isDark,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.thumbUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 52,
                          height: 52,
                          color: VisionTokens.bgGraphiteSurface,
                          child: const Icon(Icons.perm_media_outlined,
                              size: 20, color: Colors.white38),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            item.detail,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        item.isFavorite ? Icons.star : Icons.star_border,
                        color: item.isFavorite
                            ? VisionTokens.colorWarning
                            : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        widget.appState.toggleFavorite(item.id);
                      },
                    ),
                    if (role.canDeleteVault)
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: VisionTokens.colorDanger, size: 20),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.appState.deleteVaultItem(item.id);
                        },
                      ),
                  ],
                ),
              ),
            );
          }),

        const SizedBox(height: 18),
        Text(
          'Cloud Sync & Server Endpoint',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : VisionTokens.textDarkPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SpatialGlassCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: VisionTokens.colorSuccess,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cloud Vault Synced • Local Cache Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlCtrl,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: const InputDecoration(
                  labelText: 'Backend Bridge API Base URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  widget.appState.testBackendPing(_urlCtrl.text);
                },
                icon: const Icon(Icons.network_check_rounded, size: 16),
                label: const Text('Uji Latensi Server (Ping)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: VisionTokens.accentCyan,
                  foregroundColor: VisionTokens.bgSpatialCanvas,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.appState.pingStatus,
                style: const TextStyle(
                  fontSize: 11,
                  color: VisionTokens.accentCyan,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        SpatialGlassCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.phone_iphone_rounded,
                      size: 18, color: VisionTokens.accentCyan),
                  const SizedBox(width: 8),
                  Text(
                    'Mobile Sideload & Release Build',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'HermesSuperAI-iOS-sideload.ipa • HermesSuperAI-release.apk (v1.0.0+104)',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        SpatialGlassCard(
          isDark: isDark,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Tema Antarmuka (VisionOS)'),
                subtitle: Text(isDark
                    ? 'Graphite Frost (OLED Dark)'
                    : 'VisionOS White (Alabaster Light)'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) {
                    HapticFeedback.selectionClick();
                    widget.appState.toggleTheme();
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded,
                    color: VisionTokens.colorDanger),
                title: const Text('Keluar dari Akun'),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.appState.logout();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
