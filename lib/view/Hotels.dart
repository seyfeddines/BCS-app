import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class Hotel {
  final String name;
  final String description;
  final String imageUrl;
  final String place;
  final int stars;

  Hotel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.place,
    required this.stars,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] ?? 'Unknown Hotel',
      description: json['description'] ?? 'No description available',
      imageUrl: json['picture']?['formats']?['thumbnail']?['url'] != null
          ? 'https://wondrous-werewolf-lasting.ngrok-free.app${json['picture']['formats']['thumbnail']['url']}'
          : 'https://via.placeholder.com/150', // Fallback placeholder image
      place: json['Place'] ?? 'Unknown Location',
      stars: (json['stars'] as int?) ?? 3, // Default to 3 stars if not provided
    );
  }
}

class HotelsPage extends StatefulWidget {
  HotelsPage();
  @override
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  List<Hotel> hotels = [];
  int selectedStars = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    final url = Uri.parse(
        'https://wondrous-werewolf-lasting.ngrok-free.app/api/hotels?populate=*');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> hotelList = jsonData['data'] ?? [];

        setState(() {
          hotels = hotelList.map((data) => Hotel.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch hotels. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching hotels: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Hotel> filteredHotels = selectedStars == 0
        ? hotels
        : hotels.where((hotel) => hotel.stars == selectedStars).toList();

    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.orange[800],
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
                  "Hotels",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
                  onPressed: () => _showFilterOptions(),
                ),
              ],
            ),
          ),
          // Body Content
          isLoading
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
            child: ListView.builder(
              itemCount: filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = filteredHotels[index];
                return GestureDetector(
                  onTap: () => _showHotelDetails(hotel),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(image: NetworkImage(hotel.imageUrl )),
                      ),
                      title: Text(hotel.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hotel.place),
                          Row(
                            children: [
                              for (int i = 0; i < hotel.stars; i++)
                                Icon(Icons.star,
                                    color: Colors.orange, size: 16),
                              for (int i = hotel.stars; i < 5; i++)
                                Icon(Icons.star_border,
                                    color: Colors.orange, size: 16),
                            ],
                          ),
                        ],
                      ),
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
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
                "Filter by Stars",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.star_outline, color: Colors.orange),
                title: Text("All Stars"),
                onTap: () {
                  setState(() {
                    selectedStars = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              for (int starCount = 3; starCount <= 5; starCount++)
                ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        starCount,
                            (index) => Icon(Icons.star,
                            color: Colors.orange, size: 16)),
                  ),
                  title: Text("$starCount Stars"),
                  onTap: () {
                    setState(() {
                      selectedStars = starCount;
                    });
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showHotelDetails(Hotel hotel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
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
                      hotel.name,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        for (int i = 0; i < hotel.stars; i++)
                          Icon(Icons.star, color: Colors.orange, size: 20),
                        for (int i = hotel.stars; i < 5; i++)
                          Icon(Icons.star_border,
                              color: Colors.orange, size: 20),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(hotel.description, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(image: NetworkImage(hotel.imageUrl),)
                    ),
                    SizedBox(height: 16),
                    Text("Location: ${hotel.place}",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
