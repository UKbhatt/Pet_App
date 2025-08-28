import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/storage.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.137.1:8000';

  static Map<String, String> _headers({bool withAuth = false}) {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = readToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {bool auth=false}) async {
    final res = await http.post(Uri.parse('$baseUrl$path'),
        headers: _headers(withAuth: auth),
        body: jsonEncode(body));
    final data = res.body.isEmpty ? {} : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw Exception(data['detail'] ?? 'Request failed (${res.statusCode})');
  }

  static Future<dynamic> get(String path, {bool auth=false}) async {
    final res = await http.get(Uri.parse('$baseUrl$path'),
        headers: _headers(withAuth: auth));
    final data = res.body.isEmpty ? {} : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw Exception(data['detail'] ?? 'Request failed (${res.statusCode})');
  }
}
