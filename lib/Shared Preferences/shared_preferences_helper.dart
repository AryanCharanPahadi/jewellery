import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _loginStatusKey = 'loginStatus';
  static const String _userDetailsKey = 'userDetails';

  // Save login status
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginStatusKey, isLoggedIn);
  }

  // Get login status
  static Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginStatusKey) ?? false;
  }

  // Save user details
  static Future<void> saveUserDetails(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDetailsJson = json.encode(userDetails);
    prefs.setString(_userDetailsKey, userDetailsJson);
  }

  // Get user details
  static Future<Map<String, dynamic>?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetailsJson = prefs.getString(_userDetailsKey);
    if (userDetailsJson == null) return null;
    return Map<String, dynamic>.from(json.decode(userDetailsJson));
  }

  // Clear all stored data (logout)
  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginStatusKey);

    prefs.remove(_userDetailsKey);
  }

  // Get user ID
  static Future<int?> getUserId() async {
    Map<String, dynamic>? userDetails = await getUserDetails();
    var userId = userDetails?['user_id'];

    if (userId != null) {
      return userId;
    }

    return null;
  }

  //
  // // Add this method to your SharedPreferencesHelper
  static Future<List<Map<String, dynamic>>> getUserAddress() async {
    Map<String, dynamic>? userDetails = await getUserDetails();

    // Check if userDetails and 'address' are not null
    if (userDetails != null && userDetails['address'] != null) {
      var address = userDetails['address'];

      // If the address is already a List<Map<String, dynamic>>, return it
      if (address is List) {
        return List<Map<String, dynamic>>.from(address);
      }
      // If it's a single map (not a list), convert it into a list with one item
      else if (address is Map) {
        return [Map<String, dynamic>.from(address)];
      }
    }

    // Return an empty list if no address is found or it's not in the correct format
    return [];
  }
}

class LoginStatusHelper {
  Future<bool> checkLoginStatus() async {
    return await SharedPreferencesHelper.getLoginStatus();
  }
}
