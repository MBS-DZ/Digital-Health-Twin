import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/mental_insight.dart';
import '../models/mood_entry.dart';
import 'api_config.dart';

class MentalHealthApi {
  MentalHealthApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  void dispose() {
    _client.close();
  }

  Future<MoodEntry> addMood(MoodEntry entry) async {
    final response = await _client.post(
      _uri('/mental/add-mood'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entry.toJson()),
    );

    if (response.statusCode != 201) {
      throw ApiException(_errorMessage(response, 'Unable to save mood entry.'));
    }

    return MoodEntry.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<MoodEntry>> getHistory() async {
    final response = await _client.get(_uri('/mental/history'));

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response, 'Unable to load mood history.'));
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => MoodEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<MentalInsight> analyze() async {
    final response = await _client.post(_uri('/mental/analyze'));

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response, 'Unable to generate insights.'));
    }

    return MentalInsight.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  String _errorMessage(http.Response response, String fallback) {
    if (response.body.isEmpty) {
      return fallback;
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded['error']?.toString() ??
            decoded['title']?.toString() ??
            fallback;
      }
    } catch (_) {
      return fallback;
    }

    return fallback;
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
