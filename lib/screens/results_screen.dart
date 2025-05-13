import 'package:flutter/material.dart';
import 'dart:math';

class ResultsScreen extends StatelessWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final int age;
  final String activityLevel;
  final String goal;
  final double targetWeight;
  final double pace;
  final double proteinRatio;
  final double fatRatio;
  final bool isAthlete;
  final double? bodyFatPercentage;

  const ResultsScreen({
    Key? key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.age,
    required this.activityLevel,
    required this.goal,
    required this.targetWeight,
    required this.pace,
    required this.proteinRatio,
    required this.fatRatio,
    required this.isAthlete,
    this.bodyFatPercentage,
  }) : super(key: key);

  // BMR calculation using Mifflin-St Jeor formula
  double _calculateBMR() {
    double weightInKg = isWeightInKg ? weight : weight * 0.453592;
    double heightInCm = isHeightInCm ? height : height * 2.54;
    
    double bmr;
    if (gender == 'Male') {
      bmr = (10 * weightInKg) + (6.25 * heightInCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightInKg) + (6.25 * heightInCm) - (5 * age) - 161;
    }
    return bmr;
  }

  // TDEE calculation based on activity level
  double _calculateTDEE() {
    double bmr = _calculateBMR();
    double activityMultiplier;
    
    switch (activityLevel) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'lightly_active':
        activityMultiplier = 1.375;
        break;
      case 'moderately_active':
        activityMultiplier = 1.55;
        break;
      case 'very_active':
        activityMultiplier = 1.725;
        break;
      case 'extra_active':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }

    return bmr * activityMultiplier;
  }

  // Calculate target calories based on goal
  double _calculateTargetCalories() {
    double tdee = _calculateTDEE();
    double goalFactor = 1.0;
    
    if (goal == 'Lose Weight') {
      goalFactor = 0.8; // 20% deficit
    } else if (goal == 'Gain Weight') {
      goalFactor = 1.2; // 20% surplus
    }

    return tdee * goalFactor;
  }

  // Calculate macros
  Map<String, int> _calculateMacros() {
    double calories = _calculateTargetCalories();
    double weightInKg = isWeightInKg ? weight : weight * 0.453592;
    
    // Calculate protein based on ratio (g/kg of body weight)
    double proteinGrams = weightInKg * proteinRatio;
    double proteinCalories = proteinGrams * 4;
    
    // Calculate fat based on percentage of total calories
    double fatCalories = calories * (fatRatio / 100);
    double fatGrams = fatCalories / 9;
    
    // Calculate remaining calories for carbs
    double remainingCalories = calories - proteinCalories - fatCalories;
    double carbGrams = remainingCalories / 4;
    
    return {
      'calories': calories.round(),
      'protein': proteinGrams.round(),
      'fat': fatGrams.round(),
      'carbs': carbGrams.round(),
    };
  }  String _getTargetDate() {
    if (goal == 'Maintain Weight' || pace == 0) {
      return '';
    }
    final double weightDifference = (targetWeight - weight).abs();
    final int weeksNeeded = (weightDifference / pace).ceil();
    final DateTime targetDate = DateTime.now().add(Duration(days: weeksNeeded * 7));
    
    return '${_getMonthName(targetDate.month)} ${targetDate.day}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildMacroCircle(String title, int value, String unit, Color color, double percentage) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                color: color,
                strokeWidth: 10,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final macros = _calculateMacros();
    final targetDate = _getTargetDate();
    final weightDiff = (targetWeight - weight).abs();
    final String unit = isWeightInKg ? 'kg' : 'lbs';

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Success indicator and message
                const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.black,
                    size: 54,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Awesome!\n We\'ve built your Personal Nutrition Plan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 22),                // Goal text
                Center(
                  child: Text(
                    goal == 'Maintain Weight'
                        ? 'You should Maintain:'
                        : goal == 'Lose Weight'
                            ? 'You should Lose:'
                            : 'You should Gain:',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Weight and target date in capsule
                Center(
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          goal == 'Maintain Weight'
                              ? '${weight.toStringAsFixed(0)} $unit'
                              : '${weightDiff.toStringAsFixed(0)} $unit',                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (goal != 'Maintain Weight' && targetDate.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Text(
                            'by $targetDate',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Macro circles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMacroCircle(
                      'Calories',
                      macros['calories']!,
                      'kcal',
                      Colors.blue,
                      1.0,
                    ),
                    _buildMacroCircle(
                      'Protein',
                      macros['protein']!,
                      'g',
                      Colors.red,
                      macros['protein']! / (macros['protein']! + macros['fat']! + macros['carbs']!),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMacroCircle(
                      'Fat',
                      macros['fat']!,
                      'g',
                      Colors.orange,
                      macros['fat']! / (macros['protein']! + macros['fat']! + macros['carbs']!),
                    ),
                    _buildMacroCircle(
                      'Carbs',
                      macros['carbs']!,
                      'g',
                      Colors.green,
                      macros['carbs']! / (macros['protein']! + macros['fat']! + macros['carbs']!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
