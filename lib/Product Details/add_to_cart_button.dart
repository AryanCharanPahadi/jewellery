import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery/Product%20Details/product_modal.dart';
import '../Add To Cart/add_to_cart_modal.dart';
import '../Api Helper/api_helper.dart';
import '../Component/show_pop_up.dart';
import '../Component/text_style.dart';
import '../Component/unique_id.dart';
import '../Shared Preferences/shared_preferences_helper.dart';
import '../Sign Up/sign_up.dart';

class AddToCartButton extends StatelessWidget {
  final bool isInCart;
  final Product loadedProduct;
  final Function(bool) onCartUpdated;

  const AddToCartButton({
    super.key,
    required this.isInCart,
    required this.loadedProduct,
    required this.onCartUpdated,
  });



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (isInCart) {
          context.go('/add-to-cart');
        } else {
          bool isLoggedIn = await LoginStatusHelper().checkLoginStatus();
          if (isLoggedIn) {
            int? userId = await SharedPreferencesHelper.getUserId();
            String formattedDate = getFormattedDate();

            if (userId != null) {
              AddToCartModal addToCartModal = AddToCartModal(
                userId: userId,
                pId: loadedProduct.itemId,
                pPrice: loadedProduct.itemPrice.toString(),
                createdAt: formattedDate,
              );

              await ApiService.addToCart(addToCartModal, context);

              onCartUpdated(true);
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
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        backgroundColor: Colors.yellowAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        isInCart ? 'Go to Cart' : 'Add to Cart',
        style: getTextStyle(),
      ),
    );
  }


}
