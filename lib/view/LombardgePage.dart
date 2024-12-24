import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/model/Base%20Url.dart';
import 'package:untitled/view/Registerinlompardge.dart';

class Lodge {
  final String name;
  final int stars;
  final String description;
  final String prix;
  final String local;
  final String capacity;

  Lodge({
    required this.name,
    required this.stars,
    required this.description,
    required this.prix,
    required this.local,
    required this.capacity,
  });

  // Factory method to create Lodge instance from JSON
  factory Lodge.fromJson(Map<String, dynamic> json) {
    return Lodge(
      name: json['name'] ?? 'Unknown Lodge',
      stars: json['stars'] ?? 3,
      description: json['description'] ?? 'No description available',
      prix: '${json['price']} USD/night',
      local: json['place'] ?? 'Unknown Location',
      capacity: '${json['capacity']} guests',
    );
  }
}

class LodgesPage extends StatefulWidget {
  @override
  _LodgesPageState createState() => _LodgesPageState();
}

class _LodgesPageState extends State<LodgesPage> {
  String selectedPriceRange = 'All';
  List<Lodge> lodges = [];

  @override
  void initState() {
    super.initState();
    fetchLodges();
  }

  Future<void> fetchLodges() async {
    try {
      final response = await http.get(Uri.parse('${BaseUrl().base_url}auberges?populate=*'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debugging: Check what is returned

      if (response.statusCode == 200) {
        // If the response is valid JSON
        final data = json.decode(response.body)['data'] as List;
        setState(() {
          lodges = data.map((lodgeJson) => Lodge.fromJson(lodgeJson)).toList();
        });
      } else {
        // If the response status is not 200, throw an exception
        throw Exception('Failed to load lodges, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors here, such as network issues or invalid response format
      print('Error fetching lodges: $e');
      // Optionally, you could show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Lodge> filteredLodges = lodges.where((lodge) {
      if (selectedPriceRange == 'All') return true;
      double lodgePrice = _getPriceAsDouble(lodge.prix);
      switch (selectedPriceRange) {
        case '50-100':
          return lodgePrice >= 50 && lodgePrice <= 100;
        case '101-200':
          return lodgePrice > 100 && lodgePrice <= 200;
        case '201-500':
          return lodgePrice > 200 && lodgePrice <= 500;
        default:
          return false;
      }
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orange[800], // Updated to orange[800]
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  "Lodges",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
                  onPressed: () => _showPriceFilter(),
                ),
              ],
            ),
          ),
          // Body Content
          Expanded(
            child: ListView.builder(
              itemCount: filteredLodges.length,
              itemBuilder: (context, index) {
                final lodge = filteredLodges[index];
                return GestureDetector(
                  onTap: () => _showLodgeDetails(lodge),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(lodge.name),
                      subtitle: Text(lodge.prix),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getPriceAsDouble(String price) {
    return double.tryParse(price.split(' ')[0]) ?? 0.0;
  }

  void _showPriceFilter() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Filter by Price Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  ListTile(
                    title: Text('All'),
                    onTap: () {
                      setState(() {
                        selectedPriceRange = 'All';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('50-100 USD'),
                    onTap: () {
                      setState(() {
                        selectedPriceRange = '50-100';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('101-200 USD'),
                    onTap: () {
                      setState(() {
                        selectedPriceRange = '101-200';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('201-500 USD'),
                    onTap: () {
                      setState(() {
                        selectedPriceRange = '201-500';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLodgeDetails(Lodge lodge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  lodge.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "📍 Location: ${lodge.local}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "💰 Price: ${lodge.prix}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "👥 Capacity: ${lodge.capacity}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  lodge.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 80),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.to(RegistrationPage());
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text("Register for Days"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Updated button color
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
