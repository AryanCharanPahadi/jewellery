import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Component/show_pop_up.dart';
import '../Component/text_style.dart';
import '../Login Page/login_page.dart';
import '../Shared Preferences/shared_preferences_helper.dart';

class Header2 extends StatefulWidget {
  const Header2({super.key});

  @override
  State<Header2> createState() => _Header2State();
}

class _Header2State extends State<Header2> {
  bool _isHoveredAccount = false;
  bool _isHoveredWishlist = false;
  bool _isHoveredCart = false;
  bool _isHoveredLogo = false;
  int cartItemCount = 0;
  int wishlistItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadItemCounts();
  }

  void _loadItemCounts() async {
    cartItemCount = await SharedPreferencesHelper.getCartItemCount();
    wishlistItemCount = await SharedPreferencesHelper.getWishlistItemCount();
    setState(() {}); // Refresh UI with new counts
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth <= 600;

    double fontSize = isSmallScreen ? 16 : 20;
    double iconSize = isSmallScreen ? 18 : 20;
    double horizontalPadding = isSmallScreen ? 12 : 16;
    double iconSpacing = isSmallScreen ? 8 : 16;

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHoveredLogo = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHoveredLogo = false;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/');
                    },
                    child: Text(
                      "DAZZLE",
                      style: getTextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: _isHoveredLogo ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.diamond,
                  size: iconSize,
                  color: Colors.black,
                ),
              ],
            ),
          ),

          // Icons and Links
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding + 4),
            child: Row(
              children: [
                _buildIcon(Icons.person_outline, 'user-details', iconSize,
                    _isHoveredAccount, (value) {
                  setState(() {
                    _isHoveredAccount = value;
                  });
                }, 0), // No badge for account icon

                SizedBox(width: iconSpacing),

                _buildIcon(Icons.favorite_border, 'wishlist', iconSize,
                    _isHoveredWishlist, (value) {
                  setState(() {
                    _isHoveredWishlist = value;
                  });
                }, wishlistItemCount), // Wishlist badge

                SizedBox(width: iconSpacing),

                _buildIcon(Icons.shopping_cart_outlined, 'add-to-cart',
                    iconSize, _isHoveredCart, (value) {
                  setState(() {
                    _isHoveredCart = value;
                  });
                }, cartItemCount), // Cart badge
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, String type, double iconSize, bool isHovered,
      Function(bool) onHoverChange, int itemCount) {
    return MouseRegion(
      onEnter: (_) => onHoverChange(true),
      onExit: (_) => onHoverChange(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (type == 'user-details') {
            bool isLoggedIn = await LoginStatusHelper().checkLoginStatus();
            if (isLoggedIn) {
              context.go('/user-details'); // Navigate to user profile
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  PopupDialog(parentContext: context, childWidget: LoginPage())
                      .show();
                }
              });
            }
          } else {
            context.go('/$type');
          }
          _loadItemCounts(); // Refresh counts when navigating
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon,
                color: isHovered ? Colors.red : Colors.black, size: iconSize),
            if (itemCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIcon(double iconSize) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHoveredCart = true;
      }),
      onExit: (_) => setState(() {
        _isHoveredCart = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          context.go('/add-to-cart');
          _loadItemCounts(); // Refresh cart count when navigating
        },
        child: Stack(
          clipBehavior: Clip.none, // Allows positioning outside the stack
          children: [
            Icon(Icons.shopping_cart_outlined,
                color: _isHoveredCart ? Colors.red : Colors.black,
                size: iconSize),
            if (cartItemCount > 0)
              Positioned(
                right: -4, // Adjust to position outside the icon
                top: -4, // Moves badge upwards
                child: Container(
                  padding: const EdgeInsets.all(3), // Makes badge smaller
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white,
                        width: 1.5), // Adds border to make it stand out
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10, // Small text size
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
