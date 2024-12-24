import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled/model/Base%20Url.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cartIdController = TextEditingController();
  final TextEditingController _dateOfComingController = TextEditingController();
  final TextEditingController _dateOfLeavingController = TextEditingController();
  String? _registerType;

  // Backend URL
  final String backendUrl = '${BaseUrl().base_url}reservations/reserve'; // Replace with actual URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        elevation: 5,
        title: Text(
          "Register for Lodge",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: ListView(
            children: [
              _buildIntroSection(),
              SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildCartIdField(),
                    SizedBox(height: 16),
                    _buildDateOfComingField(),
                    SizedBox(height: 16),
                    _buildDateOfLeavingField(),
                    SizedBox(height: 16),
                    _buildRegisterTypeField(),
                    SizedBox(height: 24),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Welcome to the Lodge Registration!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please provide the required details to complete your registration.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCartIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cart ID:", style: TextStyle(fontSize: 16)),
        TextFormField(
          controller: _cartIdController,
          decoration: InputDecoration(
            labelText: 'Enter Cart ID',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Cart ID is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateOfComingField() {
    return TextFormField(
      controller: _dateOfComingController,
      decoration: InputDecoration(
        labelText: 'Date of Coming',
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: _pickDateOfComing,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date of Coming is required';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfLeavingField() {
    return TextFormField(
      controller: _dateOfLeavingController,
      decoration: InputDecoration(
        labelText: 'Date of Leaving',
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: _pickDateOfLeaving,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date of Leaving is required';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterTypeField() {
    return DropdownButtonFormField<String>(
      value: _registerType,
      decoration: InputDecoration(
        labelText: 'Register Type',
        border: OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(value: 'free', child: Text('Free')),
        DropdownMenuItem(value: 'not_free', child: Text('Not Free')),
        DropdownMenuItem(value: 'not_free_food', child: Text('Not Free with Food')),
      ],
      onChanged: (value) {
        setState(() {
          _registerType = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Register Type is required';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          backgroundColor: Colors.orange[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  // Submit the form and send the data to the backend
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String cartId = _cartIdController.text;
      final String dateOfComing = _dateOfComingController.text;
      final String dateOfLeaving = _dateOfLeavingController.text;

      // Prepare the JSON payload
      final Map<String, dynamic> formData = {
        'fromTime': '${_dateOfComingController.text}:00:00.000Z', // Adjust date format
        'toTime': '${_dateOfLeavingController.text}:00:00.000Z', // Adjust date format
        'aubergeId': 1, // Replace with actual aubergeId
        'userId': 2, // Replace with actual userId
      };

      // Send the data to the backend
      try {
        final response = await http.post(
          Uri.parse(backendUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(formData),
        );

        if (response.statusCode == 200) {
          // Show success message if registration is successful
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Registration Successful'),
                content: Text('Your registration has been successfully processed.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Show error message if something went wrong
          _showErrorDialog('Failed to register. Please try again later.');
        }
      } catch (e) {
        // Show error dialog for network or other errors
        _showErrorDialog('An error occurred. Please check your internet connection.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDateOfComing() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _dateOfComingController.text = date.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _pickDateOfLeaving() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _dateOfLeavingController.text = date.toIso8601String().split('T')[0];
      });
    }
  }
}
