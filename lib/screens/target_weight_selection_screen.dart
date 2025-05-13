import 'package:flutter/material.dart';
import 'advanced_settings_screen.dart';
import 'weight_goal_confirmation_screen.dart';

class TargetWeightSelectionScreen extends StatefulWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final DateTime birthDate;
  final int age;
  final String activityLevel;
  final String goal;

  const TargetWeightSelectionScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
    required this.birthDate,
    required this.age,
    required this.activityLevel,
    required this.goal,
  });

  @override
  State<TargetWeightSelectionScreen> createState() => _TargetWeightSelectionScreenState();
}

class _TargetWeightSelectionScreenState extends State<TargetWeightSelectionScreen> {
  late bool isKg;
  late double targetWeight;
  late double initialWeight;
  late String currentGoal;
  late FixedExtentScrollController wholeNumberController;
  late FixedExtentScrollController decimalController;

  @override
  void initState() {
    super.initState();
    isKg = widget.isWeightInKg;
    initialWeight = widget.weight;
    currentGoal = widget.goal;
    
    // Set initial target weight based on goal
    if (widget.goal == 'Gain Weight') {
      targetWeight = widget.weight + (isKg ? 10 : 22); // +10kg or +22lbs
    } else if (widget.goal == 'Lose Weight') {
      targetWeight = widget.weight - (isKg ? 10 : 22); // -10kg or -22lbs
    } else {
      targetWeight = widget.weight;
    }
    
    _initializeControllers();
  }

  void _initializeControllers() {
    final wholeNumber = targetWeight.floor();
    final decimal = ((targetWeight - wholeNumber) * 10).round();
    
    wholeNumberController = FixedExtentScrollController(
      initialItem: _getInitialWholeNumberIndex(wholeNumber),
    );
    decimalController = FixedExtentScrollController(
      initialItem: decimal,
    );
  }

  @override
  void dispose() {
    wholeNumberController.dispose();
    decimalController.dispose();
    super.dispose();
  }

  int _getInitialWholeNumberIndex(int value) {
    if (isKg) {
      return value - 40; // Starting from 40kg
    } else {
      return value - 88; // Starting from 88lbs
    }
  }

  int _getMinWeight() {
    return isKg ? 40 : 88;
  }

  int _getMaxWeight() {
    return isKg ? 160 : 352;
  }  void _toggleUnit() {
    setState(() {
      if (isKg) {
        // Convert kg to lbs
        targetWeight = targetWeight * 2.20462;
        initialWeight = initialWeight * 2.20462;
        isKg = false;
      } else {
        // Convert lbs to kg
        targetWeight = targetWeight / 2.20462;
        initialWeight = initialWeight / 2.20462;
        isKg = true;
      }

      // Reinitialize controllers for the new unit
      final wholeNumber = targetWeight.floor();
      final decimal = ((targetWeight - wholeNumber) * 10).round();
      
      wholeNumberController.jumpToItem(_getInitialWholeNumberIndex(wholeNumber));
      decimalController.jumpToItem(decimal);
      
      // Update goal based on new unit
      currentGoal = _determineGoal(targetWeight);
    });
  }

  String _determineGoal(double currentWeight) {
    double difference = currentWeight - initialWeight;
    if (difference.abs() < 0.5) {
      return 'Maintain Weight';
    } else if (difference > 0) {
      return 'Gain Weight';
    } else {
      return 'Lose Weight';
    }
  }

  void _updateGoalAndWeight(double newWeight) {
    setState(() {
      targetWeight = newWeight;
      currentGoal = _determineGoal(newWeight);
    });
  }

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
                
                // Title text
                Text(
                  'Choose your desired weight?',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),
                  // Goal type indicator
                Text(
                  currentGoal,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 32),
                
                // Unit toggle
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: isKg ? null : _toggleUnit,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: isKg ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'kg',
                              style: TextStyle(
                                color: isKg ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: isKg ? _toggleUnit : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: !isKg ? Colors.black : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'lbs',
                              style: TextStyle(
                                color: !isKg ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),                // Weight selector
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Whole number picker
                      SizedBox(
                        width: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Selection indicator overlay
                            Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            ListWheelScrollView.useDelegate(
                              controller: wholeNumberController,
                              itemExtent: 50,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),                              onSelectedItemChanged: (index) {
                                final decimal = targetWeight - targetWeight.floor();
                                final newWeight = (index + _getMinWeight()) + decimal;
                                _updateGoalAndWeight(newWeight);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: _getMaxWeight() - _getMinWeight() + 1,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      '${index + _getMinWeight()}',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Decimal point
                      const Text(
                        '.',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      // Decimal picker
                      SizedBox(
                        width: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Selection indicator overlay
                            Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            ListWheelScrollView.useDelegate(
                              controller: decimalController,
                              itemExtent: 50,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),                              onSelectedItemChanged: (index) {
                                final wholeNumber = targetWeight.floor();
                                final newWeight = wholeNumber + (index / 10);
                                _updateGoalAndWeight(newWeight);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 10,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      '$index',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Units
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          isKg ? 'kg' : 'lbs',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

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
                          if (currentGoal == 'Maintain Weight') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdvancedSettingsScreen(
                                  gender: widget.gender,
                                  weight: widget.weight,
                                  isWeightInKg: isKg,
                                  height: widget.height,
                                  isHeightInCm: widget.isHeightInCm,
                                  age: widget.age,
                                  activityLevel: widget.activityLevel,
                                  goal: currentGoal,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeightGoalConfirmationScreen(
                                  gender: widget.gender,
                                  weight: initialWeight,
                                  isWeightInKg: isKg,
                                  height: widget.height,
                                  isHeightInCm: widget.isHeightInCm,
                                  age: widget.age,
                                  activityLevel: widget.activityLevel,
                                  goal: currentGoal,
                                  targetWeight: targetWeight,
                                ),
                              ),
                            );
                          }
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
