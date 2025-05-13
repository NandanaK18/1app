import 'package:flutter/material.dart';
import 'activity_level_screen.dart';

class AgeSelectionScreen extends StatefulWidget {
  final String gender;
  final double weight;
  final bool isWeightInKg;
  final double height;
  final bool isHeightInCm;

  const AgeSelectionScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.isWeightInKg,
    required this.height,
    required this.isHeightInCm,
  });

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  // Date controllers
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController yearController;
    // Default to current date - 30 years
  late DateTime selectedDate;
  
  // Calculated age in years
  int ageYears = 0;

  // Lists for the pickers
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  final int startYear = DateTime.now().year - 100; // 100 years ago
  final int endYear = DateTime.now().year; // Current year
  
  @override
  void initState() {
    super.initState();
    // Initialize with a default date (30 years ago)
    selectedDate = DateTime(
      DateTime.now().year - 30,
      DateTime.now().month,
      DateTime.now().day,
    );
    
    _initializeControllers();
    _calculateAge();
  }
  
  @override
  void dispose() {
    monthController.dispose();
    dayController.dispose();
    yearController.dispose();
    super.dispose();
  }
  
  void _initializeControllers() {
    // Month is 0-based index in selectedDate but 1-based in UI
    monthController = FixedExtentScrollController(initialItem: selectedDate.month - 1);
    dayController = FixedExtentScrollController(initialItem: selectedDate.day - 1);
    yearController = FixedExtentScrollController(initialItem: selectedDate.year - startYear);
  }
  
  // Gets the number of days in the selected month and year
  int _getDaysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }
  
  // Updates the selected date based on the wheel positions
  void _updateSelectedDate({int? month, int? day, int? year}) {
    final updatedMonth = month ?? selectedDate.month;
    final updatedYear = year ?? selectedDate.year;
    
    // Calculate max days in the selected month
    final maxDays = _getDaysInMonth(updatedMonth - 1, updatedYear);
    
    // Ensure day is valid
    int updatedDay = day ?? selectedDate.day;
    if (updatedDay > maxDays) {
      updatedDay = maxDays;
      // If we're changing the month/year and current day becomes invalid,
      // update the day controller too
      if (day == null) {
        dayController.jumpToItem(updatedDay - 1);
      }
    }
    
    setState(() {
      selectedDate = DateTime(updatedYear, updatedMonth, updatedDay);
      _calculateAge();
    });
  }
    // Calculate age based on the selected date
  void _calculateAge() {
    final now = DateTime.now();
    final difference = now.difference(selectedDate);
    
    // Simple calculation for age in years
    ageYears = (difference.inDays / 365.25).floor();
    
    // We're not calculating months anymore since we only display years
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
                // Extra space at the top
                const SizedBox(height: 60),
                
                // Title
                const Text(
                  'When\'s Your Birthday?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This helps us personalize your experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Display calculated age
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [                      Text(
                        'Your Age',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$ageYears years',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Instruction text
                Text(
                  'Scroll to select your birth date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Date selector wheels
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
                      height: 180,
                      child: Row(
                        children: [
                          // Month wheel
                          Expanded(
                            flex: 4,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              diameterRatio: 1.5,
                              perspective: 0.01,
                              physics: const FixedExtentScrollPhysics(),
                              controller: monthController,
                              onSelectedItemChanged: (index) {
                                _updateSelectedDate(month: index + 1);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: months.length,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      months[index],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          
                          // Day wheel
                          Expanded(
                            flex: 2,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              diameterRatio: 1.5,
                              perspective: 0.01,
                              physics: const FixedExtentScrollPhysics(),
                              controller: dayController,
                              onSelectedItemChanged: (index) {
                                _updateSelectedDate(day: index + 1);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: _getDaysInMonth(selectedDate.month - 1, selectedDate.year),
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          
                          // Year wheel
                          Expanded(
                            flex: 3,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 50,
                              diameterRatio: 1.5,
                              perspective: 0.01,
                              physics: const FixedExtentScrollPhysics(),
                              controller: yearController,
                              onSelectedItemChanged: (index) {
                                _updateSelectedDate(year: index + startYear);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: endYear - startYear + 1,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      '${index + startYear}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
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
                    const SizedBox(width: 16),                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ActivityLevelScreen(
                                gender: widget.gender,
                                weight: widget.weight,
                                isWeightInKg: widget.isWeightInKg,
                                height: widget.height,
                                isHeightInCm: widget.isHeightInCm,
                                birthDate: selectedDate,
                                age: ageYears,
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
