import 'package:flutter/material.dart';
import 'height_selection_screen.dart';

class WeightSelectionScreen extends StatefulWidget {
  final String gender;
  
  const WeightSelectionScreen({
    super.key, 
    required this.gender,
  });

  @override
  State<WeightSelectionScreen> createState() => _WeightSelectionScreenState();
}

class _WeightSelectionScreenState extends State<WeightSelectionScreen> {
  double weight = 70.0; // Default weight in kg
  bool isKg = true; // Default unit is kg
  
  // Scroll controllers for the wheel pickers
  late FixedExtentScrollController wholeNumberController;
  late FixedExtentScrollController decimalController;
  
  // Conversion constants
  static const double kgToPounds = 2.20462;
  static const double poundsToKg = 0.453592;

  // Weight range limits in kg
  static const double minWeightKg = 30.0;
  static const double maxWeightKg = 250.0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }
  
  @override
  void dispose() {
    wholeNumberController.dispose();
    decimalController.dispose();
    super.dispose();
  }
  
  void _initializeControllers() {
    final wholeNumber = displayWeight.floor();
    final decimal = ((displayWeight - wholeNumber) * 10).round();
    
    wholeNumberController = FixedExtentScrollController(initialItem: wholeNumber);
    decimalController = FixedExtentScrollController(initialItem: decimal);
  }
  
  void _updateControllers() {
    final wholeNumber = displayWeight.floor();
    final decimal = ((displayWeight - wholeNumber) * 10).round();
    
    wholeNumberController.jumpToItem(wholeNumber);
    decimalController.jumpToItem(decimal);
  }

  double get displayWeight {
    return isKg ? weight : weight * kgToPounds;
  }

  void updateWeight(double newValue) {
    setState(() {
      if (isKg) {
        weight = newValue.clamp(minWeightKg, maxWeightKg);
      } else {
        // Convert pounds to kg for internal storage
        weight = (newValue * poundsToKg).clamp(minWeightKg, maxWeightKg);
      }
    });
  }

  void toggleUnit() {
    setState(() {
      isKg = !isKg;
      // Update the wheel positions when switching units
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateControllers();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar to allow content to be positioned from the top
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [                // Extra space at the top to move content further down
                const SizedBox(height: 60),
                
                // Title moved down
                const Text(
                  'What\'s Your Weight?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This helps us calculate your daily nutritional needs',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Instruction text
                Text(
                  'Scroll to select your weight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Unit toggle button
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ToggleButtons(
                      constraints: const BoxConstraints(minWidth: 60, minHeight: 36),
                      borderRadius: BorderRadius.circular(20),
                      borderColor: Colors.transparent,
                      selectedBorderColor: Colors.transparent,
                      fillColor: Colors.black,
                      selectedColor: Colors.white,
                      color: Colors.black,
                      isSelected: [isKg, !isKg],
                      onPressed: (index) {
                        if ((index == 0 && !isKg) || (index == 1 && isKg)) {
                          toggleUnit();
                        }
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('kg', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('lb', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Weight selector wheels
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Selection indicator overlay
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // Wheels container
                    SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Wheel for whole numbers
                          SizedBox(
                            width: 80,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              diameterRatio: 1.5,
                              perspective: 0.01,
                              physics: const FixedExtentScrollPhysics(),
                              controller: wholeNumberController,
                              onSelectedItemChanged: (index) {
                                double decimal = (displayWeight - displayWeight.floor()) * 10;
                                double newValue = index.toDouble() + (decimal / 10);
                                updateWeight(newValue);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: isKg 
                                    ? maxWeightKg.floor() + 1 
                                    : (maxWeightKg * kgToPounds).floor() + 1,
                                builder: (context, index) {
                                  final min = isKg ? minWeightKg.floor() : (minWeightKg * kgToPounds).floor();
                                  final isEnabled = index >= min;
                                  
                                  return Center(
                                    child: Text(
                                      '$index',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.normal,
                                        color: isEnabled ? Colors.black : Colors.grey.shade300,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Decimal point
                          const Text(
                            '.',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Wheel for decimal values
                          SizedBox(
                            width: 70,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              diameterRatio: 1.5,
                              perspective: 0.01,
                              physics: const FixedExtentScrollPhysics(),
                              controller: decimalController,
                              onSelectedItemChanged: (index) {
                                double newValue = displayWeight.floor() + (index / 10);
                                updateWeight(newValue);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 10, // 0-9 after decimal
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
                          ),
                          
                          // Unit indicator
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: Text(
                                isKg ? 'kg' : 'lb',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Spacer(),
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
                      child: ElevatedButton(                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HeightSelectionScreen(
                                gender: widget.gender,
                                weight: weight,
                                isWeightInKg: isKg,
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
