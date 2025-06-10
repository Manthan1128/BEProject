import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';

class ResultsPage extends StatefulWidget {
  final File imagePath;

  const ResultsPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final ApiService _apiService = ApiService();

  MlModelResponse? _response;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    log('ResultsPage initialized with image: ${widget.imagePath.path}');
    _processImage();
  }

  Future<void> _processImage() async {
    try {
      log('Starting image processing...');
      setState(() {
        _isLoading = true;
        _error = null;
        _response = null;
      });

      final response =
          await _apiService.analyzeAndRecommend(widget.imagePath.path);
      log(response.toString());
      
      setState(() => _response = response);
    } catch (e) {
      log('Error in _processImage: $e');
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildResultSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(content, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _processImage,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing image...'),
                  ],
                )
              : _error != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error occurred:',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(_error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: _processImage,
                            child: const Text('Retry')),
                      ],
                    )
                  : _response != null
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(widget.imagePath,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_response?.recommendation != null)
                                _buildResultSection("Recommendation",
                                    _response!.recommendation!),

                              // Add other fields if available in the API response
                            ],
                          ),
                        )
                      : const Text("No data available"),
        ),
      ),
    );
  }
}
