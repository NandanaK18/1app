import 'package:flutter/material.dart';
import 'weight_pace_screen.dart';

class WeightGoalConfirmationScreen extends StatelessWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final int age;
  final String activityLevel;
  final String goal;
  final double targetWeight;

  const WeightGoalConfirmationScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.age,
    required this.activityLevel,
    required this.goal,
    required this.targetWeight,
  });

  String _getWeightDifferenceText() {
    double difference = (targetWeight - weight).abs();
    String unit = isWeightInKg ? 'kg' : 'lbs';
    return '${difference.toStringAsFixed(1)}$unit';
  }

  @override
  Widget build(BuildContext context) {
    bool isGaining = targetWeight > weight;
    String differenceText = _getWeightDifferenceText();

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: '${isGaining ? 'Gaining' : 'Losing'} '),
                              TextSpan(
                                text: differenceText,
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              const TextSpan(
                                text: ' ? Definitely Doable. You\'re on the right track!',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '90% of users notice real progress with Nutrino, and the results truly stick.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeightPaceScreen(
                                gender: gender,
                                weight: weight,
                                isWeightInKg: isWeightInKg,
                                height: height,
                                isHeightInCm: isHeightInCm,
                                age: age,
                                activityLevel: activityLevel,
                                goal: goal,
                                targetWeight: targetWeight,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
