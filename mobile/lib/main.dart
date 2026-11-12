import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_state.dart';
import 'core/tokens.dart';
import 'screens/login_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/image_studio_screen.dart';
import 'screens/video_lab_screen.dart';
import 'screens/voice_mode_screen.dart';
import 'screens/gallery_vault_screen.dart';
import 'widgets/role_switcher_pill.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const HermesSuperAiApp());
}

class HermesSuperAiApp extends StatefulWidget {
  final HermesAppState? appState;

  const HermesSuperAiApp({super.key, this.appState});

  @override
  State<HermesSuperAiApp> createState() => _HermesSuperAiAppState();
}

class _HermesSuperAiAppState extends State<HermesSuperAiApp> {
  late final HermesAppState _appState;
  late final bool _ownsState;

  void _onStateChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _ownsState = widget.appState == null;
    _appState = widget.appState ?? HermesAppState();
    _appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    if (_ownsState) {
      _appState.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hermes Super AI',
      debugShowCheckedModeBanner: false,
      themeMode: _appState.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: VisionTokens.bgAlabasterCanvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: VisionTokens.accentIndigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: VisionTokens.bgSpatialCanvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: VisionTokens.accentCyan,
          brightness: Brightness.dark,
        ),
      ),
      home: _appState.isAuthenticated
          ? MainShellScreen(appState: _appState)
          : LoginScreen(appState: _appState),
    );
  }
}

class MainShellScreen extends StatelessWidget {
  final HermesAppState appState;

  const MainShellScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDark = appState.isDarkTheme;

    final screens = [
      ChatScreen(appState: appState),
      ImageStudioScreen(appState: appState),
      VideoLabScreen(appState: appState),
      VoiceModeScreen(appState: appState),
      GalleryVaultScreen(appState: appState),
    ];

    return Scaffold(
      backgroundColor: isDark
          ? VisionTokens.bgSpatialCanvas
          : VisionTokens.bgAlabasterCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: VisionTokens.prismGradient,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'HERMES',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: VisionTokens.accentCyan.withOpacity(0.14),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: VisionTokens.accentCyan.withOpacity(0.4),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                  SizedBox(width: 6),
                  Text(
                    'LIVE AI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: VisionTokens.accentCyan,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Screen Viewport
          Positioned.fill(
            bottom: 74,
            child: screens[appState.currentTab],
          ),

          // Floating Frosted Glass Bottom Tab Bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A).withOpacity(0.82)
                        : Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.18)
                          : Colors.white.withOpacity(0.9),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _tabItem(Icons.chat_bubble_outline_rounded,
                          Icons.chat_bubble_rounded, 'Chat', 0),
                      _tabItem(Icons.brush_outlined,
                          Icons.brush_rounded, 'Studio', 1),
                      _tabItem(Icons.movie_outlined,
                          Icons.movie_rounded, 'Video', 2),
                      _tabItem(Icons.mic_none_rounded,
                          Icons.mic_rounded, 'Voice', 3),
                      _tabItem(Icons.folder_outlined,
                          Icons.folder_rounded, 'Vault', 4),
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

  Widget _tabItem(
      IconData unselected, IconData selected, String label, int idx) {
    final active = appState.currentTab == idx;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        appState.setTab(idx);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? selected : unselected,
            size: 22,
            color: active
                ? VisionTokens.accentCyan
                : (appState.isDarkTheme ? Colors.white60 : Colors.black45),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: active
                  ? VisionTokens.accentCyan
                  : (appState.isDarkTheme ? Colors.white60 : Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
