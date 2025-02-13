import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery/Product%20Details/product_modal.dart';

import '../Api Helper/api_helper.dart';
import '../Component/show_pop_up.dart';
import '../Component/text_style.dart';
import '../Component/unique_id.dart';
import '../Shared Preferences/shared_preferences_helper.dart';
import '../Sign Up/sign_up.dart';
import '../Wishlist/wishlist_controller.dart';
import '../Wishlist/wishlist_modal.dart';

class AddToWishlistButton extends StatelessWidget {
  final Product loadedProduct;
  final WishlistController wishlistController;

  const AddToWishlistButton({
    super.key,
    required this.loadedProduct,
    required this.wishlistController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        int? userId = wishlistController.userId;
        if (userId != null) {
          bool isAvailable = wishlistController.products
              .any((product) => product.itemId == loadedProduct.itemId);

          if (isAvailable) {
            context.go('/wishlist');
          } else {
            bool isLoggedIn = await LoginStatusHelper().checkLoginStatus();
            if (isLoggedIn) {     int? userId = await SharedPreferencesHelper.getUserId();
            String formattedDate = getFormattedDate();

            if (userId != null) {
              WishlistModal wishlistModal = WishlistModal(
                userId: userId,
                pId: loadedProduct.itemId,
                pPrice: loadedProduct.itemPrice.toString(),
                createdAt: formattedDate,
              );

              if (context.mounted) {
                bool success = await ApiService.addToWishlist(wishlistModal, context);

                if (success) {
                  wishlistController.fetchWishlist();
                }
              }
            }}

          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              PopupDialog(
                parentContext: context,
                childWidget: const SignupContent(),
              ).show();
            }
          });
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        backgroundColor: Colors.yellowAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Obx(() {
        bool isAvailable = wishlistController.products
            .any((product) => product.itemId == loadedProduct.itemId);

        return Text(
          isAvailable ? "Go to Wishlist" : "Add to Wishlist",
          style: getTextStyle(),
        );
      }),
    );
  }


}