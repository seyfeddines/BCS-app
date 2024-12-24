import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Map Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(37.7749, -122.4194), // Center the map at San Francisco
          initialZoom: 13.0, // Set the zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
         
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(37.7749, -122.4194),
                child:  Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
