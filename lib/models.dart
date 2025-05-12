class OcrResponse {
  final bool success;
  final String? text;
  final String? error;

  OcrResponse({
    required this.success,
    this.text,
    this.error,
  });

  factory OcrResponse.fromJson(Map<String, dynamic> json) {
    return OcrResponse(
      success: json['success'] ?? false,
      text: json['text'],
      error: json['error'],
    );
  }

  factory OcrResponse.error(String message) {
    return OcrResponse(
      success: false,
      error: message,
    );
  }
}

class LlmResponse {
  final bool success;
  final String? analysis;
  final String? error;

  LlmResponse({
    required this.success,
    this.analysis,
    this.error,
  });

  factory LlmResponse.fromJson(Map<String, dynamic> json) {
    return LlmResponse(
      success: json['success'] ?? false,
      analysis: json['analysis'],
      error: json['error'],
    );
  }

  factory LlmResponse.error(String message) {
    return LlmResponse(
      success: false,
      error: message,
    );
  }
}