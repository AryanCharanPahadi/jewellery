import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api Helper/api_helper.dart';
import '../../Component/unique_id.dart';
import '../../Shared Preferences/shared_preferences_helper.dart';
import '../User Address/user_address_controller.dart';
import 'add_address_modal.dart';


class AddAddressController extends GetxController {
  final UserAddressController userAddressController = Get.put(UserAddressController());

  final formKey = GlobalKey<FormState>();
  // Controllers for form fields
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final postalCode = TextEditingController();
  final country = TextEditingController();

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    address1.dispose();
    address2.dispose();
    city.dispose();
    state.dispose();
    postalCode.dispose();
    country.dispose();

    super.onClose();
  }

  void submitAddress(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID not found. Please log in again.')),
        );
      }
      return;
    }

    String formattedDate = getFormattedDate();
    final addressModal = AddressModal(
      address1: address1.text,
      address2: address2.text,
      country: country.text,
      city: city.text,
      postalCode: postalCode.text,
      state: state.text,
      userId: userId.toString(),
      createdAt: formattedDate,
    );

    // Await the API call and check if it was successful
    bool success = await ApiService.addAddress(addressModal, context);

    if (success) {
      // Reload addresses immediately after adding a new one
      userAddressController.loadAddresses();

      if (context.mounted) {
        Navigator.pop(context); // Close the popup
      }

      // Clear the form fields after submission
      clearFormFields();
    }
  }

  void clearFormFields() {
    address1.clear();
    address2.clear();
    city.clear();
    state.clear();
    postalCode.clear();
    country.clear();
  }
}
