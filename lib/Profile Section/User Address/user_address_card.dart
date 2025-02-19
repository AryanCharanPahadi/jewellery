import 'package:flutter/material.dart';
import 'package:jewellery/Profile%20Section/User%20Address/user_address_controller.dart';
import '../../Component/show_pop_up.dart';
import '../../Component/text_style.dart';
import '../Add Address/add_address.dart';
import 'package:get/get.dart';

class UserAddressCard extends StatefulWidget {
  const UserAddressCard({super.key});

  @override
  State<UserAddressCard> createState() => _UserAddressCardState();
}

class _UserAddressCardState extends State<UserAddressCard> {
  final UserAddressController controller = Get.put(UserAddressController());

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.red.shade300, width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 400;

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Addresses", style: getTextStyle()),
                    if (isSmallScreen) const SizedBox(height: 8),
                    Align(
                      alignment: isSmallScreen
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          PopupDialog(
                                  parentContext: context,
                                  childWidget: AddAddress())
                              .show();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade300,
                          side: BorderSide(color: Colors.red.shade200),
                        ),
                        child: Text("Add Address", style: getTextStyle()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.addresses.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('No addresses found',
                            style: getTextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            )),
                      ),
                    );
                  }

                  return Column(
                    children: controller.addresses.map((address) {
                      return _buildAddressTile(address, isSmallScreen);
                    }).toList(),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressTile(Map<String, dynamic> address, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${address['address1']}, ${address['address2']}",
                  style: getTextStyle(
                    fontSize: 16,
                  )),
              const SizedBox(height: 4),
              Text(
                  "${address['city']}, ${address['state']}, ${address['postal_code']}, ${address['country']}",
                  style: getTextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: isSmallScreen
                    ? [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // TextButton(
                              //   onPressed: () {
                              //     // Add functionality for editing the address
                              //   },
                              //   child: Text("Edit",
                              //       style: getTextStyle(
                              //           fontWeight: FontWeight.normal)),
                              // ),
                              TextButton(
                                onPressed: () {
                                  controller
                                      .deleteAddress(address['address_id']);
                                },
                                child: Text("Delete",
                                    style: getTextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.normal)),
                              ),
                            ],
                          ),
                        ),
                      ]
                    : [
                        // TextButton(
                        //   onPressed: () {
                        //     // Add functionality for editing the address
                        //   },
                        //   child: Text("Edit",
                        //       style:
                        //           getTextStyle(fontWeight: FontWeight.normal)),
                        // ),
                        TextButton(
                          onPressed: () {
                            controller.deleteAddress(address['address_id']);
                          },
                          child: Text(
                            "Delete",
                            style: getTextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
