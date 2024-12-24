import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activities in Boumerdès',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ActivitiesPage(),
    );
  }
}

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  bool _showCards = false;
  late Map<String, List<Map<String, dynamic>>> groupedActivities;

  final String jsonResponse = '{"data": [{"id": 3, "documentId": "ufbczj7291w0ix7bdovqkhb7", "name": "activity one", "type": "Scientifique", "startTime": "2024-12-11", "duration": "20 days", "place": "test place", "createdAt": "2024-12-20T14:55:52.085Z", "updatedAt": "2024-12-20T14:57:13.453Z", "publishedAt": "2024-12-20T14:57:13.468Z"}, {"id": 13, "documentId": "lvfvodyl6487oi57hbumwygd", "name": "test", "type": "Culturel", "startTime": "2024-12-25", "duration": "20 days", "place": "test placed", "createdAt": "2024-12-20T15:26:30.264Z", "updatedAt": "2024-12-20T15:26:30.264Z", "publishedAt": "2024-12-20T15:26:30.272Z"}]}';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showCards = true;
      });
    });

    groupedActivities = _parseAndGroupActivities(jsonDecode(jsonResponse)['data']);
  }

  Map<String, List<Map<String, dynamic>>> _parseAndGroupActivities(List<dynamic> data) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in data) {
      final type = item['type'];
      if (!grouped.containsKey(type)) {
        grouped[type] = [];
      }
      grouped[type]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        elevation: 0,
        title: Text(
          "Activities in Boumerdès",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 1000),
          opacity: _showCards ? 1.0 : 0.0,
          child: ListView(
            children: groupedActivities.entries.map((entry) {
              return Column(
                children: [
                  _buildActivityCard(
                    title: '${entry.key} Activities',
                    description: 'Explore ${entry.key.toLowerCase()} activities in Boumerdès.',
                    icon: entry.key == 'Scientifique' ? Icons.science : Icons.cabin,
                    onTap: () => _navigateToActivitiesPage(context, entry.value),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.yellowAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToActivitiesPage(BuildContext context, List<Map<String, dynamic>> activities) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivitiesListPage(activities: activities),
      ),
    );
  }
}

class ActivitiesListPage extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  ActivitiesListPage({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(
          "Activities List",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            return _buildActivityCard(
              title: activities[index]['name'],
              description: 'Start Time: ${activities[index]['startTime']}\nDuration: ${activities[index]['duration']}\nPlace: ${activities[index]['place']}',
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String description,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.yellowAccent.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
