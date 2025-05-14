import 'package:flutter/material.dart';
import 'advanced_settings_screen.dart';

class ProgressLimitationsScreen extends StatefulWidget {
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

  const ProgressLimitationsScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.age,
    required this.activityLevel,
    required this.goal,
    this.targetWeight = 0.0,
    this.pace = 0.0,
  });

  @override
  State<ProgressLimitationsScreen> createState() => _ProgressLimitationsScreenState();
}

class _ProgressLimitationsScreenState extends State<ProgressLimitationsScreen> {
  String? _selectedLimitation;

  final List<String> _limitations = [
    'Lack of Consistency',
    'Poor Nutrition Habits',
    'Lack of Support',
    'Busy Schedule',
    'Lack of a Structured Plan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                  const Text(
                  'What\'s limiting your progress right now?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 40),

                Expanded(
                  child: ListView.separated(
                    itemCount: _limitations.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final limitation = _limitations[index];
                      final bool isSelected = _selectedLimitation == limitation;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLimitation = limitation;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey.shade100 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getIconForLimitation(limitation),
                                size: 24,
                                color: isSelected ? Colors.black : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                limitation,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Row(
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
                      child: ElevatedButton(
                        onPressed: _selectedLimitation == null
                            ? null
                            : () {                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdvancedSettingsScreen(
                                      gender: widget.gender,
                                      weight: widget.weight,
                                      isWeightInKg: widget.isWeightInKg,
                                      height: widget.height,
                                      isHeightInCm: widget.isHeightInCm,
                                      age: widget.age,
                                      activityLevel: widget.activityLevel,
                                      goal: widget.goal,
                                      targetWeight: widget.targetWeight,
                                      pace: widget.pace,
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          disabledBackgroundColor: Colors.grey[300],
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForLimitation(String limitation) {
    switch (limitation) {
      case 'Lack of Consistency':
        return Icons.repeat;
      case 'Poor Nutrition Habits':
        return Icons.restaurant;
      case 'Lack of SUpport':
        return Icons.people;
      case 'Busy Schedule':
        return Icons.schedule;
      case 'Lack of a Structured Plan':
        return Icons.assignment;
      default:
        return Icons.info;
    }
  }
}
