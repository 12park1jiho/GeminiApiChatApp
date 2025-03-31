import 'package:image_picker/image_picker.dart';
import 'api_service.dart';

class ChatService {
  final ApiService apiService;

  ChatService({required this.apiService});

  Future<List<Map<String, String>>> sendMessage(String text, {XFile? image}) async {
    return await apiService.sendMessage(text: text, image: image);
  }
}