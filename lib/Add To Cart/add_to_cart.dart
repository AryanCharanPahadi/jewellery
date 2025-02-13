import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Component/text_style.dart';
import '../Profile Section/Add Address/add_address.dart';
import '../Profile Section/User Address/list_of_address.dart';
import '../Api Helper/api_helper.dart';
import '../Component/show_pop_up.dart';
import '../Component/text_container.dart';
import '../Headers/custom_header.dart';
import '../Headers/header2_delegates.dart';
import '../Headers/second_header.dart';
import '../Footer/footer.dart';
import '../Product Details/product_modal.dart';
import '../Profile Section/User Address/user_address_controller.dart';
import '../Shared Preferences/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Component/show_pop_up.dart';



class AddToCart extends StatefulWidget {
  const AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  var selectedQuantities = <int, int>{};
  int? userId;
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final fetchedUserId = await SharedPreferencesHelper.getUserId();
    setState(() {
      userId = fetchedUserId;
    });

    if (userId != null) {
      _fetchCartProducts();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCartProducts() async {
    try {
      var fetchedProducts = await ApiService().fetchAddToCartProducts(userId!);
      setState(() {
        products = fetchedProducts.cast<Product>();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching products: $e");
    }
  }

  double _getTextSize(double screenWidth, double baseSize) {
    if (screenWidth <= 100) return baseSize * 0.4;
    if (screenWidth <= 150) return baseSize * 0.5;
    if (screenWidth <= 200) return baseSize * 0.6;
    if (screenWidth <= 250) return baseSize * 0.75;
    if (screenWidth <= 280) return baseSize * 0.85;
    if (screenWidth <= 300) return baseSize * 0.9;
    if (screenWidth <= 350) return baseSize * 1.0;
    return baseSize;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Header()),
          SliverPersistentHeader(
            pinned: true,
            delegate: Header2Delegate(child: const Header2()),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 30),
                const TextContainer(title: "Welcome To Cart"),
                const SizedBox(height: 30),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (products.isEmpty)
                  _buildEmptyCartButton(screenWidth)
                else
                  _buildCartContent(screenWidth, isLargeScreen),
                const SizedBox(height: 30),
                const TextContainer(
                    title: "🌟 Over 6 Million Happy Customers! 🌟"),
                const ResponsiveFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartButton(double screenWidth) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.go("/"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        child: Text('Continue Shopping', style: getTextStyle()),
      ),
    );
  }

  Widget _buildCartContent(double screenWidth, bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: isLargeScreen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildProductList(screenWidth)),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildOrderSummary(screenWidth)),
              ],
            )
          : Column(
              children: [
                _buildProductList(screenWidth),
                const SizedBox(height: 16),
                _buildOrderSummary(screenWidth),
              ],
            ),
    );
  }

  Widget _buildProductList(double screenWidth) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final images = product.itemImg.split(',');

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListTile(
            leading: _buildProductImage(screenWidth, images.first),
            title: _buildProductTitle(product.itemName, screenWidth),
            subtitle: _buildProductDetails(product, screenWidth),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  _showDeleteConfirmationDialog(context, product.itemId),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int productId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content:
              const Text('Do you want to remove this item from your cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await deleteItemFromCart(productId); // Proceed with deletion
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteItemFromCart(int productId) async {
    bool success = await ApiService.deleteFromCart(
        productId.toString(), userId.toString());
    if (success) {
      setState(() {
        products.removeWhere((product) => product.itemId == productId);
      });
    } else {
      debugPrint("Failed to delete the product.");
    }
  }

  Widget _buildProductImage(double screenWidth, String imageUrl) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.15,
        maxHeight: screenWidth * 0.15,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildProductTitle(String itemName, double screenWidth) {
    return Text(itemName,
        style: getTextStyle(
          fontSize: _getTextSize(screenWidth, 16),
        ));
  }

  Widget _buildProductDetails(dynamic product, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('₹ ${product.itemPrice}',
            style: getTextStyle(
              fontWeight: FontWeight.w500,
              fontSize: _getTextSize(screenWidth, 14),
            )),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Quantity:',
                style: getTextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: _getTextSize(screenWidth, 14),
                )),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedQuantities[product.itemId] ?? 1,
              items: List.generate(
                10,
                (qtyIndex) => DropdownMenuItem(
                  value: qtyIndex + 1,
                  child: Text('${qtyIndex + 1}'),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedQuantities[product.itemId] = value!;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSummary(double screenWidth) {
    final subtotal = calculateTotalAmount();
    const double deliveryCharge = 0.0;
    final gst = subtotal * 0.03;
    final total = subtotal + gst + deliveryCharge;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("ORDER SUMMARY",
                    style: getTextStyle(
                      color: Colors.redAccent,
                      fontSize: _getTextSize(screenWidth, 16),
                    )),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow(
                  "Sub Total", "₹ ${subtotal.toStringAsFixed(2)}", screenWidth),
              const SizedBox(height: 8),
              _buildSummaryRow("Delivery Charge",
                  "₹ ${deliveryCharge.toStringAsFixed(2)}", screenWidth),
              const SizedBox(height: 8),
              _buildSummaryRow(
                  "GST (3%)", "₹ ${gst.toStringAsFixed(2)}", screenWidth),
              const SizedBox(height: 8),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              _buildSummaryRow(
                "TOTAL (Incl. of all Taxes)",
                "₹ ${total.toStringAsFixed(2)}",
                screenWidth,
                isBold: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Center(
                  child: Text("Proceed to Checkout",
                      style: getTextStyle(
                        fontSize: _getTextSize(screenWidth, 14),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, double screenWidth,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: getTextStyle(
              fontSize: _getTextSize(screenWidth, 14),
            )),
        Text(value,
            style: getTextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                fontSize: _getTextSize(screenWidth, 14),
                color: Colors.red)),
      ],
    );
  }

  Future<void> _handleCheckout() async {
    final fetchedUserId = await SharedPreferencesHelper.getUserId();
    if (fetchedUserId != null) {
      _showAddressPopup(fetchedUserId);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          PopupDialog(parentContext: context, childWidget: AddAddress()).show();
        }
      });
    }
  }

  Future<void> _showAddressPopup(int fetchedUserId) async {
    try {
      var fetchedAddresses =
          await ApiService.getUserAddress(fetchedUserId.toString());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          if (fetchedAddresses.isEmpty) {
            PopupDialog(parentContext: context, childWidget: AddAddress())
                .show();
          } else {
            PopupDialog(
                    parentContext: context, childWidget: const ListOfAddress())
                .show();
            debugPrint("Clicked to checkout");
          }
        }
      });
    } catch (e) {
      debugPrint("Error fetching addresses: $e");
    }
  }

  double calculateTotalAmount() {
    return products.fold(0.0, (total, product) {
      final price = double.tryParse(product.itemPrice) ?? 0.0;
      final quantity = selectedQuantities[product.itemId] ?? 1;
      return total + price * quantity;
    });
  }
}


