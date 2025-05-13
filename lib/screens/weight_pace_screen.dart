import 'package:flutter/material.dart';
import 'advanced_settings_screen.dart';

class WeightPaceScreen extends StatefulWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;
  final int age;
  final String activityLevel;
  final String goal;
  final double targetWeight;

  const WeightPaceScreen({
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

  @override
  State<WeightPaceScreen> createState() => _WeightPaceScreenState();
}

class _WeightPaceScreenState extends State<WeightPaceScreen> {
  double _pace = 0.8; // Default to recommended pace

  String _getPaceDescription() {
    if (_pace <= 0.4) {
      return 'Slow and steady';
    } else if (_pace <= 1.0) {
      return 'Recommended';
    } else {
      return 'You may feel tired';
    }
  }

  Color _getPaceColor() {
    if (_pace <= 0.4) {
      return Colors.green;
    } else if (_pace <= 1.0) {
      return Color(0xFFE18335); // Same orange as before
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isGaining = widget.targetWeight > widget.weight;

    return Scaffold(      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        const Text(
                          'Pick your pace - how fast should we go?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 16),
                        
                        // Subtitle
                        Text(
                          '${isGaining ? "Gain" : "Lose"} weight pace per week',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 48),
                        
                        // Selected weight display
                        Text(
                          '${_pace.toStringAsFixed(1)} kg',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: _getPaceColor(),
                          ),
                        ),

                        const SizedBox(height: 24),

                // Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _getPaceColor(),
                    inactiveTrackColor: Colors.grey[200],
                    thumbColor: _getPaceColor(),
                    overlayColor: _getPaceColor().withOpacity(0.2),                    trackHeight: 8.0, // Made thicker
                  ),
                  child: Slider(
                    value: _pace,
                    min: 0.1,
                    max: 1.5,
                    divisions: 14, // 0.1 increments
                    label: '${_pace.toStringAsFixed(1)}kg',
                    onChanged: (value) {
                      setState(() {
                        _pace = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 8),
                  // Pace values
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0.1kg',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0.8kg',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1.5kg',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),                // Pace description container
                Container(
                  width: double.infinity, // Make it full width
                  margin: const EdgeInsets.symmetric(horizontal: 16), // Add some margin
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: _getPaceColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getPaceColor(),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getPaceDescription(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _getPaceColor(),
                    ),
                  ),
                ),
                      ],
                    ),
                  ),
                ),

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
                              builder: (context) => AdvancedSettingsScreen(
                                gender: widget.gender,
                                weight: widget.weight,
                                isWeightInKg: widget.isWeightInKg,
                                height: widget.height,
                                isHeightInCm: widget.isHeightInCm,
                                age: widget.age,
                                activityLevel: widget.activityLevel,
                                goal: widget.goal,
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
