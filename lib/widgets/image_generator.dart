// lib/widgets/image_generator.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://YOUR_BACKEND_URL'; // FastAPI 백엔드 URL (실제 주소로 변경)

  Future<Map<String, dynamic>> generateImage(String prompt) async {
    try {
      print('Sending request to: $baseUrl/generate_image');
      print('Request body: ${jsonEncode({"prompt": prompt})}');

      final response = await http.post(
        Uri.parse('$baseUrl/generate_image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to generate image');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to generate image');
    }
  }
}

class ImageGenerator extends StatefulWidget {
  @override
  _ImageGeneratorState createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  final _apiService = ApiService();
  String _prompt = '';
  String? _imageUrl;
  String? _generatedText;

  void _generateImage() async {
    try {
      final response = await _apiService.generateImage(_prompt);
      setState(() {
        _imageUrl = response['image_base64'];
        _generatedText = response['text'];
      });
    } catch (e) {
      print('Error: $e');
      // 오류 처리 (예: 스낵바 표시)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Enter prompt'),
            onChanged: (value) {
              _prompt = value;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generateImage,
            child: Text('Generate Image'),
          ),
          SizedBox(height: 20),
          if (_imageUrl != null)
            Image.memory(
              base64Decode(_imageUrl!),
              height: 200,
            ),
          if (_generatedText != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(_generatedText!),
            ),
        ],
      ),
    );
  }
}