class ListOfAddress extends StatefulWidget {
  const ListOfAddress({super.key});

  @override
  State<ListOfAddress> createState() => _ListOfAddressState();
}

class _ListOfAddressState extends State<ListOfAddress> {
  final UserAddressController userAddressController = Get.put(UserAddressController());
  int? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    userAddressController.loadAddresses(); // Load addresses from the controller
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (userAddressController.isLoading.value) {
            return const CircularProgressIndicator();
          }

          final addresses = userAddressController.addresses;

          if (addresses.isEmpty) {
            return const Text(
              "No address available",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            );
          }

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Address",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),

                  // Dropdown for Address Selection
                  DropdownButton<int>(
                    value: _selectedAddressId,
                    hint: const Text("Select Address"),
                    onChanged: (int? value) {
                      setState(() {
                        _selectedAddressId = value;
                      });
                    },
                    items: addresses.map((address) {
                      final fullAddress = [
                        address['address1'],
                        address['address2'],
                        address['city'],
                        address['state'],
                        address['postal_code'],
                        address['country'],
                      ]
                          .where((element) => element != null && element.isNotEmpty)
                          .join(", ");

                      // Adjusting the text size based on the address length
                      double fontSize = fullAddress.length > 80
                          ? 12.0
                          : fullAddress.length > 60
                          ? 14.0
                          : 16.0;

                      return DropdownMenuItem<int>(
                        value: address['address_id'],
                        child: Text(
                          "Address: $fullAddress",
                          style: TextStyle(fontSize: fontSize),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Ensure text stays on one line
                        ),
                      );
                    }).toList(),
                  ),

                  // Button to add a new address
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the popup
                      PopupDialog(
                        parentContext: context,
                        childWidget: AddAddress(),
                      ).show();
                    },
                    child: const Text("Add New Address"),
                  ),
                  const SizedBox(height: 20.0),

                  // Continue button if an address is selected
                  if (_selectedAddressId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            if (kDebugMode) {
                              print("Selected Address ID: $_selectedAddressId");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

