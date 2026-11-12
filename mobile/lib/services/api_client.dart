import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HermesApiClient {
  String baseUrl;
  String? authToken;

  HermesApiClient({
    this.baseUrl = 'https://webui.5nod.com/staging/hermes-super-ai/api/v1',
    this.authToken,
  });

  String get rootUrl {
    final idx = baseUrl.indexOf('/api/v1');
    if (idx > 0) return baseUrl.substring(0, idx);
    return baseUrl.replaceAll(RegExp(r'/+$'), '');
  }

  String resolveMediaUrl(String relPath) {
    if (relPath.isEmpty) return '';
    if (relPath.startsWith('http://') || relPath.startsWith('https://')) {
      return relPath;
    }
    final clean = relPath.startsWith('/') ? relPath.substring(1) : relPath;
    return '$rootUrl/$clean';
  }

  Map<String, String> _headers() {
    final map = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null && authToken!.isNotEmpty) {
      map['Authorization'] = 'Bearer $authToken';
    }
    return map;
  }

  Future<bool> ensureSession({String roleSlug = 'superadmin'}) async {
    if (authToken != null && authToken!.isNotEmpty) return true;
    final res = await demoSwitch(roleSlug);
    return res['success'] == true && authToken != null && authToken!.isNotEmpty;
  }

  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/health'), headers: _headers())
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return {'success': false, 'status': res.statusCode};
    } catch (e) {
      return {'success': false, 'offline': true, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> demoSwitch(String roleSlug) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/demo-switch'),
            headers: _headers(),
            body: jsonEncode({'roleSlug': roleSlug}),
          )
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        authToken = decoded['data']?['token'] as String?;
        return decoded;
      }
      return {'success': false};
    } catch (_) {
      return {'success': false, 'offline': true};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: _headers(),
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 8));
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        authToken = decoded['data']?['token'] as String?;
      }
      return decoded;
    } catch (_) {
      return {'success': false, 'offline': true};
    }
  }

  Future<void> streamChat({
    required List<Map<String, String>> messages,
    required String agentPersona,
    required bool webSearchEnabled,
    required void Function(String delta) onDelta,
    void Function(String err)? onError,
  }) async {
    await ensureSession();
    final client = http.Client();
    try {
      final request = http.Request('POST', Uri.parse('$baseUrl/chat/stream'));
      request.headers.addAll(_headers());
      request.body = jsonEncode({
        'agentPersona': agentPersona,
        'messages': messages,
        'webSearchEnabled': webSearchEnabled,
      });

      final streamedRes = await client.send(request).timeout(const Duration(seconds: 45));
      if (streamedRes.statusCode != 200) {
        onError?.call('Server returned HTTP ${streamedRes.statusCode}');
        return;
      }

      String buffer = '';
      await for (final chunk in streamedRes.stream.transform(utf8.decoder)) {
        buffer += chunk;
        final lines = buffer.split('\n');
        buffer = lines.removeLast();

        for (final rawLine in lines) {
          final line = rawLine.trim();
          if (line.startsWith('data:')) {
            final payload = line.substring(5).trim();
            try {
              final decoded = jsonDecode(payload) as Map<String, dynamic>;
              final delta = decoded['delta'];
              if (delta is String && delta.isNotEmpty) {
                onDelta(delta);
              }
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      onError?.call(e.toString());
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> generateImage(
    String prompt,
    String aspectRatio, {
    String stylePreset = 'visionos_cyber_glass',
  }) async {
    await ensureSession();
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/image/generate'),
            headers: _headers(),
            body: jsonEncode({
              'prompt': prompt,
              'aspectRatio': aspectRatio,
              'stylePreset': stylePreset,
            }),
          )
          .timeout(const Duration(seconds: 35));
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': {'message': e.toString()}};
    }
  }

  Future<Map<String, dynamic>> renderVideo(
    String title,
    String scriptText, {
    String voice = 'id-ID-GadisNeural',
    String template = 'cinematic_spatial_glass',
  }) async {
    await ensureSession();
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/video/render'),
            headers: _headers(),
            body: jsonEncode({
              'title': title,
              'scriptText': scriptText,
              'speakerFemaleVoice': voice,
              'templateName': template,
              'durationSec': 15,
            }),
          )
          .timeout(const Duration(seconds: 20));
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': {'message': e.toString()}};
    }
  }

  Future<Map<String, dynamic>> checkVideoStatus(String jobId) async {
    await ensureSession();
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/video/status/$jobId'), headers: _headers())
          .timeout(const Duration(seconds: 8));
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': {'message': e.toString()}};
    }
  }

  Future<Map<String, dynamic>> converseVoice(String text, String agentPersona) async {
    await ensureSession();
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/voice/converse'),
            headers: _headers(),
            body: jsonEncode({
              'text': text,
              'agentPersona': agentPersona,
            }),
          )
          .timeout(const Duration(seconds: 30));
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': {'message': e.toString()}};
    }
  }
}
