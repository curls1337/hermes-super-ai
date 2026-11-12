import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../services/api_client.dart';

class RoleProfile {
  final String slug;
  final String name;
  final String badge;
  final String fullName;
  final String email;
  final int quotaTokens;
  final int quotaRenders;
  final bool canSwitchAgents;
  final bool canEditSettings;
  final bool canDeleteVault;
  final bool videoWatermark;
  final String videoResolution;

  const RoleProfile({
    required this.slug,
    required this.name,
    required this.badge,
    required this.fullName,
    required this.email,
    required this.quotaTokens,
    required this.quotaRenders,
    required this.canSwitchAgents,
    required this.canEditSettings,
    required this.canDeleteVault,
    required this.videoWatermark,
    required this.videoResolution,
  });
}

class SpecialistAgent {
  final String id;
  final String name;
  final String role;
  final String icon;
  final bool isPro;

  const SpecialistAgent({
    required this.id,
    required this.name,
    required this.role,
    required this.icon,
    required this.isPro,
  });
}

class ChatMessageItem {
  final String id;
  final bool isUser;
  final String agentId;
  String content;
  final String timestamp;
  final List<String> citations;

  ChatMessageItem({
    required this.id,
    required this.isUser,
    this.agentId = 'general',
    required this.content,
    required this.timestamp,
    this.citations = const [],
  });
}

class GeneratedImageItem {
  final String id;
  final String prompt;
  final String ratio;
  final String style;
  final String resolution;
  final int seed;
  final String url;

  GeneratedImageItem({
    required this.id,
    required this.prompt,
    required this.ratio,
    required this.style,
    required this.resolution,
    required this.seed,
    required this.url,
  });
}

class StoryboardBeat {
  final int beat;
  final String title;
  final String timeRange;
  final String speaker;
  final String script;

  StoryboardBeat({
    required this.beat,
    required this.title,
    required this.timeRange,
    required this.speaker,
    required this.script,
  });
}

class VaultMediaItem {
  final String id;
  final String title;
  final String type; // 'image', 'video', 'audio'
  final String detail;
  final String thumbUrl;
  bool isFavorite;

  VaultMediaItem({
    required this.id,
    required this.title,
    required this.type,
    required this.detail,
    required this.thumbUrl,
    this.isFavorite = false,
  });
}

class HermesAppState extends ChangeNotifier {
  static const Map<String, RoleProfile> roles = {
    'superadmin': RoleProfile(
      slug: 'superadmin',
      name: 'Superadmin / Owner',
      badge: '👑 SUPERADMIN',
      fullName: 'Lead System Architect',
      email: 'admin@hermes.ai',
      quotaTokens: 1000000,
      quotaRenders: 500,
      canSwitchAgents: true,
      canEditSettings: true,
      canDeleteVault: true,
      videoWatermark: false,
      videoResolution: '1080p 60fps',
    ),
    'pro_creator': RoleProfile(
      slug: 'pro_creator',
      name: 'Pro Creator',
      badge: '⚡ PRO CREATOR',
      fullName: 'Elena Rostova (Pro Creator)',
      email: 'pro@hermes.ai',
      quotaTokens: 500000,
      quotaRenders: 100,
      canSwitchAgents: true,
      canEditSettings: true,
      canDeleteVault: true,
      videoWatermark: false,
      videoResolution: '1080p 60fps',
    ),
    'consumer': RoleProfile(
      slug: 'consumer',
      name: 'Consumer / Member',
      badge: '🛍️ CONSUMER',
      fullName: 'Kenji Sato (Consumer)',
      email: 'member@hermes.ai',
      quotaTokens: 50000,
      quotaRenders: 10,
      canSwitchAgents: false,
      canEditSettings: false,
      canDeleteVault: true,
      videoWatermark: true,
      videoResolution: '720p Watermark',
    ),
    'guest': RoleProfile(
      slug: 'guest',
      name: 'Guest / Demo',
      badge: '🧪 GUEST DEMO',
      fullName: 'Guest Evaluator',
      email: 'guest@hermes.ai',
      quotaTokens: 5000,
      quotaRenders: 2,
      canSwitchAgents: false,
      canEditSettings: false,
      canDeleteVault: false,
      videoWatermark: true,
      videoResolution: '720p Sandbox',
    ),
  };

