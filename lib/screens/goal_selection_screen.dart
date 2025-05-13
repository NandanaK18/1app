import 'package:flutter/material.dart';
import 'advanced_settings_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final DateTime birthDate;
  final int age;
  final String activityLevel;

  const GoalSelectionScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.birthDate,
    required this.age,
    required this.activityLevel,
  });

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  // Goal options with calorie adjustment factors
  final List<Map<String, dynamic>> goals = [
    {
      'id': 'lose_weight',
      'title': 'Lose Weight',
      'description': 'Calorie deficit to lose body fat',
      'icon': Icons.trending_down,
      'calorie_factor': 0.8, // 20% deficit
    },
    {
      'id': 'maintain_weight',
      'title': 'Maintain Weight',
      'description': 'Balanced calories for weight maintenance',
      'icon': Icons.balance,
      'calorie_factor': 1.0, // Maintenance
    },
    {
      'id': 'gain_weight',
      'title': 'Gain Weight',
      'description': 'Calorie surplus to build muscle',
      'icon': Icons.trending_up,
      'calorie_factor': 1.2, // 20% surplus
    },
  ];

  String selectedGoal = 'maintain_weight'; // Default selection

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
                const SizedBox(height: 40),
                
                // Title text
                const Text(
                  "What's your primary goal?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Goal options
                Expanded(
                  child: ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      final isSelected = goal['id'] == selectedGoal;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGoal = goal['id'];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey.shade100 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Icon
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.black : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    goal['icon'],
                                    color: isSelected ? Colors.white : Colors.grey.shade700,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Title and description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        goal['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        goal['description'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Checkmark
                                if (isSelected)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Navigation buttons
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
                      child: ElevatedButton(                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdvancedSettingsScreen(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
