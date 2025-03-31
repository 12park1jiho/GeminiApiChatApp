import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  final String baseUrl = 'http://0.0.0.0:8000';

  Future<List<Map<String, String>>> sendMessage({
    required String text,
    XFile? image,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/gemini/generate'),
      )
        ..fields['text'] = text;

      if (image != null) {
        final imageBytes = await image.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: image.name,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final results = decodedResponse['results'] as List;
        return results.map((item) => Map<String, String>.from(item)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return [
          {'type': 'text', 'content': 'Error: ${response.statusCode} - ${response.body}'}
        ];
      }
    } catch (e) {
      print('Error: $e');
      return [
        {'type': 'text', 'content': 'Error: Failed to communicate with Gemini API'}
      ];
    }
  }
}