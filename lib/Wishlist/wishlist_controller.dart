import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Api Helper/api_helper.dart';
import '../Add To Cart/add_to_cart_modal.dart';
import '../Shared Preferences/shared_preferences_helper.dart';
import '../Component/unique_id.dart';
import '../Product Details/product_modal.dart';

class WishlistController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  int? userId;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      fetchWishlist();
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchWishlist() async {
    try {
      var fetchedProducts = await ApiService().fetchWishlistProducts(userId!);
      products.assignAll(fetchedProducts.cast<Product>());
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItemFromCart(int productId) async {
    bool success = await ApiService.deleteFromWishlist(
        productId.toString(), userId.toString());
    if (success) {
      products.removeWhere((product) => product.itemId == productId);
    } else {
      debugPrint("Failed to delete the product.");
    }
  }

  Future<bool> _checkLoginStatus() async {
    return await SharedPreferencesHelper.getLoginStatus();
  }

  Future<void> addToCart(Product product, BuildContext context) async {
    bool isLoggedIn = await _checkLoginStatus();

    if (isLoggedIn) {
      int? userId = await SharedPreferencesHelper.getUserId();
      String formattedDate = getFormattedDate();

      if (userId != null) {
        AddToCartModal addToCartModal = AddToCartModal(
          userId: userId,
          pId: product.itemId,
          pPrice: product.itemPrice.toString(),
          createdAt: formattedDate,
        );

        await ApiService.addToCart(addToCartModal, context);
        await deleteItemFromCart(product.itemId);
      }
    }
  }

}
