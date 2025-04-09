import 'package:flutter/material.dart';
import '../models/prediction_result.dart';

class PredictionCard extends StatelessWidget {
  final PredictionResult prediction;
  final bool isTopPrediction;

  const PredictionCard({
    Key? key,
    required this.prediction,
    this.isTopPrediction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isTopPrediction ? 4 : 1,
      color: isTopPrediction ? cs.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (isTopPrediction) Icon(Icons.stars, color: cs.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prediction.label,
                    style: TextStyle(
                      fontSize: isTopPrediction ? 18 : 16,
                      fontWeight: isTopPrediction ? FontWeight.bold : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: prediction.confidence.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isTopPrediction ? cs.primary : cs.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(prediction.confidence * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isTopPrediction ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
