import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ui_design_1/models.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Add interceptors for debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: false, // Don't log file data to avoid clutter
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: false,
    ));

    // Set reasonable timeouts
    _dio.options.connectTimeout =
        const Duration(seconds: 30); // Reduced from 15 minutes
    _dio.options.receiveTimeout =
        const Duration(minutes: 3); // Still generous for ML processing
    _dio.options.sendTimeout = const Duration(minutes: 2); // For file uploads

    // Add retry interceptor
    _dio.interceptors.add(RetryInterceptor());
  }

  // ML Model API endpoint - Update this to your Flask server IP
  final String mlModelApiUrl =
      'http://192.168.91.235:8080/analyze-and-recommend';

  /// Main method that sends image file to your Flask API
  Future<MlModelResponse> analyzeAndRecommend(String imagePath) async {
    try {
      log('Starting API call to: $mlModelApiUrl');
      log('Image path: $imagePath');

      // Check if file exists
      final file = File(imagePath);
      if (!await file.exists()) {
        log('File does not exist at path: $imagePath');
        return MlModelResponse.error('Image file not found');
      }

      final fileSize = await file.length();
      log('File exists, size: $fileSize bytes');

      // Check file size (limit to 10MB)
      if (fileSize > 10 * 1024 * 1024) {
        log('File too large: $fileSize bytes');
        return MlModelResponse.error('Image file is too large (max 10MB)');
      }

      // Create FormData with the image file
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: 'nutrition_label.jpg',
        ),
        // Add other form fields that your Flask API might expect
        'age': 21,
        'BMI': 23.5,
        'goals': ['weight loss', 'muscle gain'],
        'conditions': ['diabetes'],
        'preferences': ['high protein'],
      });

      log('FormData created, making API call...');

      final response = await _dio.post(
        mlModelApiUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          // Override timeouts for this specific request if needed
          receiveTimeout:
              const Duration(minutes: 5), // More time for ML processing
        ),
      );

      log('API call successful!');
      log('Status code: ${response.statusCode}');
      log('Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200 && response.data != null) {
        return MlModelResponse.fromJson(response.data);
      } else {
        return MlModelResponse.error('Invalid response from server');
      }
    } on DioException catch (dioError) {
      log('Dio error occurred: ${dioError.type}');
      log('Dio error message: ${dioError.message}');
      log('Dio error response: ${dioError.response?.data}');

      return MlModelResponse.error(_handleDioError(dioError));
    } catch (e) {
      log('General error occurred: $e');
      return MlModelResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Alternative method for simple POST without image (for testing)
  Future<MlModelResponse> analyzeWithoutImage() async {
    try {
      log('Starting API call without image to: $mlModelApiUrl');

      final response = await _dio.post(
        mlModelApiUrl,
        data: {
          'age': 21,
          'BMI': 23.5,
          'goals': ['weight loss', 'muscle gain'],
          'conditions': ['diabetes'],
          'preferences': ['high protein'],
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(
              minutes: 2), // Shorter timeout for non-image requests
        ),
      );

      log('API call successful!');
      log('Status code: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        return MlModelResponse.fromJson(response.data);
      } else {
        return MlModelResponse.error('Invalid response from server');
      }
    } on DioException catch (dioError) {
      log('Dio error occurred: ${dioError.type}');
      log('Dio error message: ${dioError.message}');
      log('Dio error response: ${dioError.response?.data}');

      return MlModelResponse.error(_handleDioError(dioError));
    } catch (e) {
      log('General error occurred: $e');
      return MlModelResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  /// Centralized error handling for DioException
  String _handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout - Please check your internet connection and try again';
      case DioExceptionType.sendTimeout:
        return 'Upload timeout - The image upload took too long. Try with a smaller image';
      case DioExceptionType.receiveTimeout:
        return 'Server processing timeout - The analysis is taking longer than expected. Please try again';
      case DioExceptionType.connectionError:
        return 'Cannot connect to server. Please check if the server is running at $mlModelApiUrl';
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        final statusMessage = dioError.response?.statusMessage;
        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              return 'Bad request - Please check the image format and data';
            case 404:
              return 'API endpoint not found - Please check the server configuration';
            case 500:
              return 'Server error - The ML model encountered an issue';
            case 503:
              return 'Server unavailable - Please try again later';
            default:
              return 'Server error ($statusCode): $statusMessage';
          }
        }
        return 'Server returned an invalid response';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      default:
        return 'Network error: ${dioError.message ?? 'Unknown error'}';
    }
  }

  /// Test server connectivity
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get(
        mlModelApiUrl.replaceAll('/analyze-and-recommend', '/health'),
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      log('Connection test failed: $e');
      return false;
    }
  }
}

/// Simple retry interceptor
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    // Only retry on specific error types
    if (_shouldRetry(err) && request.extra['retryCount'] < maxRetries) {
      request.extra['retryCount'] = (request.extra['retryCount'] ?? 0) + 1;

      log('Retrying request (${request.extra['retryCount']}/$maxRetries)');

      await Future.delayed(retryDelay);

      try {
        final response = await Dio().fetch(request);
        handler.resolve(response);
        return;
      } catch (e) {
        // If retry fails, continue with original error
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.badResponse &&
            err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
}
