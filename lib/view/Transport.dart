import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapPageTransport extends StatefulWidget {
  @override
  _MapPageTransportState createState() => _MapPageTransportState();
}

class _MapPageTransportState extends State<MapPageTransport> {
  // Dropdown options
  final List<String> transportModes = ["Bus", "Train"];
  String selectedTransport = "Bus"; // Default selected transport mode

  // Input controllers
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  // Map points and route data
  LatLng? fromLatLng;
  LatLng? toLatLng;
  List<LatLng> routePoints = [];

  final String apiKey = "YOUR_API_KEY"; // Replace with your actual API key

  // Simulated location suggestions
  final Map<String, LatLng> suggestions = {
    "Place A": LatLng(37.7749, -122.4194),
    "Place B": LatLng(37.8044, -122.2711),
    "Place C": LatLng(37.7741, -122.4311),
  };

  Future<void> calculateRoute() async {
    if (fromLatLng == null || toLatLng == null) {
      Get.snackbar("Error", "Please select both origin and destination.");
      return;
    }

    try {
      final url =
          "https://api.openrouteservice.org/v2/directions/${selectedTransport.toLowerCase()}?api_key=$apiKey&start=${fromLatLng!.longitude},${fromLatLng!.latitude}&end=${toLatLng!.longitude},${toLatLng!.latitude}";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates = data["features"][0]["geometry"]["coordinates"];
        setState(() {
          routePoints = coordinates
              .map<LatLng>(
                  (coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();
        });
      } else {
        Get.snackbar("Error", "Failed to calculate the route.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route Finder"),
        backgroundColor: Colors.orange[800],
      ),
      body: Column(
        children: [
          // Dropdown for transport mode
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              value: selectedTransport,
              items: transportModes
                  .map((mode) => DropdownMenuItem(
                child: Text(mode),
                value: mode,
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTransport = value!;
                });
              },
            ),
          ),

          // Input fields for origin and destination
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: fromController,
                  decoration: InputDecoration(
                    labelText: "From",
                    suffixIcon: PopupMenuButton<String>(
                      icon: Icon(Icons.search),
                      onSelected: (value) {
                        fromController.text = value;
                        setState(() {
                          fromLatLng = suggestions[value];
                        });
                      },
                      itemBuilder: (context) => suggestions.keys
                          .map((place) => PopupMenuItem(
                        child: Text(place),
                        value: place,
                      ))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: toController,
                  decoration: InputDecoration(
                    labelText: "To",
                    suffixIcon: PopupMenuButton<String>(
                      icon: Icon(Icons.search),
                      onSelected: (value) {
                        toController.text = value;
                        setState(() {
                          toLatLng = suggestions[value];
                        });
                      },
                      itemBuilder: (context) => suggestions.keys
                          .map((place) => PopupMenuItem(
                        child: Text(place),
                        value: place,
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Button to calculate route
          ElevatedButton(
            onPressed: calculateRoute,
            child: Text("Show Route"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[800],

            ),
          ),

          // Map to display route and markers
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: fromLatLng ?? LatLng(37.7749, -122.4194),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                if (fromLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: fromLatLng!,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                if (toLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: toLatLng!,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
