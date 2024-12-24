import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../model/Base Url.dart';
import 'package:get/get.dart';
class ControlerSaveData extends GetxController {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static Future<void> getroles ()async {
    final String url = "${BaseUrl().base_url}users-permissions/roles";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${BaseUrl().apiToken}'
      },

    );

  }
  Future<void> save_data(
      String password,
      String email,
      String? selectedSex,
      String placeOfBirth,
      String? selectedDate,
      String name,
      String prenameC,
      ) async {
    try {
      // Log: Starting the save process
      print("Starting to save data locally and post to the server...");
      final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
      // Save data securely to Flutter Secure Storage
      await _secureStorage.write(key: "password", value: password);
      await _secureStorage.write(key: "email", value: email);
      await _secureStorage.write(key: "selectedSex", value: selectedSex ?? "Not specified");
      await _secureStorage.write(key: "placeOfBirth", value: placeOfBirth);
      await _secureStorage.write(key: "selectedDate", value: selectedDate ?? "Not specified");
      await _secureStorage.write(key: "name", value: name);
      await _secureStorage.write(key: "prenameC", value: prenameC);

      print("Data saved locally to Flutter Secure Storage!");

      // Preparing data for server
      final String url = "${BaseUrl().base_url}users"; // Ensure this URL is correct
      final Map<String, dynamic> userData = {
        "username": "$name $prenameC",
        "email": email,
        "password": password,
        "BirthDay": selectedDate,
        "role": "1",
        "sex": selectedSex,
        "BirthPlace": placeOfBirth,
      };

      print("POST URL: $url");
      print("POST Headers: ${{
        "Content-Type": "application/json",

      }}");
      print("POST Body: ${jsonEncode(userData)}");

      // Make HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );
      // Log the response status code and body
      // Handle successful response
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print("User created successfully: $data");
          await _secureStorage.write(key: "hasbensignin", value: "Y");
          Get.toNamed('/homepage');
          return data;
        } catch (e) {
          print("Error decoding response body: $e");
        }
      } else {
        // Failure: Log error response
        print("Failed to create user. Status Code: ${response.statusCode}");
        print("Error Response: ${response.body}");
      }
    } catch (e) {
      // Log any error during the save process
      print("Error during save_data: $e");
    } finally {
      // Always print this when the process completes
      print("save_data process completed.");
    }
  }



  Future<void> loginuser(
      String password,
      String email,
      ) async {
    try {
      // Log: Starting the save process
      print("Starting to save data locally and post to the server...");
      // Save data securely to Flutter Secure Storage
      await _secureStorage.write(key: "password", value: password);
      await _secureStorage.write(key: "email", value: email);
      print("Data saved locally to Flutter Secure Storage!");
      // Preparing data for server
      final String url = "${BaseUrl().base_url}auth/local"; // Ensure this URL is correct
      final Map<String, dynamic> userData = {
        "identifier": email,
        "password": password,
      };

      print("POST URL: $url");
      print("POST Headers: ${{
        "Content-Type": "application/json",

      }}");
      print("POST Body: ${jsonEncode(userData)}");

      // Make HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );
      // Log the response status code and body
      // Handle successful response
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print("User login successfully: $data");
          print("acess token : ${data["jwt"]}");
          await _secureStorage.write(key: "hasbensignin", value: "Y");
          await _secureStorage.write(key: "userId", value: data["userId"]);
          await _secureStorage.write(key: "acesstoken", value: "${data['jwt']}");
          Get.toNamed('/homepage');
          return data;
        } catch (e) {
          print("Error decoding response body: $e");
        }
      } else {
        // Failure: Log error response
        print("Failed to login user. Status Code: ${response.statusCode}");
        print("Error Response: ${response.body}");
      }
    } catch (e) {
      // Log any error during the save process
      print("Error during save_data: $e");
    } finally {
      // Always print this when the process completes
      print("save_data process completed.");
    }
  }
}



