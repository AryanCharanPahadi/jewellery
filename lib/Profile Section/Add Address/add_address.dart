import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Component/custom_text.dart';
import '../../Component/gradient_button.dart';

import 'add_address_controller.dart';

class AddAddress extends StatelessWidget {
  final AddAddressController addAddressController =
      Get.put(AddAddressController());

  AddAddress({super.key});

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    double padding = constraints.width > 600 ? 100.0 : 30.0;
    double width = constraints.width > 600 ? 500 : double.infinity;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Form(
          key: addAddressController.formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
                const CustomTitleText(text: "Add Address"),
                const SizedBox(height: 20),
                buildTextField(
                  label: "Address 1",
                  icon: Icons.home,
                  controller: addAddressController.address1,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your Address'
                      : null,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: "Address 2",
                  icon: Icons.home_filled,
                  controller: addAddressController.address2,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your Address 2'
                      : null,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: "State",
                  icon: Icons.real_estate_agent,
                  controller: addAddressController.state,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your State'
                      : null,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: "City",
                  icon: Icons.location_city,
                  controller: addAddressController.city,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your City'
                      : null,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: "Pin Code",
                  icon: Icons.pin,
                  controller: addAddressController.postalCode,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your Pin Code'
                      : null,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: "Country",
                  icon: Icons.public,
                  controller: addAddressController.country,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your Country'
                      : null,
                ),
                const SizedBox(height: 30),
                GradientButton(
                  text: "Add Address",
                  onPressed: () => addAddressController.submitAddress(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
