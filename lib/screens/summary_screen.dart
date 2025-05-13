import 'package:flutter/material.dart';

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
  Widget _buildInfoItem(String label, String value) {
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
            const Icon(
              Icons.edit,
              size: 16,
              color: Colors.blue,
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
        color: Colors.grey[200],
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
                      _buildInfoItem('Gender', gender),
                      _buildInfoItem(
                        'Weight',
                        '${weight.toStringAsFixed(1)} ${isWeightInKg ? 'kg' : 'lbs'}',
                      ),
                      _buildInfoItem(
                        'Height',
                        '${height.toStringAsFixed(0)} ${isHeightInCm ? 'cm' : 'in'}',
                      ),
                      _buildInfoItem('Age', '$age years'),
                      _buildInfoItem(
                        'Athletic Status',
                        isAthlete ? 'Athlete' : 'Non-Athlete',
                      ),
                      if (bodyFatPercentage != null)
                        _buildInfoItem(
                          'Body Fat %',
                          '${bodyFatPercentage!.toStringAsFixed(0)}%',
                        ),
                    ],
                  ),

                  // Activity & Goals Section
                  _buildSectionCard(
                    'Activity & Goals',
                    [
                      _buildInfoItem('Activity Level', _formatActivityLevel(activityLevel)),
                      _buildInfoItem('Goal', goal),
                    ],
                  ),

                  // Macro Settings Section
                  _buildSectionCard(
                    'Macro Settings',
                    [
                      _buildInfoItem(
                        'Protein Ratio',
                        '${proteinRatio.toStringAsFixed(1)} g/kg',
                      ),
                      _buildInfoItem(
                        'Fat Ratio',
                        '${fatRatio.toStringAsFixed(0)}% of calories',
                      ),
                      _buildInfoItem('Carbs', 'Calculated'),
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
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to results screen
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
