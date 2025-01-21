import 'package:flutter/material.dart';

class CustomStepperPage extends StatefulWidget {
  const CustomStepperPage({super.key});

  @override
  State<CustomStepperPage> createState() => _CustomStepperPageState();
}

class _CustomStepperPageState extends State<CustomStepperPage> {
  int _currentStep = 0; // Track the current step
  final int _totalSteps = 3; // Total number of steps

  // Step titles and content
  final List<String> stepTitles = ['Step 1', 'Step 2', 'Step 3'];
  final List<String> stepContents = [
    'This is the content for step 1.',
    'This is the content for step 2.',
    'This is the content for step 3.'
  ];

  final List<String> steps = [
    'Step 1',
    'Step 2',
    'Step 3',
  ];

  final List<String> stepsTitle = [
    'General Details',
    'User Credentials',
    'Database',
  ];

  // Function to move to the next step
  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  // Function to move to the previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // Custom widget for step indicators with different states
  Widget _buildStepIndicator(int index) {
    Color borderColor = Colors.grey;
    Color backgroundColor = Colors.transparent;
    Widget icon = Icon(Icons.circle_outlined, color: Colors.grey);

    if (index == _currentStep) {
      borderColor = Theme.of(context).primaryColor;
      backgroundColor = Theme.of(context).primaryColor.withOpacity(0.2);
      icon = Icon(Icons.circle, color: Theme.of(context).primaryColor);
    } else if (index < _currentStep) {
      borderColor = Colors.green;
      backgroundColor = Colors.green.withOpacity(0.2);
      icon = Icon(Icons.check, color: Colors.green);
    }

    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
        color: backgroundColor,
      ),
      child: icon,
    );
  }

  Widget _header() {
    return // Step indicators with horizontal line
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (index) {
        return Row(
          children: [
            // Build step icon
            _buildStepIndicator(index),
            // Add horizontal line between step indicators
            // if (index < _totalSteps - 1)
            //   Container(
            //     margin: EdgeInsets.symmetric(horizontal: 8),
            //     width: 140,
            //     height: 2,
            //     color: index < _currentStep
            //         ? Colors.green
            //         : index == _currentStep
            //             ? Theme.of(context).primaryColor
            //             : Colors.grey,
            //   ),
          ],
        );
      }),
    );
  }

  Widget _titles() {
    return // Step titles and content with status
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_totalSteps, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              steps[index],
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              stepsTitle[index],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              index == _currentStep
                  ? "In progress"
                  : index < _currentStep
                      ? "Completed"
                      : "Pending",
              style: TextStyle(
                  color: index == _currentStep
                      ? Colors.blue
                      : index < _currentStep
                          ? Colors.green
                          : Colors.grey),
            ),
          ],
        );
      }),
    );
  }

  Widget actionButton() {
    return // Navigation buttons
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 50,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _previousStep,
            child: const Text('Previous'),
          ),
          ElevatedButton(
            onPressed: _nextStep,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget stepper() {
    return Column(
      children: [
        _header(),
        const SizedBox(height: 15),
        _titles(),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget content() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        stepContents[_currentStep],
        key: ValueKey<int>(_currentStep),
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stepper
          stepper(),

          // Step Content
          Expanded(
            child: content(),
          ),

          //Step Action
          actionButton(),
        ],
      ),
    );
  }
}
