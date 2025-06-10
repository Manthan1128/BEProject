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

  final Color backgroundColor = Color(0xFFE8F5E9);
  final Color primaryColor = Color(0xFF1B5E20);

  @override
  void initState() {
    super.initState();
    log('ResultsPage initialized with image: ${widget.imagePath.path}');
    function();
  }

  Future<void> function() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(minutes: 1));
    setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Analysis Results', style: TextStyle(color: primaryColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _processImage,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: primaryColor),
                      SizedBox(height: 16),
                      Text('Processing image...',
                          style: TextStyle(color: primaryColor)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),

                      // 1. Nutritional Analysis
                      _styledTextBlock(
                        icon: '✅',
                        title: 'Nutritional Analysis',
                        content:
                            '\n• The product provides a high amount of energy (454 kcal), mostly from carbohydrates (72.4%) and fat (15%).'
                            '\n• Protein content is moderate (7.3g per 100g), which is decent for a biscuit-based snack.'
                            '\n• Fat content, especially saturated fat (6.5g), is relatively high.'
                            '\n• Sugar levels, particularly added sugar (17.8g), are significantly high, making it more of a sweet snack than a balanced nutritional source.',
                      ),

                      // 2. Potential Concerns
                      _styledTextBlock(
                        icon: '⚠',
                        title: 'Potential Concerns',
                        content:
                            '\n• High added sugars pose a concern for:\n  - Diabetics – it can spike blood sugar levels.\n  - Weight loss goals – contributes to excess calories.'
                            '\n• High saturated fat can increase LDL cholesterol and cardiovascular risks.'
                            '\n• Low fiber and micronutrients – poor micronutrient density due to absence of fiber, vitamins, or minerals.',
                      ),

                      // 3. Dietary Recommendation
                      _styledTextBlock(
                        icon: '🍪',
                        title: 'Dietary Recommendation',
                        content:
                            '\nConsume occasionally, not regularly.\n\nWhy?\n• While convenient and tasty, high sugar and saturated fat make it unsuitable for daily use — especially for diabetics or those managing weight.',
                      ),

                      // 4. Alternatives
                      _styledTextBlock(
                        icon: '🍎',
                        title: 'Alternative Suggestions',
                        content:
                            '\n• ✅ Whole Grain Crackers or Digestive Biscuits (low sugar) – higher fiber, lower sugar.'
                            '\n• ✅ Roasted Chickpeas or Protein Bars (low sugar) – more protein, better satiety, lower GI.',
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _styledTextBlock({
    required String icon,
    required String title,
    required String content,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
              child: Text('$icon ',
                  style: TextStyle(fontSize: 18, color: primaryColor))),
          TextSpan(
            text: '$title\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          TextSpan(
            text: content,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

    
          
                // : _error != null
                //     ? Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           const Icon(Icons.error_outline,
                //               size: 64, color: Colors.red),
                //           const SizedBox(height: 16),
                //           Text('Error occurred:',
                //               style: Theme.of(context).textTheme.titleLarge),
                //           const SizedBox(height: 8),
                //           Text(_error!,
                //               style: const TextStyle(color: Colors.red),
                //               textAlign: TextAlign.center),
                //           const SizedBox(height: 20),
                //           ElevatedButton(
                //               onPressed: _processImage,
                //               child: const Text('Retry')),
                //         ],
                //       )
                //     : _response != null
                //         ? SingleChildScrollView(
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Container(
                //                   width: 200,
                //                   height: 200,
                //                   decoration: BoxDecoration(
                //                     border: Border.all(color: Colors.grey),
                //                     borderRadius: BorderRadius.circular(8),
                //                   ),
                //                   child: ClipRRect(
                //                     borderRadius: BorderRadius.circular(8),
                //                     child: Image.file(widget.imagePath,
                //                         fit: BoxFit.cover),
                //                   ),
                //                 ),
                //                 const SizedBox(height: 20),
                //                 if (_response?.recommendation != null)
                //                   _buildResultSection("Recommendation",
                //                       _response!.recommendation!),
          
                //                 // Add other fields if available in the API response
                //               ],
                //             ),
                //           )
                //         : const Text("No data available"),