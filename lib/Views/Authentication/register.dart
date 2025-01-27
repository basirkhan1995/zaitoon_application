import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Bloc/DatabaseCubit/database_cubit.dart';
import 'package:zaitoon_invoice/Components/Other/extensions.dart';
import 'package:zaitoon_invoice/Components/Widgets/background.dart';
import 'package:zaitoon_invoice/Components/Widgets/inputfield_entitled.dart';
import 'package:zaitoon_invoice/Components/Widgets/language_dropdown.dart';
import 'package:zaitoon_invoice/Json/users.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int _currentStep = 0; // Track the current step
  final int _totalSteps = 3; // Total number of steps
  final form1 = GlobalKey<FormState>();
  final form2 = GlobalKey<FormState>();
  final form3 = GlobalKey<FormState>();

  final businessName = TextEditingController();
  final ownerName = TextEditingController();
  final address = TextEditingController();
  final mobile1 = TextEditingController();
  final mobile2 = TextEditingController();
  final email = TextEditingController();

  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final databaseName = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String? documentDirectory;

  Future<String?> _getDirectoryPath() async {
    Directory? directory = await getApplicationDocumentsDirectory();
    setState(() {
      documentDirectory = directory.path;
    });
    return documentDirectory;
  }

  //To pick a custom directory | Database
  Future<void> _pickDirectory() async {
    String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath == null) {
      await _getDirectoryPath();
    } else {
      setState(() {
        documentDirectory = dirPath;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Request focus for the first TextFormField when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDirectoryPath();
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Dispose of the FocusNode to avoid memory leaks
    focusNode.dispose();
    super.dispose();
  }

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
    if (_currentStep == 0 && form1.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    } else if (_currentStep == 1 && form2.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  Future<void> _create() async {
    if (_currentStep == 2 && form3.currentState!.validate()) {
      final res = await context.read<AuthCubit>().signUpEvent(
          user: Users(
              userRoleId: 1, // Default Admin Role
              userStatus: 1, // Active User
              username: username.text,
              password: password.text,
              mobile1: mobile1.text,
              email: email.text,
              address: address.text,
              businessName: businessName.text,
              ownerName: ownerName.text,
              mobile2: mobile2.text),
          path: documentDirectory ?? "",
          dbName: "${databaseName.text}.db");
      if (res > 0) {
        setState(() {
          Navigator.pop(context);
          context.read<DatabaseCubit>().loadDatabaseEvent();
        });
      }
    }
  }

  // Function to move to the previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else if (_currentStep == 0) {
      Navigator.pop(context);
    }
  }

  // Custom widget for step indicators with different states
  Widget _buildStepIndicator(int index) {
    Color progressColor = Colors.grey;
    double progressValue = 0.0;

    if (index < _currentStep) {
      // Completed step
      progressColor = Colors.green;
      progressValue = 1.0;
    } else if (index == _currentStep) {
      // Current step (in progress)
      progressColor = Theme.of(context).colorScheme.primary;
      progressValue = 0.5;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular progress indicator
        SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            value: progressValue, // Progress value: 0.0 to 1.0
            strokeWidth: 2.0,
            color: progressColor,
            backgroundColor:
                Colors.grey.withValues(alpha: .2), // Background circle
          ),
        ),
        // Icon in the center
        Icon(
          index < _currentStep
              ? Icons.check // Completed step
              : null, // Pending or in-progress step
          color: index < _currentStep
              ? Colors.green
              : (index == _currentStep
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey),
          size: 22,
        ),
      ],
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

  Widget userInformation() {
    return SingleChildScrollView(
      child: Form(
        key: form2,
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
                  controller: username,
                  isRequire: true,
                  title: "Username",
                  icon: Icons.person,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Username is required";
                    }
                    return null;
                  },
                ),
                InputFieldEntitled(
                  securePassword: true,
                  controller: password,
                  isRequire: true,
                  title: "Password",
                  icon: Icons.lock,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                InputFieldEntitled(
                  controller: confirmPassword,
                  securePassword: true,
                  isRequire: true,
                  title: "Re-enter password",
                  icon: Icons.lock,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Re-enter password is required";
                    } else if (password.text != confirmPassword.text) {
                      return "Passwords don't match";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget personalInformation() {
    return Form(
      key: form1,
      child: SingleChildScrollView(
        child: Center(
          child: AppBackground(
            width: 600,
            margin: EdgeInsets.symmetric(vertical: 0),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: InputFieldEntitled(
                        focusNode: focusNode,
                        inputAction: TextInputAction.next,
                        isRequire: true,
                        controller: ownerName,
                        title: "Your Name",
                        icon: Icons.person,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Your Name is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: InputFieldEntitled(
                        inputAction: TextInputAction.next,
                        controller: businessName,
                        isRequire: true,
                        title: "Business Name",
                        icon: Icons.business,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Business Name is required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                InputFieldEntitled(
                    inputAction: TextInputAction.next,
                    title: "Email",
                    icon: Icons.email,
                    controller: email),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: InputFieldEntitled(
                        inputAction: TextInputAction.next,
                        inputFormat: [FilteringTextInputFormatter.digitsOnly],
                        isRequire: true,
                        title: "Moble 1",
                        controller: mobile1,
                        icon: Icons.phone_android_rounded,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mobile is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: InputFieldEntitled(
                          inputFormat: [FilteringTextInputFormatter.digitsOnly],
                          inputAction: TextInputAction.next,
                          title: "Mobile 2",
                          controller: mobile2,
                          icon: Icons.phone_android_rounded),
                    ),
                  ],
                ),
                InputFieldEntitled(
                  inputAction: TextInputAction.done,
                  controller: address,
                  isRequire: true,
                  title: "Address",
                  icon: Icons.phone_android_rounded,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget databaseInformation() {
    return Form(
      key: form3,
      child: SingleChildScrollView(
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
                  info: documentDirectory ?? "",
                  inputFormat: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ], // Deny space characters],
                  trailing: IconButton(
                      onPressed: _pickDirectory, icon: Icon(Icons.folder)),
                  inputAction: TextInputAction.done,
                  controller: databaseName,
                  title: "Database Name",
                  icon: Icons.storage,
                  onChanged: (text) {
                    databaseName.text.removeWhiteSpace(databaseName.text);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Database is required";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Initialize stepContents inside the build method or in a method that can access instance methods.
  List<Widget> stepContents() {
    return [
      personalInformation(), // Step 1 content
      userInformation(), // Step 2 content
      databaseInformation(), // Step 3 content
    ];
  }

  Widget stepperHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(_totalSteps, (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStepIndicator(index),
            if (index < _totalSteps - 1)
              Container(
                width: 20,
                margin: EdgeInsets.symmetric(horizontal: 11),
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: AppBackground(
        width: 600,
        child: Row(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _previousStep,
              child: Text(_currentStep == 0 ? 'Back' : 'Previous'),
            ),
            TextButton(
              onPressed: _currentStep == 2 ? _create : _nextStep,
              child: Text(_currentStep == 2 ? 'Create' : 'Next'),
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
          stepperHeader(),
          const SizedBox(height: 5),
          stepperTitles(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    databaseName.text = businessName.text.removeWhiteSpace(businessName.text);
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Company"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            stepper(),
            registerForm(_currentStep), // Show the content widget dynamically
            actionButton(), // Navigation buttons
          ],
        ),
      ),
    );
  }

  Widget registerForm(int step) {
    switch (step) {
      case 0:
        return personalInformation();
      case 1:
        return userInformation();
      case 2:
        return databaseInformation();
      default:
        return const Text('Unknown Step');
    }
  }
}
