import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/prediction_result.dart'; // PredictionResult 클래스 불러오기

class ClassifierService {
  static const int imageSize = 224;

  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> loadModel() async {
    // 모델 로드
    _interpreter = await Interpreter.fromAsset('assets/models/flower_classifier.tflite');

    // 레이블 로드
    final raw = await rootBundle.loadString('assets/models/labels.txt');
    _labels = raw.split('\n').where((s) => s.isNotEmpty).toList();
  }

  Future<List<PredictionResult>> classifyImage(File imageFile) async {
    // 이미지 전처리
    final input = await _preprocess(imageFile);

    // 출력 버퍼 준비 (타입 명확히: List<List<double>>)
    var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    // 추론 실행
    _interpreter.run(input, output);

    // 결과 처리
    return _postProcess(output);
  }

  Future<Uint8List> _preprocess(File imageFile) async {
    // 이미지를 Uint8List로 변환
    Uint8List imageBytes = await imageFile.readAsBytes();

    // 이미지 디코딩
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("이미지 디코딩 실패");
    }

    // 이미지 리사이즈
    img.Image resizedImage = img.copyResize(image, width: imageSize, height: imageSize);

    // 이미지를 바이트 배열로 변환
    var buffer = Uint8List(imageSize * imageSize * 3);
    var bufferIndex = 0;
    for (var y = 0; y < imageSize; y++) {
      for (var x = 0; x < imageSize; x++) {
        var pixel = resizedImage.getPixel(x, y);
        buffer[bufferIndex++] = img.getRed(pixel);
        buffer[bufferIndex++] = img.getGreen(pixel);
        buffer[bufferIndex++] = img.getBlue(pixel);
      }
    }
    return buffer;
  }

  List<PredictionResult> _postProcess(List<List<double>> output) {
    final predictions = output[0]
        .asMap()
        .map((index, value) => MapEntry(_labels[index], value))
        .entries
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return predictions
        .map((e) => PredictionResult(label: e.key, confidence: e.value))
        .toList();
  }
}
