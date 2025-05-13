import 'package:flutter/material.dart';

class HeightSelectionScreen extends StatefulWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;

  const HeightSelectionScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
  });

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  // Height in cm (stored internally as cm)
  double height = 170.0;
  bool isCm = true;

  // Scroll controllers for cm wheel
  late FixedExtentScrollController cmController;
  
  // Scroll controllers for feet and inches wheels
  late FixedExtentScrollController feetController;
  late FixedExtentScrollController inchesController;

  // Conversion constants
  static const double cmToFeet = 0.0328084;
  static const int inchesPerFoot = 12;

  // Height range limits in cm
  static const double minHeightCm = 120.0;
  static const double maxHeightCm = 220.0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    cmController.dispose();
    feetController.dispose();
    inchesController.dispose();
    super.dispose();
  }
  void _initializeControllers() {
    // Initialize controllers
    final int cmValue = height.round() - minHeightCm.round();
    final int feet = (height * cmToFeet).floor();
    final int inches = ((height * cmToFeet - feet) * inchesPerFoot).round();
    
    cmController = FixedExtentScrollController(initialItem: cmValue);
    feetController = FixedExtentScrollController(initialItem: feet - 3); // Starting from 3'
    inchesController = FixedExtentScrollController(initialItem: inches);
  }

  void _updateControllers() {
    if (isCm) {
      cmController.jumpToItem(height.round() - minHeightCm.round());
    } else {
      final feet = (height * cmToFeet).floor();
      final inches = ((height * cmToFeet - feet) * inchesPerFoot).round();
      
      feetController.jumpToItem(feet - 3); // Starting from 3'
      inchesController.jumpToItem(inches);
    }
  }

  // Convert cm to feet and inches as a formatted string
  String get heightInFeetAndInches {
    final totalFeet = height * cmToFeet;
    final feet = totalFeet.floor();
    final inches = ((totalFeet - feet) * inchesPerFoot).round();
    return "$feet' $inches\"";
  }

  void updateHeight(double newHeightCm) {
    setState(() {
      height = newHeightCm.clamp(minHeightCm, maxHeightCm);
    });
  }

  void updateHeightFromFeetAndInches(int feet, int inches) {
    final heightInCm = ((feet + (inches / inchesPerFoot)) / cmToFeet);
    updateHeight(heightInCm);
  }

  void toggleUnit() {
    setState(() {
      isCm = !isCm;
      // Update the wheel positions when switching units
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateControllers();
      });
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
                // Extra space at the top to move content down
                const SizedBox(height: 60),
                
                // Title moved down
                const Text(
                  'What\'s Your Height?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This helps us calculate your body metrics',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Instruction text
                Text(
                  'Scroll to select your height',
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
                      isSelected: [isCm, !isCm],
                      onPressed: (index) {
                        if ((index == 0 && !isCm) || (index == 1 && isCm)) {
                          toggleUnit();
                        }
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('cm', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('ft', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Height selector wheels
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
                      child: isCm ? _buildCmPicker() : _buildFeetInchesPicker(),
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
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to the next screen
                          print('Selected height: ${height.round()} cm (${heightInFeetAndInches})');
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
  
  Widget _buildCmPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Wheel for cm values
        SizedBox(
          width: 80,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            diameterRatio: 1.5,
            perspective: 0.01,
            physics: const FixedExtentScrollPhysics(),
            controller: cmController,
            onSelectedItemChanged: (index) {
              updateHeight((index + minHeightCm.round()).toDouble());
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: (maxHeightCm - minHeightCm).round() + 1,
              builder: (context, index) {
                final value = index + minHeightCm.round();
                return Center(
                  child: Text(
                    '$value',
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
        
        // Unit indicator for cm
        SizedBox(
          width: 50,
          child: Center(
            child: Text(
              'cm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeetInchesPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Wheel for feet
        SizedBox(
          width: 60,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            diameterRatio: 1.5,
            perspective: 0.01,
            physics: const FixedExtentScrollPhysics(),
            controller: feetController,
            onSelectedItemChanged: (index) {
              final feet = index + 3; // Starting from 3'
              final inches = ((height * cmToFeet - (height * cmToFeet).floor()) * inchesPerFoot).round();
              updateHeightFromFeetAndInches(feet, inches);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 8, // 3' to 7'
              builder: (context, index) {
                final value = index + 3; // Starting from 3'
                return Center(
                  child: Text(
                    '$value',
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
        
        // Feet symbol
        SizedBox(
          width: 20,
          child: Center(
            child: Text(
              '\'',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
        
        // Wheel for inches
        SizedBox(
          width: 60,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            diameterRatio: 1.5,
            perspective: 0.01,
            physics: const FixedExtentScrollPhysics(),
            controller: inchesController,
            onSelectedItemChanged: (index) {
              final feet = (height * cmToFeet).floor();
              updateHeightFromFeetAndInches(feet, index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 12, // 0" to 11"
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
        
        // Inches symbol
        SizedBox(
          width: 20,
          child: Center(
            child: Text(
              '"',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
