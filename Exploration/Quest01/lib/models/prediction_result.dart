class PredictionResult {
  final String label;
  final double confidence; // [0,1] 범위

  PredictionResult({
    required this.label,
    required this.confidence,
  });
}