  static const List<SpecialistAgent> agents = [
    SpecialistAgent(
      id: 'general',
      name: 'Lead Orchestrator',
      role: 'Multi-Domain Reasoning',
      icon: '⚡',
      isPro: false,
    ),
    SpecialistAgent(
      id: 'tech_architect',
      name: 'Fullstack Architect',
      role: 'Systems, API & Mobile CI/CD',
      icon: '💻',
      isPro: true,
    ),
    SpecialistAgent(
      id: 'creative_director',
      name: 'Art & UX Director',
      role: 'VisionOS Spatial & Prompt Craft',
      icon: '🎨',
      isPro: true,
    ),
    SpecialistAgent(
      id: 'business_analyst',
      name: 'Business Analyst',
      role: 'KPI, ROI & Strategy Matrix',
      icon: '📊',
      isPro: true,
    ),
  ];

  final HermesApiClient apiClient = HermesApiClient();

  bool isAuthenticated = true;
  bool isDarkTheme = true;
  int currentTab = 0;
  String activeRoleSlug = 'superadmin';
  String activeAgentId = 'general';
  bool webSearchEnabled = true;

  // Studio
  String selectedRatio = '1:1';
  bool isGeneratingImage = false;

  // Video Lab
  bool isRenderingVideo = false;
  double videoRenderProgress = 0.0;

  // Voice Mode
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToText _speech = SpeechToText();
  bool _speechReady = false;
  bool isVoiceMuted = false;
  String voiceState = 'idle'; // idle, listening, thinking, speaking
  String voiceTranscript =
      'Ketuk tombol mikrofon di bawah untuk berbicara langsung dengan Hermes.';

  // Vault
  String vaultFilter = 'all';
  String pingStatus = 'Siap terhubung ke Hermes Bridge';

  final List<ChatMessageItem> messages = [
    ChatMessageItem(
      id: 'msg_001',
      isUser: true,
      content:
          'Bagaimana arsitektur glassmorphism VisionOS diimplementasikan pada canvas rendering Remotion?',
      timestamp: '10:42',
    ),
    ChatMessageItem(
      id: 'msg_002',
      isUser: false,
      agentId: 'tech_architect',
      content:
          'Implementasi VisionOS Glassmorphism pada Remotion menggabungkan BackdropFilter blur(40px), specular border reflection, dan shader refraksi Graphite Frost pada timeline 60fps dengan sintesis dual-speaker.',
      timestamp: '10:42',
      citations: ['developer.apple.com/visionos', 'remotion.dev/docs'],
    ),
  ];

  final List<GeneratedImageItem> images = [
    GeneratedImageItem(
      id: 'img_01',
      prompt:
          'Holographic AI sphere encased in graphite frost glass, VisionOS aesthetic',
      ratio: '16:9',
      style: 'VisionOS Glass',
      resolution: '1280x720',
      seed: 849201,
      url: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&q=80',
    ),
    GeneratedImageItem(
      id: 'img_02',
      prompt: 'Minimalist glass card dashboard with neon cyan specular borders',
      ratio: '1:1',
      style: 'Ultra Photoreal',
      resolution: '1024x1024',
      seed: 529143,
      url: 'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=800&q=80',
    ),
  ];

