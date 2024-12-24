import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';  // Ensure you have the latest version of qr_flutter package
import 'package:get/get.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Variables to hold card details
  String? name;
  String? prenameC;
  String? email;
  String? selectedSex;
  String? placeOfBirth;
  String? selectedDate;
  String? cardID;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCardDetails();
  }

  // Load card details from secure storage
  Future<void> _loadCardDetails() async {
    name = await _secureStorage.read(key: "name");
    prenameC = await _secureStorage.read(key: "prenameC");
    email = await _secureStorage.read(key: "email");
    selectedSex = await _secureStorage.read(key: "selectedSex");
    placeOfBirth = await _secureStorage.read(key: "placeOfBirth");
    selectedDate = await _secureStorage.read(key: "selectedDate");
    cardID = await _secureStorage.read(key: "cardID");
    setState(() {
      isLoading = false;
    });
  }

  // Save card details to secure storage
  Future<void> _saveCardDetails(Map<String, String> cardData) async {
    for (var entry in cardData.entries) {
      await _secureStorage.write(key: entry.key, value: entry.value);
    }
    await _loadCardDetails(); // Reload details to update the UI
  }

  // Function to generate a unique card code from user data
  String _generateCardCode() {
    String data = "$name^$prenameC^$email^$selectedSex^$placeOfBirth^$selectedDate";
    return data.split('').map((char) => '^$char').join('');
  }

  // Show form to create a card
  void _showCreateCardForm() {
    String? enteredCardID;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter Your Card ID",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Card ID",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => enteredCardID = value,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (enteredCardID != null && enteredCardID!.isNotEmpty) {
                        _saveCardDetails({
                          "cardID": enteredCardID!,
                          "name": "John Doe", // Placeholder data
                          "prenameC": "Doe",
                          "email": "john.doe@example.com",
                          "selectedSex": "Male",
                          "placeOfBirth": "New York",
                          "selectedDate": "1990-01-01",
                        });
                        Navigator.pop(context);
                      } else {
                        Get.snackbar("Error", "Please enter a valid Card ID.");
                      }
                    },
                    child: Text("Create Card"),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Delete card function
  Future<void> _deleteCard() async {
    await _secureStorage.delete(key: "cardID");
    await _secureStorage.delete(key: "name");
    await _secureStorage.delete(key: "prenameC");
    await _secureStorage.delete(key: "email");
    await _secureStorage.delete(key: "selectedSex");
    await _secureStorage.delete(key: "placeOfBirth");
    await _secureStorage.delete(key: "selectedDate");
    setState(() {
      cardID = null;
      name = null;
      prenameC = null;
      email = null;
      selectedSex = null;
      placeOfBirth = null;
      selectedDate = null;
    });
    Get.snackbar("Card Deleted", "Your card has been successfully deleted.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Card"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cardID == null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Get Your Discount Card",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Unlock exclusive discounts and offers at restaurants and shops in your area. "
                  "Simply create your discount card by entering your Card ID.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showCreateCardForm,
              child: Text("Create Card"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card Heading
                  Text(
                    "Buy: BCS",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Card Details
                  Text("Card ID: $cardID"),
                  Text("Name: $name"),
                  Text("Prename: $prenameC"),
                  Text("Email: $email"),
                  Text("Sex: $selectedSex"),
                  Text("Place of Birth: $placeOfBirth"),
                  Text("Date of Birth: $selectedDate"),
                  SizedBox(height: 16),
                  // QR Code

                  SizedBox(height: 16),
                  // Card Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "This card gives you access to exclusive offers and discounts "
                          "at participating restaurants and shops. Show your card to unlock the benefits.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Delete Button
                  ElevatedButton(
                    onPressed: _deleteCard,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Delete Card"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
