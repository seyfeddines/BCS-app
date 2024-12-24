import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ControllerOne extends GetxController {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();  // Create an instance of FlutterSecureStorage

  @override
  void onInit() {
    print("Hello world");
  }

  Future<void> postDataWithTokenRetry(String apiUrl, Map<String, dynamic> data) async {
    try {
      // Get the access token securely
      String? accessToken = await _secureStorage.read(key: "access_token");

      if (accessToken == null) {
        print("No access token found. User needs to log in.");
        return;
      }

      // Make the initial POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(data),
      );

      // If the access token is expired (401 Unauthorized)
      if (response.statusCode == 401) {
        print("Access token expired. Attempting to refresh...");

        // Refresh the access token
        bool refreshed = await refreshAccessToken();
        if (refreshed) {
          // Get the new access token
          accessToken = await _secureStorage.read(key: "access_token");

          // Retry the original request with the new token
          response = await http.post(
            Uri.parse(apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $accessToken",
            },
            body: jsonEncode(data),
          );

          if (response.statusCode == 200) {
            print("Request successful after token refresh.");
            print("Response: ${response.body}");
          } else {
            print("Request failed after token refresh. Status code: ${response.statusCode}");
            print("Response: ${response.body}");
          }
        } else {
          print("Failed to refresh token. User needs to log in again.");
        }
      } else if (response.statusCode == 200) {
        print("Request successful.");
        print("Response: ${response.body}");
      } else {
        print("Request failed. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  Future<bool> refreshAccessToken() async {
    const String refreshApiUrl = "https://example.com/api/refresh";

    try {
      // Get the refresh token securely
      final String? refreshToken = await _secureStorage.read(key: "refresh_token");

      if (refreshToken == null) {
        print("No refresh token found. User needs to log in.");
        return false;
      }

      final http.Response response = await http.post(
        Uri.parse(refreshApiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"refresh_token": refreshToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String newAccessToken = responseData["access_token"];
        final String newRefreshToken = responseData["refresh_token"];

        // Store the new tokens securely
        await _secureStorage.write(key: "access_token", value: newAccessToken);
        await _secureStorage.write(key: "refresh_token", value: newRefreshToken);

        print("Access token refreshed successfully.");
        return true;
      } else {
        print("Failed to refresh token. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during token refresh: $e");
      return false;
    }
  }


}
