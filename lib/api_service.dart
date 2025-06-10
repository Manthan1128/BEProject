import 'package:dio/dio.dart';
import './models.dart';

class ApiService {
  final Dio _dio = Dio();

  // Example API endpoints - replace with your actual endpoints
  final String ocrApiUrl = 'https://api.example.com/ocr';
  final String llmApiUrl = 'https://api.example.com/llm';

  Future<OcrResponse> performOCR(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(ocrApiUrl, data: formData);
      return OcrResponse.fromJson(response.data);
    } catch (e) {
      return OcrResponse.error(e.toString());
    }
  }

  Future<LlmResponse> performLLMAnalysis(String text) async {
    try {
      final response = await _dio.post(
        llmApiUrl,
        data: {'text': text},
      );
      return LlmResponse.fromJson(response.data);
    } catch (e) {
      return LlmResponse.error(e.toString());
    }
  }
}
