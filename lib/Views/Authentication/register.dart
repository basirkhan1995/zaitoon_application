import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int _currentStep = 0; // Track the current step
  final int _totalSteps = 3; // Total number of steps

  // Step titles
  final List<String> steps = [
    'Step 1',
    'Step 2',
    'Step 3',
  ];

  final List<String> stepsTitle = [
    'General',
    'User Account',
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
    Color borderColor = Colors.transparent;
    Color backgroundColor =
        Theme.of(context).colorScheme.primary.withValues(alpha: .5);
    Widget icon = Icon(Icons.circle_outlined, color: Colors.transparent);

    if (index == _currentStep) {
      borderColor = Theme.of(context).colorScheme.primary;
      backgroundColor = Theme.of(context).colorScheme.surface;
      icon = Icon(Icons.circle, color: Theme.of(context).colorScheme.primary);
    } else if (index < _currentStep) {
      borderColor = Colors.green;
      backgroundColor = Colors.green.withValues(alpha: .2);
      icon = Icon(Icons.check, color: Colors.green);
    }

    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
        color: backgroundColor,
      ),
      child: icon,
    );
  }

  Widget appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.clear,
                size: 20,
              )),
          Text("REGISTER")
        ],
      ),
    );
  }

  Widget companyInformation() {
    return SingleChildScrollView(
      child: Center(
        child: AppBackground(
          width: 600,
          margin: EdgeInsets.symmetric(vertical: 0),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputFieldEntitled(
                title: "Full Name",
                icon: Icons.person,
              ),
              InputFieldEntitled(title: "Business Name", icon: Icons.business),
            ],
          ),
        ),
      ),
    );
  }

  Widget personalInformation() {
    return SingleChildScrollView(
      child: Center(
        child: AppBackground(
          width: 600,
          margin: EdgeInsets.symmetric(vertical: 0),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputFieldEntitled(
                  title: "Phone", icon: Icons.phone_android_rounded),
              InputFieldEntitled(
                  title: "Telephone", icon: Icons.phone_android_rounded),
              InputFieldEntitled(title: "Email", icon: Icons.email),
              InputFieldEntitled(
                  title: "Address", icon: Icons.phone_android_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget databaseInformation() {
    return SingleChildScrollView(
      child: Center(
        child: AppBackground(
          width: 600,
          margin: EdgeInsets.symmetric(vertical: 0),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputFieldEntitled(title: "Database Name", icon: Icons.storage),
            ],
          ),
        ),
      ),
    );
  }

  // Initialize stepContents inside the build method or in a method that can access instance methods.
  List<Widget> stepContents() {
    return [
      personalInformation(), // Step 1 content
      companyInformation(), // Step 2 content
      databaseInformation(), // Step 3 content
    ];
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(_totalSteps, (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStepIndicator(index),
            if (index < _totalSteps - 1)
              Container(
                width: 200,
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 2,
                color: index < _currentStep
                    ? Colors.green
                    : index == _currentStep
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
              ),
          ],
        );
      }),
    );
  }

  Widget stepperTitles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_totalSteps, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              steps[index],
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Text(
              stepsTitle[index],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            Text(
              index == _currentStep
                  ? "In progress"
                  : index < _currentStep
                      ? "Completed"
                      : "Pending",
              style: TextStyle(
                  fontSize: 11,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppBackground(
        width: 600,
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
      ),
    );
  }

  Widget stepper() {
    return AppBackground(
      width: 600,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 5),
          stepperTitles(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget content() {
    // Use AnimatedSwitcher to switch content based on the current step
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: stepContents()[
          _currentStep], // Return the widget for the current step
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appBar(),
          stepper(),
          content(), // Show the content widget dynamically
          actionButton(), // Navigation buttons
        ],
      ),
    );
  }
}
