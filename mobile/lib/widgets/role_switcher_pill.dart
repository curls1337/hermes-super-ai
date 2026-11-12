import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/tokens.dart';

class RoleSwitcherPill extends StatelessWidget {
  final HermesAppState appState;

  const RoleSwitcherPill({super.key, required this.appState});

  void _openRoleSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = appState.isDarkTheme;
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: isDark ? VisionTokens.bgGraphiteElevated : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: Colors.white.withOpacity(0.16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Text(
                'Quick Switch Role (RBAC Demo)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? VisionTokens.textPrimary
                      : VisionTokens.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...HermesAppState.roles.values.map((role) {
                final selected = role.slug == appState.activeRoleSlug;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: selected
                      ? VisionTokens.accentCyan.withOpacity(0.15)
                      : Colors.transparent,
                  title: Text(
                    role.badge,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: selected
                          ? VisionTokens.accentCyan
                          : (isDark
                              ? VisionTokens.textPrimary
                              : VisionTokens.textDarkPrimary),
                    ),
                  ),
                  subtitle: Text(
                    '${role.fullName} • ${role.videoResolution}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? VisionTokens.textSecondary
                          : VisionTokens.textDarkSecondary,
                    ),
                  ),
                  trailing: selected
                      ? const Icon(Icons.check_circle,
                          color: VisionTokens.accentCyan)
                      : null,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    appState.switchRole(role.slug);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openRoleSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            colors: [
              VisionTokens.accentCyan.withOpacity(0.22),
              VisionTokens.accentPurple.withOpacity(0.22),
            ],
          ),
          border: Border.all(
            color: VisionTokens.accentCyan.withOpacity(0.45),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appState.currentRole.badge,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: VisionTokens.accentCyan,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: VisionTokens.accentCyan,
            ),
          ],
        ),
      ),
    );
  }
}
