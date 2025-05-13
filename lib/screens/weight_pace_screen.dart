import 'package:flutter/material.dart';
import 'progress_limitations_screen.dart';

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
  late double _pace;
  late double _minPace;
  late double _maxPace;
  late double _defaultPace;

  @override
  void initState() {
    super.initState();
    if (widget.isWeightInKg) {
      _minPace = 0.1;
      _maxPace = 1.5;
      _defaultPace = 0.8;
    } else {
      _minPace = 0.2;
      _maxPace = 3.0;
      _defaultPace = 1.5;
    }
    _pace = _defaultPace;
  }

  String _getPaceDescription() {
    if (widget.isWeightInKg) {
      if (_pace <= 0.4) {
        return 'Slow and steady';
      } else if (_pace <= 1.0) {
        return 'Recommended';
      } else {
        return 'You may feel tired';
      }
    } else {
      if (_pace <= 1.0) {
        return 'Slow and steady';
      } else if (_pace <= 2.0) {
        return 'Recommended';
      } else {
        return 'You may feel tired';
      }
    }
  }

  Color _getPaceColor() {
    if (widget.isWeightInKg) {
      if (_pace <= 0.4) {
        return Colors.green;
      } else if (_pace <= 1.0) {
        return Color(0xFFE18335);
      } else {
        return Colors.red;
      }
    } else {
      if (_pace <= 1.0) {
        return Colors.green;
      } else if (_pace <= 2.0) {
        return Color(0xFFE18335);
      } else {
        return Colors.red;
      }
    }
  }

  String _getTargetDate() {
    final double weightDifference = (widget.targetWeight - widget.weight).abs();
    final int weeksNeeded = (weightDifference / _pace).ceil();
    final DateTime targetDate = DateTime.now().add(Duration(days: weeksNeeded * 7));
    
    return '${targetDate.day} ${_getMonthName(targetDate.month)} ${targetDate.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final bool isGaining = widget.targetWeight > widget.weight;
    final String unit = widget.isWeightInKg ? 'kg' : 'lbs';

    return Scaffold(
      body: Container(
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
                        
                        Text(
                          '${_pace.toStringAsFixed(1)} $unit',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: _getPaceColor(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        SliderTheme(                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: _getPaceColor(),
                            inactiveTrackColor: Colors.grey[200],
                            thumbColor: _getPaceColor(),
                            overlayColor: _getPaceColor().withOpacity(0.2),
                            trackHeight: 8.0,
                            tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 4),
                            activeTickMarkColor: Colors.white,
                            inactiveTickMarkColor: Colors.grey[400],
                          ),
                          child: Slider(                            value: _pace,
                            min: _minPace,
                            max: _maxPace,
                            divisions: widget.isWeightInKg ? 14 : 28, // 14 for 0.1-1.5kg, 28 for 0.2-3.0lbs
                            label: '${_pace.toStringAsFixed(1)} $unit',
                            onChanged: (value) {
                              setState(() {
                                _pace = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 8),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_minPace.toStringAsFixed(1)} $unit',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_defaultPace.toStringAsFixed(1)} $unit',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_maxPace.toStringAsFixed(1)} $unit',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            color: _getPaceColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getPaceColor(),
                              width: 1,
                            ),
                          ),                          child: Column(
                            children: [
                              Text(
                                _getPaceDescription(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _getPaceColor(),
                                ),
                              ),
                              const SizedBox(height: 8),                              Text(
                                'Target date: ${_getTargetDate()}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

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
                            MaterialPageRoute(                              builder: (context) => ProgressLimitationsScreen(
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
