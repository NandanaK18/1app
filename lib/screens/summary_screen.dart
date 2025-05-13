import 'package:flutter/material.dart';
import 'activity_level_screen.dart';
import 'age_selection_screen.dart';
import 'gender_selection_screen.dart';
import 'goal_selection_screen.dart';
import 'height_selection_screen.dart';
import 'weight_selection_screen.dart';
import 'results_screen.dart';

class SummaryScreen extends StatelessWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final int age;
  final bool isAthlete;
  final double? bodyFatPercentage;
  final String activityLevel;
  final String goal;
  final double proteinRatio;
  final double fatRatio;

  const SummaryScreen({
    Key? key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.age,
    required this.isAthlete,
    this.bodyFatPercentage,
    required this.activityLevel,
    required this.goal,
    required this.proteinRatio,
    required this.fatRatio,
  }) : super(key: key);
  void _handleEditTap(String label, BuildContext context) {    switch (label) {
      case 'Gender':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GenderSelectionScreen(),
          ),
        );
        break;
      case 'Weight':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WeightSelectionScreen(gender: gender),
          ),
        );
        break;
      case 'Height':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HeightSelectionScreen(
              gender: gender,
              weight: weight,
              isWeightInKg: isWeightInKg,
            ),
          ),
        );
        break;
      case 'Age':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AgeSelectionScreen(
              gender: gender,
              weight: weight,
              isWeightInKg: isWeightInKg,
              height: height,
              isHeightInCm: isHeightInCm,
            ),
          ),
        );
        break;
      case 'Activity Level':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityLevelScreen(
              gender: gender,
              weight: weight,
              isWeightInKg: isWeightInKg,
              height: height,
              isHeightInCm: isHeightInCm,
              birthDate: DateTime.now().subtract(Duration(days: age * 365)),
              age: age,
            ),
          ),
        );
        break;
      case 'Goal':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GoalSelectionScreen(
              gender: gender,
              weight: weight,
              isWeightInKg: isWeightInKg,
              height: height,
              isHeightInCm: isHeightInCm,
              birthDate: DateTime.now().subtract(Duration(days: age * 365)),
              age: age,
              activityLevel: activityLevel,
            ),
          ),
        );
        break;
    }
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                _handleEditTap(label, context);
              },
              child: const Icon(
                Icons.edit,
                size: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatActivityLevel(String level) {
    return level.split('_').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  title == 'Personal Information'
                      ? Icons.person_outline
                      : title == 'Activity & Goals'
                          ? Icons.fitness_center
                          : Icons.science_outlined,
                  color: Colors.black,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  
                  // Title
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  const Text(
                    'Review your information before calculating.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  
                  const SizedBox(height: 32),

                  // Personal Information Section
                  _buildSectionCard(
                    'Personal Information',
                    [
                      _buildInfoItem(context, 'Gender', gender),
                      _buildInfoItem(
                        context,
                        'Weight',
                        '${weight.toStringAsFixed(1)} ${isWeightInKg ? 'kg' : 'lbs'}',
                      ),
                      _buildInfoItem(
                        context,
                        'Height',
                        '${height.toStringAsFixed(0)} ${isHeightInCm ? 'cm' : 'in'}',
                      ),
                      _buildInfoItem(context, 'Age', '$age years'),
                      _buildInfoItem(
                        context,
                        'Athletic Status',
                        isAthlete ? 'Athlete' : 'Non-Athlete',
                      ),
                      if (bodyFatPercentage != null)
                        _buildInfoItem(
                          context,
                          'Body Fat %',
                          '${bodyFatPercentage!.toStringAsFixed(0)}%',
                        ),
                    ],
                  ),

                  // Activity & Goals Section
                  _buildSectionCard(
                    'Activity & Goals',
                    [
                      _buildInfoItem(context, 'Activity Level', _formatActivityLevel(activityLevel)),
                      _buildInfoItem(context, 'Goal', goal),
                    ],
                  ),

                  // Macro Settings Section
                  _buildSectionCard(
                    'Macro Settings',
                    [
                      _buildInfoItem(
                        context,
                        'Protein Ratio',
                        '${proteinRatio.toStringAsFixed(1)} g/kg',
                      ),
                      _buildInfoItem(
                        context,
                        'Fat Ratio',
                        '${fatRatio.toStringAsFixed(0)}% of calories',
                      ),
                      _buildInfoItem(context, 'Carbs', 'Calculated'),
                    ],
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(                        onPressed: () {
                          double targetWeight = weight;
                          double pace = 0.0;
                          
                          if (goal == 'Lose Weight') {
                            targetWeight = weight - (isWeightInKg ? 10 : 22); // -10kg or -22lbs
                            pace = isWeightInKg ? 0.8 : 1.5; // 0.8kg/week or 1.5lbs/week default
                          } else if (goal == 'Gain Weight') {
                            targetWeight = weight + (isWeightInKg ? 10 : 22); // +10kg or +22lbs
                            pace = isWeightInKg ? 0.8 : 1.5; // 0.8kg/week or 1.5lbs/week default
                          }
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultsScreen(
                                gender: gender,
                                weight: weight,
                                isWeightInKg: isWeightInKg,
                                height: height,
                                isHeightInCm: isHeightInCm,
                                age: age,
                                activityLevel: activityLevel,
                                goal: goal,
                                proteinRatio: proteinRatio,
                                fatRatio: fatRatio,
                                targetWeight: targetWeight,
                                pace: pace,
                                isAthlete: isAthlete,
                                bodyFatPercentage: bodyFatPercentage,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Calculate',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
