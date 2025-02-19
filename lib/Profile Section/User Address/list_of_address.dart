import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jewellery/Profile%20Section/User%20Address/user_address_controller.dart';
import 'package:get/get.dart';

import '../../Component/show_pop_up.dart';
import '../Add Address/add_address.dart';

class ListOfAddress extends StatefulWidget {
  const ListOfAddress({super.key});

  @override
  State<ListOfAddress> createState() => _ListOfAddressState();
}

class _ListOfAddressState extends State<ListOfAddress> {
  final UserAddressController userAddressController =
      Get.put(UserAddressController());
  int? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    userAddressController.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        if (userAddressController.isLoading.value) {
          return const CircularProgressIndicator();
        }

        final addresses = userAddressController.addresses;

        if (addresses.isEmpty) {
          return const Text(
            "No address available",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double containerWidth = constraints.maxWidth * 0.85;
            return Container(
              width: containerWidth.clamp(300, 600), // Responsive width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Address",
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true, // Prevents unnecessary scrolling
                      children: addresses.map<Widget>((address) {
                        final fullAddress = [
                          address['address1'],
                          address['address2'],
                          address['city'],
                          address['state'],
                          address['postal_code'],
                          address['country'],
                        ]
                            .where((element) =>
                                element != null && element.isNotEmpty)
                            .join(", ");
                        return RadioListTile<int>(
                          title: Text(fullAddress,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.black87)),
                          value: address['address_id'],
                          groupValue: _selectedAddressId,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedAddressId = value;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (kDebugMode) {
                          print("Selected Address ID: $_selectedAddressId");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      child: const Text("Continue",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                        PopupDialog(
                                parentContext: context,
                                childWidget: AddAddress())
                            .show();
                        userAddressController.loadAddresses();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      child: const Text("Add New Address",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
