import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/classifier_service.dart';
import '../models/prediction_result.dart';
import '../widgets/prediction_card.dart';
import '../widgets/loading_overlay.dart';

class ClassifierScreen extends StatefulWidget {
  const ClassifierScreen({Key? key}) : super(key: key);

  @override
  State<ClassifierScreen> createState() => _ClassifierScreenState();
}

class _ClassifierScreenState extends State<ClassifierScreen> {
  final ClassifierService _classifierService = ClassifierService();
  File? _selectedImage;
  List<PredictionResult>? _predictions;
  bool _isLoading = false;
  bool _isModelReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _classifierService.loadModel();
      setState(() => _isModelReady = true);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load model: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );
      if (picked == null) return;
      setState(() {
        _selectedImage = File(picked.path);
        _predictions = null;
        _errorMessage = null;
      });
      await _classifyImage();
    } catch (e) {
      setState(() => _errorMessage = 'Failed to pick image: $e');
    }
  }

  Future<void> _classifyImage() async {
    if (_selectedImage == null || !_isModelReady) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await _classifierService.classifyImage(_selectedImage!);
      setState(() => _predictions = results);
    } catch (e) {
      setState(() => _errorMessage = 'Classification failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('꽃 분류기'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Column(
          children: [
            Expanded(child: _buildBody()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _initModel, child: const Text('다시 시도')),
            ],
          ),
        ),
      );
    }
    if (!_isModelReady) {
      return const Center(child: Text('모델을 로딩 중입니다...'));
    }
    if (_selectedImage == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist, size: 100, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
            const SizedBox(height: 24),
            const Text('꽃을 분류하려면 이미지를 선택하세요', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(_selectedImage!, height: 300, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          if (_predictions != null && _predictions!.isNotEmpty) ...[
            const Text('분류 결과', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _predictions!.length,
              itemBuilder: (c, i) => PredictionCard(
                prediction: _predictions![i],
                isTopPrediction: i == 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('갤러리'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('카메라'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
