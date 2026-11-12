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

  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/health'), headers: _headers())
          .timeout(const Duration(seconds: 3));
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
          .timeout(const Duration(seconds: 4));
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
          .timeout(const Duration(seconds: 4));
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        authToken = decoded['data']?['token'] as String?;
      }
      return decoded;
    } catch (_) {
      return {'success': false, 'offline': true};
    }
  }
}
