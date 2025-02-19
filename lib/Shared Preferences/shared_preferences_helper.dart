import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _loginStatusKey = 'loginStatus';
  static const String _userDetailsKey = 'userDetails';
  static const String _cartKey = 'cartItems';
  static const String _wishlistKey = 'wishlistItems';

  // 🔹 Save login status
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginStatusKey, isLoggedIn);
  }

  // 🔹 Get login status
  static Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginStatusKey) ?? false;
  }

  // 🔹 Save user details
  static Future<void> saveUserDetails(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDetailsJson = json.encode(userDetails);

    print("🔹 Saving User Details: $userDetailsJson");
    await prefs.setString(_userDetailsKey, userDetailsJson);

    // Fetch & print for verification
    String? storedData = prefs.getString(_userDetailsKey);
    print("✅ Stored User Details: $storedData");
  }


  // 🔹 Get user details
  static Future<Map<String, dynamic>?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetailsJson = prefs.getString(_userDetailsKey);

    if (userDetailsJson == null) {
      print("No User Details found in SharedPreferences.");
      return null;
    }

    Map<String, dynamic> userDetails = jsonDecode(userDetailsJson);

    // 🔹 Debugging
    print("Fetched User Details from SharedPreferences: $userDetails");

    return userDetails;
  }

  // 🔹 Clear all stored data (logout)
  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginStatusKey);
    prefs.remove(_userDetailsKey);
    prefs.remove(_cartKey);
    prefs.remove(_wishlistKey);
  }

  // 🔹 Get user ID
  static Future<int?> getUserId() async {
    Map<String, dynamic>? userDetails = await getUserDetails();
    return userDetails?['user_id'];
  }

  // 🔹 Get user address
  static Future<List<Map<String, dynamic>>> getUserAddress() async {
    Map<String, dynamic>? userDetails = await getUserDetails();
    if (userDetails != null && userDetails['address'] != null) {
      var address = userDetails['address'];
      if (address is List) {
        return List<Map<String, dynamic>>.from(address);
      } else if (address is Map) {
        return [Map<String, dynamic>.from(address)];
      }
    }
    return [];
  }

  // 🔹 Add product to cart
  static Future<void> addToCart(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    cartItems.add(product);
    await prefs.setString(_cartKey, jsonEncode(cartItems));
  }

  // 🔹 Get all cart items
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getString(_cartKey);
    if (cartItemsString != null) {
      final List<dynamic> decodedList = jsonDecode(cartItemsString);
      return decodedList.map((item) => item as Map<String, dynamic>).toList();
    }
    return [];
  }

  // 🔹 Remove product from cart
  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = await getCartItems();
    cartItems.removeWhere((item) => item['itemId'] == productId);
    await prefs.setString(_cartKey, jsonEncode(cartItems));
  }

  // 🔹 Check if item is in cart
  static Future<bool> isItemInCart(int productId) async {
    final cartItems = await getCartItems();
    return cartItems.any((item) => item['itemId'] == productId);
  }

  // 🔹 Clear the cart
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  // 🔹 Add product to wishlist
  static Future<void> addToWishlist(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistItems = await getWishlistItems();
    wishlistItems.add(product);
    await prefs.setString(_wishlistKey, jsonEncode(wishlistItems));
  }

  // 🔹 Get all wishlist items
  static Future<List<Map<String, dynamic>>> getWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistItemsString = prefs.getString(_wishlistKey);
    if (wishlistItemsString != null) {
      final List<dynamic> decodedList = jsonDecode(wishlistItemsString);
      return decodedList.map((item) => item as Map<String, dynamic>).toList();
    }
    return [];
  }

  // 🔹 Remove product from wishlist
  static Future<void> removeFromWishlist(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistItems = await getWishlistItems();
    wishlistItems.removeWhere((item) => item['itemId'] == productId);
    await prefs.setString(_wishlistKey, jsonEncode(wishlistItems));
  }

  // 🔹 Clear the wishlist
  static Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wishlistKey);
  }

  // ✅ Get cart item count
  static Future<int> getCartItemCount() async {
    final cartItems = await getCartItems();
    return cartItems.length;
  }

  // ✅ Get wishlist item count
  static Future<int> getWishlistItemCount() async {
    final wishlistItems = await getWishlistItems();
    return wishlistItems.length;
  }
}

class LoginStatusHelper {
  Future<bool> checkLoginStatus() async {
    return await SharedPreferencesHelper.getLoginStatus();
  }
}
