import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../Api Helper/api_helper.dart';
import '../Product Details/product_modal.dart';
import '../Shared Preferences/shared_preferences_helper.dart';

class CartController extends GetxController {
  var userId = 0.obs; // Observable user ID
  var products = <Product>[].obs; // Observable product list
  var isLoading = true.obs; // Loading state
  var selectedQuantities = <int, int>{}.obs; // Quantities for products
  int get cartItemCount => products.length;


  @override
  void onInit() {
    super.onInit();
    _loadUserId(); // Load the user ID and fetch products
  }

  Future<void> _loadUserId() async {
    try {
      final fetchedUserId = await SharedPreferencesHelper.getUserId();
      if (fetchedUserId != null) {
        userId.value = fetchedUserId;
        await fetchProducts();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts =
          await ApiService().fetchAddToCartProducts(userId.value);
      products.assignAll(fetchedProducts.cast<Product>());
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching products: $e");
      }
    }
  }

  Future<void> deleteItemFromCart(int productId) async {
    bool success = await ApiService.deleteFromCart(
        productId.toString(), userId.value.toString());
    if (success) {
      products.removeWhere((product) => product.itemId == productId);
    } else {
      if (kDebugMode) {
        print("Failed to delete the product.");
      }
    }
  }

  double calculateTotalAmount() {
    double total = 0.0;
    for (var product in products) {
      final price = double.tryParse(product.itemPrice) ?? 0.0;
      final quantity = selectedQuantities[product.itemId] ?? 1;
      total += price * quantity;
    }
    return total;
  }
}
