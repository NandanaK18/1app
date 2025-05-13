import 'package:flutter/material.dart';
import 'goal_selection_screen.dart';

class ActivityLevelScreen extends StatefulWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final DateTime birthDate;
  final int age;

  const ActivityLevelScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.birthDate,
    required this.age,
  });

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  // Activity level options
  final List<Map<String, dynamic>> activityLevels = [
    {
      'id': 'sedentary',
      'title': 'Sedentary',
      'description': 'Little or no exercise, desk job',
      'icon': Icons.weekend,
    },
    {
      'id': 'lightly_active',
      'title': 'Lightly Active',
      'description': 'Light exercise 1-3 days/week',
      'icon': Icons.directions_walk,
    },
    {
      'id': 'moderately_active',
      'title': 'Moderately Active',
      'description': 'Moderate exercise 3-5 days/week',
      'icon': Icons.directions_run,
    },
    {
      'id': 'very_active',
      'title': 'Very Active',
      'description': 'Heavy exercise 6-7 days/week',
      'icon': Icons.fitness_center,
    },
    {
      'id': 'extra_active',
      'title': 'Extra Active',
      'description': 'Very heavy exercise, physical job or training twice a day',
      'icon': Icons.sports_gymnastics,
    },
  ];

  // Selected activity level
  String selectedActivityLevel = 'moderately_active'; // Default selection

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
                // Progress indicator at the top
                // Container(
                //   height: 4,
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade200,
                //     borderRadius: BorderRadius.circular(2),
                //   ),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 85, // Progress percentage
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: Colors.black,
                //             borderRadius: BorderRadius.circular(2),
                //           ),
                //         ),
                //       ),
                //       const Expanded(
                //         flex: 15, // Remaining percentage
                //         child: SizedBox(),
                //       ),
                //     ],
                //   ),
                // ),
                
                const SizedBox(height: 40),
                
                // Title text
                const Text(
                  'How active are you?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Subtitle text
                Text(
                  'Select the option that best describes your typical week.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Activity level options
                Expanded(
                  child: ListView.builder(
                    itemCount: activityLevels.length,
                    itemBuilder: (context, index) {
                      final activityLevel = activityLevels[index];
                      final isSelected = activityLevel['id'] == selectedActivityLevel;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedActivityLevel = activityLevel['id'];
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
                                    activityLevel['icon'],
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
                                        activityLevel['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        activityLevel['description'],
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
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoalSelectionScreen(
                                gender: widget.gender,
                                weight: widget.weight,
                                isWeightInKg: widget.isWeightInKg,
                                height: widget.height,
                                isHeightInCm: widget.isHeightInCm,
                                birthDate: widget.birthDate,
                                age: widget.age,
                                activityLevel: selectedActivityLevel,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