  final List<StoryboardBeat> beats = [
    StoryboardBeat(
      beat: 1,
      title: 'Hook Sinematik & Spatial Title',
      timeRange: '0s - 8s',
      speaker: 'Alpha Male (Ardi)',
      script:
          'Selamat datang di era baru kecerdasan spasial. Ini adalah Hermes Super AI.',
    ),
    StoryboardBeat(
      beat: 2,
      title: 'Penjelasan Fitur Terpadu',
      timeRange: '8s - 20s',
      speaker: 'Aria Female (Gadis)',
      script:
          'Konsolidasi 5 pilar AI: Chat SSE, Image Studio, Remotion Video 60fps, dan Voice Mode.',
    ),
    StoryboardBeat(
      beat: 3,
      title: 'Call to Action & Sideload Mobile',
      timeRange: '20s - 30s',
      speaker: 'Alpha Male (Ardi)',
      script:
          'Nikmati aplikasi native iOS IPA & Android APK dalam estetika Apple Spatial Glass.',
    ),
  ];

  final List<VaultMediaItem> vaultItems = [
    VaultMediaItem(
      id: 'vlt_01',
      title: 'VisionOS Spatial AI Orb',
      type: 'image',
      detail: 'Aspect 16:9 • Seed #849201 • PNG',
      thumbUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400&q=80',
      isFavorite: true,
    ),
    VaultMediaItem(
      id: 'vlt_02',
      title: 'Hermes Launch Teaser MP4',
      type: 'video',
      detail: '1080p 60fps • 30s • Dual-Speaker',
      thumbUrl:
          'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=400&q=80',
      isFavorite: true,
    ),
    VaultMediaItem(
      id: 'vlt_03',
      title: 'Transkrip Spatial Voice Architecture',
      type: 'audio',
      detail: '4m 12s • VAD 750ms • Duplex',
      thumbUrl:
          'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=400&q=80',
      isFavorite: false,
    ),
  ];

  RoleProfile get currentRole => roles[activeRoleSlug] ?? roles['guest']!;

  void loginWithRole(String slug) {
    activeRoleSlug = slug;
    if (!currentRole.canSwitchAgents) {
      activeAgentId = 'general';
    }
    isAuthenticated = true;
    apiClient.demoSwitch(slug);
    notifyListeners();
  }

  void switchRole(String slug) {
    if (!roles.containsKey(slug)) return;
    activeRoleSlug = slug;
    if (!currentRole.canSwitchAgents) {
      activeAgentId = 'general';
    }
    apiClient.demoSwitch(slug);
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    currentTab = 0;
    notifyListeners();
  }

