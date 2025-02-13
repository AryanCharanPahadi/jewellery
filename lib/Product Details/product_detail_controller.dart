import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jewellery/Product%20Details/product_modal.dart';
import '../../Api Helper/api_helper.dart';
import '../../Shared Preferences/shared_preferences_helper.dart';

class ProductDetailController extends GetxController {
  final Rx<Product?> product = Rx<Product?>(null);
  final RxBool isInCart = false.obs;
  final RxList<Product> relatedProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      product.value = Product.fromJson(args);
    }
    fetchRelatedProducts();
    checkIfProductInCart();
  }

  Future<void> fetchRelatedProducts() async {
    if (product.value != null) {
      try {
        final products = await ApiService().fetchJewellaryProducts(product.value!.itemTitle);
        relatedProducts.value = products; // Assign fetched products to relatedProducts
        if (kDebugMode) {
          print('Fetched related products: ${products.length}');
        } // Debug log
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching related products: $e');
        } // Debug log
      }
    }
  }
  Future<void> checkIfProductInCart() async {
    if (product.value != null) {
      isInCart.value = await _isProductInCart(product.value!.itemId);
    }
  }

  Future<bool> _isProductInCart(int productId) async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) return false;
    final cartProducts = await ApiService().fetchAddToCartProducts(userId);
    return cartProducts.any((product) => product.itemId == productId);
  }

  void updateCartStatus(bool updated) {
    isInCart.value = updated;
  }
}