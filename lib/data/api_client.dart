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

  static String? authToken() => readToken();

  static dynamic decode(String body) => body.isEmpty ? {} : jsonDecode(body);
  static String errorFrom(http.Response res) {
    final data = decode(res.body);
    return (data is Map && data['detail'] != null)
        ? data['detail'].toString()
        : 'Request failed (${res.statusCode})';
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {bool auth=false}) async {
    final res = await http.post(Uri.parse('$baseUrl$path'),
        headers: _headers(withAuth: auth),
        body: jsonEncode(body));
    final data = decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw Exception(data['detail'] ?? 'Request failed (${res.statusCode})');
  }

  static Future<dynamic> get(String path, {bool auth=false}) async {
    final res = await http.get(Uri.parse('$baseUrl$path'),
        headers: _headers(withAuth: auth));
    final data = decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw Exception(data['detail'] ?? 'Request failed (${res.statusCode})');
  }

  static Future<Map<String, dynamic>> patch(String p, Map<String, dynamic> body, {bool auth=false}) async {
    final res = await http.patch(Uri.parse('$baseUrl$p'), headers: _headers(withAuth: auth), body: jsonEncode(body));
    final data = decode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw Exception(data['detail'] ?? 'Request failed (${res.statusCode})');
  }

  static Future<void> delete(String p, {bool auth=false}) async {
    final res = await http.delete(Uri.parse('$baseUrl$p'), headers: _headers(withAuth: auth));
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    final data = decode(res.body);
    throw Exception(data['detail'] ?? 'Request failed (${res.statusCode})');
  }
}
