import 'package:flutter/material.dart';
import 'summary_screen.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final int age;
  final String activityLevel;
  final String goal;

  const AdvancedSettingsScreen({
    Key? key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.age,
    required this.activityLevel,
    required this.goal,
  }) : super(key: key);

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  bool isAthlete = false;
  bool showBodyFatSlider = false;
  double bodyFatPercentage = 20.0;
  double proteinRatio = 1.8;
  double fatPercentage = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,      appBar: null,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                
                // Title text
                const Text(
                  'Advanced Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 22),
                
                const Text(
                  'Fine-tune your macro distribution and calculation details',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),


                // Athlete Toggle
                Text(
                  'Are you an athlete?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
                          value: false,
                          groupValue: isAthlete,
                          onChanged: (value) {
                            setState(() {
                              isAthlete = value!;
                            });
                          },
                        ),
                      ),
                        Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
                          value: true,
                          groupValue: isAthlete,
                          onChanged: (value) {
                          setState(() {
                            isAthlete = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Body Fat Percentage Section
                Text(
                  'Body Fat Percentage (Optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
                          value: false,
                          groupValue: showBodyFatSlider,
                          onChanged: (value) {
                            setState(() {
                              showBodyFatSlider = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Enter', style: TextStyle(fontWeight: FontWeight.bold)),
                          value: true,
                          groupValue: showBodyFatSlider,
                          onChanged: (value) {
                            setState(() {
                              showBodyFatSlider = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (showBodyFatSlider) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (bodyFatPercentage > 5) {
                                  setState(() {
                                    bodyFatPercentage--;
                                  });
                                }
                              },
                            ),
                            Text(
                              '${bodyFatPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                if (bodyFatPercentage < 40) {
                                  setState(() {
                                    bodyFatPercentage++;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Slider(
                          value: bodyFatPercentage,
                          min: 5,
                          max: 40,
                          divisions: 35,
                          onChanged: (value) {
                            setState(() {
                              bodyFatPercentage = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Athletic: 6-13% | Healthy: 14-24%',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Protein Ratio Section
                Text(
                  'Protein (g per kg of bodyweight)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (proteinRatio > 1.0) {
                                setState(() {
                                  proteinRatio = (proteinRatio - 0.1).clamp(1.0, 2.5);
                                });
                              }
                            },
                          ),
                          Text(
                            '${proteinRatio.toStringAsFixed(1)} g/kg',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              if (proteinRatio < 2.5) {
                                setState(() {
                                  proteinRatio = (proteinRatio + 0.1).clamp(1.0, 2.5);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Slider(
                        value: proteinRatio,
                        min: 1.0,
                        max: 2.5,
                        divisions: 15,
                        onChanged: (value) {
                          setState(() {
                            proteinRatio = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Recommended: 1.6-2.2 g/kg',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Fat Percentage Section
                Text(
                  'Fat (% of total calories)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (fatPercentage > 15) {
                                setState(() {
                                  fatPercentage--;
                                });
                              }
                            },
                          ),
                          Text(
                            '${fatPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              if (fatPercentage < 40) {
                                setState(() {
                                  fatPercentage++;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Slider(
                        value: fatPercentage,
                        min: 15,
                        max: 40,
                        divisions: 25,
                        onChanged: (value) {
                          setState(() {
                            fatPercentage = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Recommended: 20-35%',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // Space for bottom buttons
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
                  Expanded(                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SummaryScreen(
                              gender: widget.gender,
                              weight: widget.weight,
                              isWeightInKg: widget.isWeightInKg,
                              height: widget.height,
                              isHeightInCm: widget.isHeightInCm,
                              age: widget.age,
                              isAthlete: isAthlete,
                              bodyFatPercentage: showBodyFatSlider ? bodyFatPercentage : null,
                              activityLevel: widget.activityLevel,
                              goal: widget.goal,
                              proteinRatio: proteinRatio,
                              fatRatio: fatPercentage,
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
                        'Next',
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
    );
  }
}