import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/tokens.dart';
import '../widgets/spatial_glass_card.dart';

class ChatScreen extends StatefulWidget {
  final HermesAppState appState;

  const ChatScreen({super.key, required this.appState});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _promptCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  void _send() {
    if (_promptCtrl.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    widget.appState.sendChatMessage(_promptCtrl.text);
    _promptCtrl.clear();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkTheme;
    final policy = widget.appState.currentRole;

    return Column(
      children: [
        // Specialist Agent Horizontal Bar
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            itemCount: HermesAppState.agents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final ag = HermesAppState.agents[idx];
              final isActive = ag.id == widget.appState.activeAgentId;
              final isLocked = !policy.canSwitchAgents && ag.id != 'general';

              return GestureDetector(
                onTap: () {
                  if (isLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Agen Spesialis memerlukan peran Pro Creator atau Superadmin.'),
                      ),
                    );
                    return;
                  }
                  HapticFeedback.selectionClick();
                  widget.appState.selectAgent(ag.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: isActive
                        ? VisionTokens.accentCyan.withOpacity(0.20)
                        : (isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.05)),
                    border: Border.all(
                      color: isActive
                          ? VisionTokens.accentCyan
                          : Colors.white.withOpacity(0.14),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(ag.icon, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Text(
                        ag.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? VisionTokens.accentCyan
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.lock_outline, size: 12),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Chat Stream Area
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            itemCount: widget.appState.messages.length,
            itemBuilder: (context, idx) {
              final msg = widget.appState.messages[idx];
              if (msg.isUser) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12, left: 48),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? VisionTokens.bgGraphiteSurface
                          : VisionTokens.accentIndigo,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(6),
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.14)),
                    ),
                    child: Text(
                      msg.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                );
              }

              final ag = HermesAppState.agents.firstWhere(
                (a) => a.id == msg.agentId,
                orElse: () => HermesAppState.agents.first,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 14, right: 24),
                child: SpatialGlassCard(
                  isDark: isDark,
                  padding: const EdgeInsets.all(14),
                  borderRadius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(ag.icon, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            ag.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: VisionTokens.accentCyan,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: msg.content));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Teks disalin ke clipboard')),
                              );
                            },
                            child: Icon(
                              Icons.copy_rounded,
                              size: 14,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        msg.content.isEmpty ? 'Sedang berpikir...' : msg.content,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark
                              ? VisionTokens.textPrimary
                              : VisionTokens.textDarkPrimary,
                        ),
                      ),
                      if (msg.citations.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: msg.citations.map((c) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    VisionTokens.accentCyan.withOpacity(0.12),
                                border: Border.all(
                                  color:
                                      VisionTokens.accentCyan.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                '🌐 $c',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: VisionTokens.accentCyan,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Prompt Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.appState.toggleWebSearch();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: widget.appState.webSearchEnabled
                            ? VisionTokens.accentCyan.withOpacity(0.2)
                            : Colors.white.withOpacity(0.06),
                        border: Border.all(
                          color: widget.appState.webSearchEnabled
                              ? VisionTokens.accentCyan.withOpacity(0.5)
                              : Colors.white.withOpacity(0.14),
                        ),
                      ),
                      child: Text(
                        widget.appState.webSearchEnabled
                            ? '🌐 Web Search: ON'
                            : '🌐 Web Search: OFF',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.appState.webSearchEnabled
                              ? VisionTokens.accentCyan
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'SSE Streaming Ready',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : Colors.black45,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SpatialGlassCard(
                isDark: isDark,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                borderRadius: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promptCtrl,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Tanya Hermes Super AI...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: VisionTokens.prismGradient,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
