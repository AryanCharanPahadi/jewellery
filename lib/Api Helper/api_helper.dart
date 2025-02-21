import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Add To Cart/add_to_cart_modal.dart';
import '../Login Page/login_student_modal.dart';
import '../Product Details/Review/customer_review_modal.dart';
import '../Product Details/product_modal.dart';
import '../Profile Section/Add Address/add_address_modal.dart';
import '../Sign Up/signup_modal.dart';
import '../Wishlist/wishlist_modal.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost/jewellary/';
  static void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static dynamic handleResponse(http.Response response, BuildContext context) {
    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      if (kDebugMode) print(data['message'] ?? 'Success');
      showSnackBar(context, data['message'] ?? 'Success', Colors.green);
      return data;
    } else {
      if (kDebugMode) print(data['message'] ?? 'Error');

      showSnackBar(context, data['message'] ?? 'Error', Colors.red);
      return null;
    }
  }

  // Fetch banner images
  static Future<List<String>> fetchJewellaryBannerImages() async {
    const apiUrl = '$_baseUrl/get/get_jewellary_banner.php';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final String bannerString =
              jsonResponse['data'][0]['jewellary_banner'];
          final List<String> banners = bannerString.split(', ');
          return banners;
        } else {
          throw Exception('Error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load banners. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }

  // Jewellary Categories Image for Home Page
  static Future<List<Map<String, dynamic>>>
      fetchJewellaryCategoryImages() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/get/get_jewellary_homepage.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // print('API Response: $data');  // Print the response to inspect

        // Extract the 'data' field containing the list of category items
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(
            data['data'].map((item) => {
                  'jewellary_home_img': item['jewellary_home_img'] ?? '',
                  'item_title': item['item_title'] ?? '',
                }),
          );
        } else {
          throw Exception('No category images found');
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      if (kDebugMode) {
        // print('Error fetching category images: $e');
      }
      return [];
    }
  }

  //  Fetch products for unique categories

  Future<List<Product>> fetchJewellaryProducts(String itemTitle) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/get/get_jewellary_detail.php?item_title=$itemTitle'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          // print(data);
        }

        // Check if 'data' exists and is a list
        if (data is Map<String, dynamic> && data['data'] is List) {
          return (data['data'] as List)
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response structure');
        }
      } else {
        throw Exception('Failed to load products: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Print the error for debugging
      // debugPrint('Error in fetchMenProducts: $e');
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchAddToCartProducts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/utils/fetch.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // debugPrint('API Response: $data');

        if (data is Map<String, dynamic> && data['data'] is List) {
          return (data['data'] as List)
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          // debugPrint('Unexpected response structure: $data');
          throw Exception('Unexpected response structure');
        }
      } else {
        // debugPrint(
        //     'Failed to fetch products. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // debugPrint('Error in fetch Products: $e');
      throw Exception('Failed to load products');
    }
  }

  static Future<void> addUserDetail(
      SignUpModal signUpModal, BuildContext context) async {
    try {
      Uri url = Uri.parse('$_baseUrl/user/login/signup.php');
      var response = await http.post(
        url,
        body: {
          'name': signUpModal.name,
          'date_of_birth': signUpModal.dob,
          'anniversary_date': signUpModal.annDob,
          'email': signUpModal.email,
          'password': signUpModal.password,
          'phone': signUpModal.phone,
          'createdAt': signUpModal.createdAt,
        },
      );
      if (response.statusCode == 201 ||
          response.statusCode == 500 ||
          response.statusCode == 409 ||
          response.statusCode == 400) {
        if (context.mounted) {
          handleResponse(response, context);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        // print('Error: $e');
      }
      if (context.mounted) {
        showSnackBar(context, 'Failed to connect to API $e', Colors.red);
      }
    }
  }

  static Future<void> addToCart(
      AddToCartModal addToCartModal, BuildContext context) async {
    try {
      Uri url = Uri.parse('$_baseUrl/user/utils/user_cart.php');
      var response = await http.post(
        url,
        body: {
          'user_id': addToCartModal.userId.toString(),
          'p_id': addToCartModal.pId.toString(),
          'p_price': addToCartModal.pPrice.toString(),
          'createdAt': addToCartModal.createdAt,
        },
      );
      if (response.statusCode == 201 ||
          response.statusCode == 500 ||
          response.statusCode == 409 ||
          response.statusCode == 400) {
        if (context.mounted) {
          // handleResponse(response, context);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        // print('Error: $e');
      }
      if (context.mounted) {
        // showSnackBar(context, 'Failed to connect to API $e', Colors.red);
      }
    }
  }

  static Future<Map<String, dynamic>> login(
      LoginModal loginModal, BuildContext context) async {
    try {
      Uri url = Uri.parse('$_baseUrl/user/login/login.php');
      var response = await http.post(
        url,
        body: {
          'email': loginModal.email,
          'password': loginModal.password,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Decode JSON response
        if (data['status'] == 'success') {
          if (context.mounted) {
            showSnackBar(context, data['message'], Colors.green);
          }
          // Show success message

          // Extract user details from the 'user' object in the response
          var user = data['user'];
          var address = data['user']['address'] ?? {}; // Get address data

          if (kDebugMode) {
            // print(user);
            // print(address);
          }

          return {
            'success': true,
            'user_id': user['user_id'] ??
                'Unknown Id', // Fallback if 'user_id' is null
            'name':
                user['name'] ?? 'Unknown User', // Fallback if 'name' is null

            'password': user['password'] ??
                'Unknown User', // Fallback if 'name' is null
            'date_of_birth': user['date_of_birth'] ??
                'Unknown User', // Fallback if 'name' is null
            'anniversary_date': user['anniversary_date'] ??
                'Unknown User', // Fallback if 'name' is null
            'email': user['email'] ?? 'No Email', // Fallback if 'email' is null
            'phone': user['phone'] ?? 'No Phone', // Fallback if 'phone' is null
            'address': address, // Include address data
          };
        } else {
          if (context.mounted) {
            showSnackBar(context, data['message'], Colors.red);
          }
          // Show error message
        }
      } else {
        var errorData = jsonDecode(response.body);
        if (context.mounted) {
          showSnackBar(context, errorData['message'], Colors.red);
        }
      }
      return {'success': false}; // Return false if lo,k,k,tj gin fails
    } catch (e) {
      // if (kDebugMode) print('Error: $e');
      if (context.mounted) {
        showSnackBar(context, 'Failed to connect to API $e', Colors.red);
      }
      return {'success': false}; // Return false with no user details
    }
  }

  static Future<bool> deleteFromCart(String pId, String userId) async {
    final url = Uri.parse('$_baseUrl/user/delete/delete_add_to_cart.php');

    // Making the POST request with p_id and user_id as body
    final response = await http.post(
      url,
      body: {
        'p_id': pId,
        'user_id': userId, // Send the user_id along with p_id to the server
      },
    );

    // Checking for a successful response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'Product Removed from Cart') {
        // Show Snackbar on success
        Get.snackbar(
          'Success', // Title of the Snackbar
          'Product removed from cart.', // Message
          snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
          duration: const Duration(
              seconds: 2), // Duration for which the Snackbar will be visible
        );
        return true;
      }
    } else {
      // If the server returns an error
      if (kDebugMode) {
        // print('Failed to delete from cart: ${response.statusCode}');
      }
      return false;
    }
    return false;
  }

  static Future<bool> addAddress(
      AddressModal addressModal, BuildContext context) async {
    try {
      Uri url = Uri.parse('$_baseUrl/user/utils/user_address.php');
      var response = await http.post(
        url,
        body: {
          'address1': addressModal.address1.toString(),
          'address2': addressModal.address2.toString(),
          'city': addressModal.city.toString(),
          'state': addressModal.state.toString(),
          'postal_code': addressModal.postalCode.toString(),
          'country': addressModal.country.toString(),
          'created_at': addressModal.createdAt.toString(),
          'user_id': addressModal.userId.toString(),
        },
      );

      if (response.statusCode == 201) {
        if (context.mounted) {
          handleResponse(response, context);
        }
        return true; // Address added successfully
      } else {
        if (context.mounted) {
          handleResponse(response, context);
        }
        return false; // Address not added
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      if (context.mounted) {
        showSnackBar(context, 'Failed to connect to API: $e', Colors.red);
      }
      return false; // Handle failure case
    }
  }

  static Future<List<Map<String, dynamic>>> getUserAddress(
      String userId) async {
    final Uri url =
        Uri.parse("$_baseUrl/get/get_user_address.php?user_id=$userId");

    try {
      // Send GET request
      final response = await http.get(url);

      // Check response status
      if (response.statusCode == 200) {
        if (kDebugMode) {
          // print("Response Body: ${response.body}");
        }
        // Parse the response body as a map
        final Map<String, dynamic> responseMap = json.decode(response.body);

        // Check if the 'data' key exists and contains a list of addresses
        if (responseMap['status'] == 'success' && responseMap['data'] is List) {
          List<dynamic> dataList = responseMap['data'];
          return dataList
              .map((address) => address as Map<String, dynamic>)
              .toList();
        } else {
          return []; // Return an empty list if the 'data' is not available
        }
      } else {
        if (kDebugMode) {
          // print("Error: ${response.statusCode}, Body: ${response.body}");
        }
        return []; // Return an empty list on error
      }
    } catch (e) {
      // Handle exceptions
      if (kDebugMode) {
        // print("Exception: $e");
      }
      return []; // Return an empty list on exception
    }
  }

  static Future<bool> addToWishlist(
      WishlistModal wishlistModal, BuildContext context) async {
    try {
      Uri url = Uri.parse('$_baseUrl/user/utils/wishlist.php');
      var response = await http.post(
        url,
        body: {
          'user_id': wishlistModal.userId.toString(),
          'p_id': wishlistModal.pId.toString(),
          'p_price': wishlistModal.pPrice.toString(),
          'createdAt': wishlistModal.createdAt,
        },
      );

      if (context.mounted) {
        handleResponse(response, context);
      }

      // Return success for status codes that indicate the request was processed
      if (response.statusCode == 201) {
        return true; // Successfully added to wishlist
      } else {
        return false; // Any other response means failure
      }
    } catch (e) {
      if (kDebugMode) {
        // print('Error: $e');
      }
      if (context.mounted) {
        showSnackBar(context, 'Failed to connect to API: $e', Colors.red);
      }
      return false; // Return failure in case of an exception
    }
  }

  static Future<bool> deleteFromWishlist(String pId, String userId) async {
    final url = Uri.parse('$_baseUrl/user/delete/delete_wishlist.php');

    // Making the POST request with p_id and user_id as body
    final response = await http.post(
      url,
      body: {
        'p_id': pId,
        'user_id': userId, // Send the user_id along with p_id to the server
      },
    );

    // Checking for a successful response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'Wishlist Removed from Cart') {
        // Show Snackbar on success
        Get.snackbar(
          'Success', // Title of the Snackbar
          'Product removed from cart.', // Message
          snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
          duration: const Duration(
              seconds: 2), // Duration for which the Snackbar will be visible
        );
        return true;
      }
    } else {
      // If the server returns an error
      if (kDebugMode) {
        // print('Failed to delete from cart: ${response.statusCode}');
      }
      return false;
    }
    return false;
  }

  Future<List<Product>> fetchWishlistProducts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get/get_wishlist.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // debugPrint('API Response: $data');

        if (data is Map<String, dynamic> && data['data'] is List) {
          return (data['data'] as List)
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          // debugPrint('Unexpected response structure: $data');
          throw Exception('Unexpected response structure');
        }
      } else {
        // debugPrint(
        //     'Failed to fetch products. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // debugPrint('Error in fetch Products: $e');
      throw Exception('Failed to load products');
    }
  }

  static Future<bool> deleteAddress(String addressId, String userId) async {
    final url = Uri.parse('$_baseUrl/user/delete/delete_address.php');

    // Making the POST request with p_id and user_id as body
    final response = await http.post(
      url,
      body: {
        'address_id': addressId,
        'user_id': userId, // Send the user_id along with p_id to the server
      },
    );

    // Checking for a successful response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'Address Deleted Successfully') {
        // Show Snackbar on success
        Get.snackbar(
          'Success', // Title of the Snackbar
          'Address Deleted Successfully.', // Message
          snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
          duration: const Duration(
              seconds: 2), // Duration for which the Snackbar will be visible
        );
        return true;
      }
    } else {
      // If the server returns an error
      if (kDebugMode) {
        // print('Failed to delete from cart: ${response.statusCode}');
      }
      return false;
    }
    return false;
  }

  static Future<void> customerRating(
      CustomerReviewModal customerReviewModal, BuildContext context) async {
    try {
      Uri url = Uri.parse(
          'http://localhost/jewellary/admin/customer_rating/customer_rating.php');
      var response = await http.post(
        url,
        body: {
          'name': customerReviewModal.name,
          'headline': customerReviewModal.headline,
          'review': customerReviewModal.review,
          'email': customerReviewModal.email,
          'rating': customerReviewModal.rating,
          'createdAt': customerReviewModal.createdAt,
        },
      );
      if (response.statusCode == 201 ||
          response.statusCode == 500 ||
          response.statusCode == 409 ||
          response.statusCode == 400) {
        if (context.mounted) {
          handleResponse(response, context);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        // print('Error: $e');
      }
      if (context.mounted) {
        showSnackBar(context, 'Failed to connect to API $e', Colors.red);
      }
    }
  }

  static Future<List<dynamic>> fetchCustomerRatings() async {
    final String url = "http://localhost/jewellary/get/customer_rating.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // print(response.body);

        // If the API response is a map, extract the list
        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse.containsKey("data")) {
            return jsonResponse["data"]; // Extracting the list inside the map
          } else {
            throw Exception("API response does not contain 'data' key");
          }
        } else if (jsonResponse is List) {
          return jsonResponse; // If it's already a list, return as is
        } else {
          throw Exception("Unexpected JSON format");
        }
      } else {
        throw Exception("Failed to load customer ratings");
      }
    } catch (e) {
      throw Exception("Error fetching customer ratings: $e");
    }
  }

  static Future<bool> updateUserLogin({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String password,
    required String anniversaryDate,
    required String dateOfBirth,
    required BuildContext context,
  }) async {
    try {
      final uri = Uri.parse(
          'http://localhost/jewellary/user/edit/edit_user_detail.php');
      final request = http.MultipartRequest('POST', uri);

      // Add fields
      request.fields['user_id'] = id.toString();
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['password'] = password;
      request.fields['anniversary_date'] = anniversaryDate;
      request.fields['date_of_birth'] = dateOfBirth;

      // Debug print
      print("🚀 Sending request to: $uri");
      print("📤 Request fields: ${request.fields}");

      final response = await request.send();

      // Read response data
      final responseData = await response.stream.bytesToString();
      print("📥 Response Status Code: ${response.statusCode}");
      print("📜 Response Data: $responseData");

      final jsonResponse = json.decode(responseData);

      if (context.mounted) {
        showSnackBar(
          context,
          jsonResponse['message'] ?? 'Unexpected response from the server.',
          response.statusCode == 200 ? Colors.green : Colors.red,
        );
      }

      return jsonResponse['status'] ==
          "success"; // ✅ Return based on API response
    } catch (e) {
      print('❌ Error updating login details: $e');
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: $e', Colors.red);
      }
      return false;
    }
  }
}
