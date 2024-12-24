import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ParametersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(
          'Parameter Page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          // Portfolio Section
          _buildSectionTitle('Portfolio'),
          _buildPortfolioSection(),
          SizedBox(height: 20),

          // Settings Section
          _buildSectionTitle('Settings'),
          _buildSettingsSection(),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange[800]),
      ),
    );
  }

  // Portfolio Section
  Widget _buildPortfolioSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Portfolio Title
          Text(
            'Your Portfolio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),

          // Portfolio Details (For demonstration purposes, this could be updated dynamically)
          Text(
            'View or update your portfolio information here.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),

          // Edit Portfolio Button
          ElevatedButton(
            onPressed: () {
              // Navigate to portfolio editing screen (you can implement the screen)
              Get.to(PortfolioEditPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[800],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            ),
            child: Text('Edit Portfolio', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Settings Section
  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings Title
          Text(
            'Application Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),

          // Notification Setting (Toggle Switch)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Enable Notifications', style: TextStyle(fontSize: 16)),
              Switch(
                value: true, // This value could be dynamic
                onChanged: (value) {
                  // Handle toggle change
                },
                activeColor: Colors.orange[800],
              ),
            ],
          ),
          SizedBox(height: 20),

          // Language Setting (Dropdown)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Language', style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: 'English', // Example value, could be dynamic
                onChanged: (value) {
                  // Handle language change
                },
                items: [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'French', child: Text('French')),
                  DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),

          // Privacy Settings (Button to navigate to settings)
          ElevatedButton(
            onPressed: () {
              // Navigate to privacy settings screen (implement the screen)

              Get.to(PrivacySettingsPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[800],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            ),
            child: Text('Privacy Settings', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Sample Page for Portfolio Edit (you can modify as needed)
class PortfolioEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(
          'Edit Portfolio',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('Portfolio Edit Page (Customize as needed)'),
      ),
    );
  }
}

// Sample Page for Privacy Settings (you can modify as needed)
class PrivacySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(
          'Privacy Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('Privacy Settings Page (Customize as needed)'),
      ),
    );
  }
}

