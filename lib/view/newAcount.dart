import "package:get/get.dart";
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../controler/controlersavedata.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({required this.height, required this.widthe});

  late final double height;
  late final double widthe;

  @override
  _CreateAccountPageState createState() =>
      _CreateAccountPageState(height: height, widthe: widthe);
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  _CreateAccountPageState({required this.height, required this.widthe});

  late final double height;
  late final double widthe;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _prenameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ControlerSaveData cntrolersavedata = Get.find();
  String? _selectedDate;
  String? _selectedSex;
  final List<String> _sexOptions = ["Male", "Female"];

  // Date Picker Function
  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Image.asset("images/undraw_login_re_4vu2 1.jpg", height: 150),
                  const SizedBox(height: 20),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Create a New Account',
                        textStyle: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    isRepeatingAnimation: false,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon:
                            Icon(Icons.person, color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _prenameController,
                          decoration: InputDecoration(
                            labelText: "Prename",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon:
                            Icon(Icons.person, color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your prename";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          onTap: _showDatePicker,
                          decoration: InputDecoration(
                            labelText: _selectedDate ?? "Date of Birth",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today,
                                color: Colors.orange),
                          ),
                          validator: (value) {
                            if (_selectedDate == null) {
                              return "Please select your date of birth";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _placeOfBirthController,
                          decoration: InputDecoration(
                            labelText: "Place of Birth",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.location_on,
                                color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your place of birth";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSex,
                          decoration: InputDecoration(
                            labelText: "Sex",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon:
                            Icon(Icons.people, color: Colors.orange),
                          ),
                          items: _sexOptions.map((sex) {
                            return DropdownMenuItem<String>(
                              value: sex,
                              child: Text(sex),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select your sex";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.email,
                                color: Colors.orange),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon:
                            Icon(Icons.lock, color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon:
                            Icon(Icons.lock, color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cntrolersavedata.save_data(
                            _passwordController.text,
                            _emailController.text,
                            _selectedSex!,
                            _placeOfBirthController.text,
                            _selectedDate!,
                            _nameController.text,
                            _prenameController.text,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                Text("Account created successfully!")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Please fix the errors in the form")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[800],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 65.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      child: const Text("Register",
                          style: TextStyle(fontSize: 18.0, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
