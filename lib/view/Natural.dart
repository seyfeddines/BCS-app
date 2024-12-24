import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Place {
  final String name;
  final String place;
  final String category;
  final String documentId;
  final String? lat;
  final String? long;

  Place({
    required this.name,
    required this.place,
    required this.category,
    required this.documentId,
    this.lat,
    this.long,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      place: json['place'],
      category: json['category'],
      documentId: json['documentId'],
      lat: json['let'],
      long: json['long'],
    );
  }
}

Future<List<Place>> fetchPlaces() async {
  final response = await http.get(Uri.parse('https://wondrous-werewolf-lasting.ngrok-free.app/api/toristic-places'));

  if (response.statusCode == 200) {
    final List<dynamic> placesJson = json.decode(response.body)['data'];
    return placesJson.map((json) => Place.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load places');
  }
}

class NaturalPlacesPage extends StatefulWidget {
  @override
  _NaturalPlacesPageState createState() => _NaturalPlacesPageState();
}

class _NaturalPlacesPageState extends State<NaturalPlacesPage> {
  late Future<List<Place>> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = fetchPlaces(); // Fetch data from API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        elevation: 0,
        title: Text(
          "Natural Places",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Place>>(
          future: _placesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No places found.'));
            } else {
              final places = snapshot.data!;
              return ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return _buildPlaceCard(
                    title: places[index].name,
                    description: places[index].place,
                    latitude: places[index].lat ?? '',
                    longitude: places[index].long ?? '',
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPlaceCard({
    required String title,
    required String description,
    required String latitude,
    required String longitude,
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
            colors: [Colors.orange.shade800, Colors.orange.shade600],
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _openInGoogleMaps(latitude, longitude);
                },
                child: Text('Open in Google Maps', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openInGoogleMaps(String latitude, String longitude) async {
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
