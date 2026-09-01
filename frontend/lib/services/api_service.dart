import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/role.dart';
import '../models/skills_analysis_result.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/auth/register/',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    debugPrint('Register URL: $url');
    debugPrint('Register Status: ${response.statusCode}');
    debugPrint('Register Response: ${response.body}');

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Registration failed: ${response.body}',
    );
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/auth/login/',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    debugPrint('Login URL: $url');
    debugPrint('Login Status: ${response.statusCode}');
    debugPrint('Login Response: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Login failed: ${response.body}',
    );
  }


  static Future<SkillAnalysisResult> analyzeSkills({
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
      return SkillAnalysisResult.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'HTTP ${response.statusCode} - ${response.reasonPhrase}',
    );
  }

  static Future<List<Role>> getRoles() async {
    final url = Uri.parse('$baseUrl/api/v1/roles/');

    final response = await http.get(url);

    debugPrint('Roles URL: $url');
    debugPrint('Roles Status: ${response.statusCode}');
    debugPrint('Roles Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map(
            (role) => Role.fromJson(role),
      )
          .toList();
    }

    throw Exception(
      'Failed to load roles: ${response.statusCode}',
    );
  }
}