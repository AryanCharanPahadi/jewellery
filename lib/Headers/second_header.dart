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
                }),
                SizedBox(width: iconSpacing),
                _buildIcon(Icons.favorite_border, 'wishlist', iconSize,
                    _isHoveredWishlist, (value) {
                  setState(() {
                    _isHoveredWishlist = value;
                  });
                }),
                SizedBox(width: iconSpacing),
                _buildIcon(Icons.shopping_cart_outlined, 'add-to-cart',
                    iconSize, _isHoveredCart, (value) {
                  setState(() {
                    _isHoveredCart = value;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, String type, double iconSize, bool isHovered,
      Function(bool) onHoverChange) {
    return MouseRegion(
      onEnter: (_) => onHoverChange(true),
      onExit: (_) => onHoverChange(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          bool isLoggedIn = await LoginStatusHelper().checkLoginStatus();
          if (isLoggedIn) {
            context.go('/$type');
          } else {
            PopupDialog(parentContext: context, childWidget: const LoginPage())
                .show();
          }
        },
        child: Icon(icon,
            color: isHovered ? Colors.red : Colors.black, size: iconSize),
      ),
    );
  }
}
