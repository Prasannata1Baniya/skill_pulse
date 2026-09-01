import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> analyzeSkills({
    required String targetRole,
    required List<String> skills,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/analyze/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'target_role': targetRole,
        'skills': skills,
      }),
    );

    debugPrint('URL: $url');
    debugPrint('Status: ${response.statusCode}');
    debugPrint('Response: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'HTTP ${response.statusCode} - ${response.reasonPhrase}',
    );
  }
}
