import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Api Helper/api_helper.dart';
import '../../Shared Preferences/shared_preferences_helper.dart';

class UserAddressController extends GetxController {
  var userId = RxnInt();
  var addresses = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final fetchedUserId = await SharedPreferencesHelper.getUserId();
    userId.value = fetchedUserId;
    if (userId.value != null) {
      loadAddresses();
    } else {
      isLoading.value = false;
    }
  }

  Future<void> loadAddresses() async {
    if (userId.value == null) return;
    isLoading.value = true;
    try {
      final fetchedAddresses = await ApiService.getUserAddress(userId.value.toString());
      addresses.assignAll(fetchedAddresses);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching addresses: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(int addressId) async {
    if (userId.value != null) {
      final success = await ApiService.deleteAddress(
          addressId.toString(), userId.value.toString());
      if (success) {
        loadAddresses();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete address.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }
}
