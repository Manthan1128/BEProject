import 'dart:io';
import 'package:flutter/material.dart';
import '../api_service.dart';

class ResultsPage extends StatefulWidget {
  final File imagePath;

  const ResultsPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final ApiService _apiService = ApiService();
  String? _ocrText;
  String? _analysis;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    //_processImage();
    timeout();
  }

  void dispose() {
    super.dispose();
  }

  void timeout() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _processImage() async {
    try {
      // Perform OCR
      final ocrResponse = await _apiService.performOCR(widget.imagePath.path);
      if (!ocrResponse.success) {
        throw Exception(ocrResponse.error);
      }

      _ocrText = ocrResponse.text;

      // Perform LLM analysis
      if (_ocrText != null) {
        final llmResponse = await _apiService.performLLMAnalysis(_ocrText!);
        if (!llmResponse.success) {
          throw Exception(llmResponse.error);
        }
        _analysis = llmResponse.analysis;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _error != null
                  ? Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Extracted Text:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            //_ocrText ?? 'No text extracted',
                            'ABCDDD',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Analysis:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            //_analysis ?? 'No analysis available',
                            'ajnjdjvbfjbjf',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