  void setTab(int idx) {
    currentTab = idx;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  void selectAgent(String id) {
    if (!currentRole.canSwitchAgents && id != 'general') return;
    activeAgentId = id;
    notifyListeners();
  }

  void toggleWebSearch() {
    webSearchEnabled = !webSearchEnabled;
    notifyListeners();
  }

  Future<void> sendChatMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    messages.add(ChatMessageItem(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      isUser: true,
      content: trimmed,
      timestamp: 'Baru saja',
    ));

    final agent = agents.firstWhere(
      (a) => a.id == activeAgentId,
      orElse: () => agents.first,
    );

    final reply = ChatMessageItem(
      id: 'msg_ai_${DateTime.now().millisecondsSinceEpoch}',
      isUser: false,
      agentId: agent.id,
      content: '',
      timestamp: 'Baru saja',
      citations: webSearchEnabled ? ['Hermes Live AI Gateway'] : [],
    );
    messages.add(reply);
    notifyListeners();

    final historyPayload = messages
        .where((m) => m.content.trim().isNotEmpty)
        .map((m) => {
              'role': m.isUser ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();

    bool receivedAny = false;
    String? errMessage;

    await apiClient.streamChat(
      messages: historyPayload,
      agentPersona: agent.id,
      webSearchEnabled: webSearchEnabled,
      onDelta: (delta) {
        receivedAny = true;
        reply.content += delta;
        notifyListeners();
      },
      onError: (err) {
        errMessage = err;
      },
    );

    if (!receivedAny && reply.content.isEmpty) {
      reply.content = errMessage != null
          ? '⚠️ Tidak dapat terhubung ke server Hermes ($errMessage). Periksa koneksi internet atau URL Server di tab Vault.'
          : '⚠️ Tidak ada respons dari server. Coba kirim ulang.';
      notifyListeners();
    }
  }

  void setRatio(String r) {
    selectedRatio = r;
    notifyListeners();
  }

  Future<void> generateImage(String prompt) async {
    if (prompt.trim().isEmpty || isGeneratingImage) return;
    isGeneratingImage = true;
    notifyListeners();

    final res = await apiClient.generateImage(prompt.trim(), selectedRatio);
    isGeneratingImage = false;

    if (res['success'] == true && res['data'] != null) {
      final d = res['data'] as Map<String, dynamic>;
      final rawUrl = (d['imageUrl'] ?? '').toString();
      final fullUrl = apiClient.resolveMediaUrl(rawUrl);
      final seed = (d['seed'] is int) ? d['seed'] as int : 1024;

      images.insert(
        0,
        GeneratedImageItem(
          id: (d['id'] ?? 'img_${DateTime.now().millisecondsSinceEpoch}').toString(),
          prompt: prompt.trim(),
          ratio: (d['aspectRatio'] ?? selectedRatio).toString(),
          style: 'VisionOS Spatial AI',
          resolution: (d['resolution'] ?? '1024x1024').toString(),
          seed: seed,
          url: fullUrl,
        ),
      );
      vaultItems.insert(
        0,
        VaultMediaItem(
          id: 'vlt_${DateTime.now().millisecondsSinceEpoch}',
          title: prompt.trim(),
          type: 'image',
          detail: 'Aspect $selectedRatio • Seed #$seed',
          thumbUrl: fullUrl,
        ),
      );
    }
    notifyListeners();
  }

  void addStoryboardBeat(String title, String speaker, String script) {
    beats.add(StoryboardBeat(
      beat: beats.length + 1,
      title: title,
      timeRange: '${beats.length * 10}s - ${(beats.length + 1) * 10}s',
      speaker: speaker,
      script: script,
    ));
    notifyListeners();
  }

  Future<void> startVideoRender() async {
    if (isRenderingVideo) return;
    isRenderingVideo = true;
    videoRenderProgress = 0.1;
    notifyListeners();

    final scriptText = beats.map((b) => b.script).join(' ');
    final startRes = await apiClient.renderVideo('Hermes Spatial Reel', scriptText);
    if (startRes['success'] != true || startRes['data']?['jobId'] == null) {
      isRenderingVideo = false;
      videoRenderProgress = 0.0;
      notifyListeners();
      return;
    }

    final jobId = startRes['data']['jobId'].toString();
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final stRes = await apiClient.checkVideoStatus(jobId);
      final d = stRes['data'] as Map<String, dynamic>?;
      if (d == null) return;

      final pct = (d['progressPct'] is num) ? (d['progressPct'] as num).toDouble() / 100.0 : 0.5;
      videoRenderProgress = pct.clamp(0.0, 1.0);

      if (d['status'] == 'completed') {
        isRenderingVideo = false;
        videoRenderProgress = 1.0;
        timer.cancel();
        vaultItems.insert(
          0,
          VaultMediaItem(
            id: 'vlt_vid_${DateTime.now().millisecondsSinceEpoch}',
            title: (d['title'] ?? 'Hermes Spatial Reel').toString(),
            type: 'video',
            detail: '${currentRole.videoResolution} • MP4 Neural TTS',
            thumbUrl:
                'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=400&q=80',
            isFavorite: true,
          ),
        );
      } else if (d['status'] == 'failed') {
        isRenderingVideo = false;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> setVoiceMuted(bool muted) async {
    isVoiceMuted = muted;
    if (muted) {
      await _audioPlayer.setVolume(0.0);
    } else {
      await _audioPlayer.setVolume(1.0);
    }
    notifyListeners();
  }

  Future<void> sendVoiceQuery(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) {
      voiceState = 'idle';
      notifyListeners();
      return;
    }

    voiceState = 'thinking';
    voiceTranscript = 'Anda: "$clean"\nMenghubungi Hermes Voice AI...';
    notifyListeners();

    final res = await apiClient.converseVoice(clean, activeAgentId);
    if (res['success'] == true && res['data'] != null) {
      final d = res['data'] as Map<String, dynamic>;
      final replyText = (d['replyText'] ?? '').toString();
      final relAudio = (d['audioUrl'] ?? '').toString();
      final fullAudioUrl = apiClient.resolveMediaUrl(relAudio);

      voiceState = 'speaking';
      voiceTranscript = replyText.isNotEmpty ? replyText : 'Menjawab...';
      notifyListeners();

      if (fullAudioUrl.isNotEmpty) {
        try {
          await _audioPlayer.stop();
          await _audioPlayer.setVolume(isVoiceMuted ? 0.0 : 1.0);
          _audioPlayer.onPlayerComplete.first.then((_) {
            if (voiceState == 'speaking') {
              voiceState = 'idle';
              notifyListeners();
            }
          });
          await _audioPlayer.play(UrlSource(fullAudioUrl));
        } catch (e) {
          voiceTranscript = '$replyText\n(Audio gagal diputar: $e)';
          voiceState = 'idle';
          notifyListeners();
        }
      } else {
        voiceState = 'idle';
        notifyListeners();
      }
    } else {
      voiceState = 'idle';
      voiceTranscript = 'Gagal terhubung ke layanan suara Hermes.';
      notifyListeners();
    }
  }

  Future<void> toggleVoiceState() async {
    if (voiceState == 'idle') {
      try {
        if (!_speechReady) {
          _speechReady = await _speech.initialize(
            onStatus: (status) {
              if ((status == 'done' || status == 'notListening') &&
                  voiceState == 'listening') {
                // Handled in listen result
              }
            },
            onError: (err) {
              voiceState = 'idle';
              voiceTranscript =
                  'Mikrofon tidak tersedia (${err.errorMsg}). Ketik pertanyaan di kolom bawah untuk bicara.';
              notifyListeners();
            },
          );
        }

        if (_speechReady) {
          voiceState = 'listening';
          voiceTranscript = 'Mendengarkan suara Anda... Silakan bicara.';
          notifyListeners();

          String lastWords = '';
          await _speech.listen(
            localeId: 'id_ID',
            listenFor: const Duration(seconds: 20),
            pauseFor: const Duration(seconds: 2),
            onResult: (result) {
              lastWords = result.recognizedWords;
              if (lastWords.isNotEmpty) {
                voiceTranscript = '"$lastWords"';
                notifyListeners();
              }
              if (result.finalResult && lastWords.trim().isNotEmpty) {
                _speech.stop();
                sendVoiceQuery(lastWords);
              }
            },
          );
        } else {
          voiceState = 'idle';
          voiceTranscript =
              'Izin mikrofon/speech tidak aktif di iOS. Ketik pertanyaan di kolom bawah untuk bicara.';
          notifyListeners();
        }
      } catch (e) {
        voiceState = 'idle';
        voiceTranscript =
            'Mikrofon tidak tersedia ($e). Ketik pertanyaan di kolom bawah.';
        notifyListeners();
      }
    } else {
      await _speech.stop();
      await _audioPlayer.stop();
      voiceState = 'idle';
      voiceTranscript = 'Sesi suara dijeda. Ketuk mic untuk melanjutkan.';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _speech.stop();
    super.dispose();
  }

  void setVaultFilter(String filter) {
    vaultFilter = filter;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    for (final item in vaultItems) {
      if (item.id == id) {
        item.isFavorite = !item.isFavorite;
        break;
      }
    }
    notifyListeners();
  }

  void deleteVaultItem(String id) {
    if (!currentRole.canDeleteVault) return;
    vaultItems.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> testBackendPing(String url) async {
    apiClient.baseUrl = url.trim();
    pingStatus = 'Menghubungi $url...';
    notifyListeners();
    final res = await apiClient.healthCheck();
    if (res['success'] == true) {
      pingStatus = '🟢 Terhubung: Hermes Bridge Active';
    } else {
      pingStatus = '🟡 Standalone Demo Mode (Server lokal offline)';
    }
    notifyListeners();
  }
}
