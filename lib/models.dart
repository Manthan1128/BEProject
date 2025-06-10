import 'dart:developer';

class MlModelResponse {
  final String? recommendation;
  final String? error;
  final String? details;
  final bool isSuccess;

  MlModelResponse({
    this.recommendation,
    this.error,
    this.details,
    required this.isSuccess,
  });

  factory MlModelResponse.fromJson(Map<String, dynamic> json) {
    // Check if the response contains an error
    if (json.containsKey('error')) {
      return MlModelResponse(
        error: json['error'] as String?,
        details: json['details'] as String?,
        isSuccess: false,
      );
    }

    // Success response with recommendation
    if (json.containsKey('recommendation')) {
      log("recommendation : " + json['recommendation'].toString());
      return MlModelResponse(
        recommendation: json['recommendation'] as String?,
        isSuccess: true,
      );
    }
    return MlModelResponse(isSuccess: false);
  }

  factory MlModelResponse.error(String errorMessage) {
    return MlModelResponse(
      error: errorMessage,
      isSuccess: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendation': recommendation,
      'error': error,
      'details': details,
      'isSuccess': isSuccess,
    };
  }

  @override
  String toString() {
    return 'MlModelResponse(recommendation: $recommendation, error: $error, details: $details, isSuccess: $isSuccess)';
  }
}
