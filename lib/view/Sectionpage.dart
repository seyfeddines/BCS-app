import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/view/parametrePage.dart';

import 'Activites.dart';
import 'Cardforsell.dart';
import 'Hotels.dart';
import 'LombardgePage.dart';
import 'Natural.dart';
import 'Transport.dart';

// Dummy pages for navigation
class HomePage extends StatefulWidget {
  final double height;
  final double width;

  HomePage({required this.height, required this.width});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  // Pages corresponding to the bottom navigation bar
  final List<Widget> _pages = [
    ParametersPage(),
    HomePage(height: 800, width: 400), // HomePage as a placeholder
    CardPage(),
  ];

  // List of titles for cards
  final List<String> _cardTitles = [
    'Hotels',
    'Lobardge',
    'Transport',
    'Nature',
    'Activites'
  ];

  // Handle Bottom Navigation Change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Gradient color based on the card name
  LinearGradient getCardGradient(String cardName) {
    return LinearGradient(
      colors: [Colors.orange.shade700, Colors.red.shade400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 1
          ? Container(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade900, Colors.orange.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Boumerdès",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Discover amazing places and services in Boumerdès",
                      style: GoogleFonts.roboto(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: _cardTitles.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
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
                                return Padding(
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
                                        "Navigate to ${_cardTitles[index]}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                        // Close the bottom sheet
                                              if (index == 0) {
                                            Get.to(HotelsPage());
                                          } else if (index == 1) {
                                            Get.to(LodgesPage());
                                          } else if (index == 2) {
                                            Get.to(MapPageTransport());
                                          } else if (index == 3) {
                                            Get.to(NaturalPlacesPage());
                                          } else if (index == 4) {
                                            Get.to(ActivitiesPage());
                                          }

                                          // Add other navigations for index 1, 2, 3, etc.
                                        },
                                        child: Text("Go to ${_cardTitles[index]} Page"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: getCardGradient(_cardTitles[index]),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.hotel_sharp),
                                Text(
                                  _cardTitles[index],
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Parameters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
        ],
      ),
    );
  }
}
