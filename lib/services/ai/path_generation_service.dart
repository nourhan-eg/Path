import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path_app/models/api/path_generation_request.dart';
import 'package:path_app/models/api/path_generation_response.dart';
import 'package:path_app/services/ai/ai_config.dart';

class PathGenerationException implements Exception {
  final String message;
  PathGenerationException(this.message);

  @override
  String toString() => message;
}

class PathGenerationService {
  Future<PathGenerationResponse> generatePath(
    PathGenerationRequest request,
  ) async {
    final response = await http.post(
      Uri.parse(AiConfig.generatePathEndpoint),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PathGenerationResponse.fromJson(json);
    } else {
      throw PathGenerationException(
        'Failed to generate path (${response.statusCode}). Please try again.',
      );
    }
  }
}
