import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Component/order_history.dart';
import 'side_bar.dart';
import '../../Component/text_container.dart';
import '../../Headers/custom_header.dart';
import '../../Headers/header2_delegates.dart';
import '../../Footer/footer.dart';
import '../../Headers/second_header.dart';
import '../../Home Screen/home_controller.dart';
import 'user_details_card.dart'; // UserDetailsCard
import '../User Address/user_address_card.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with SingleTickerProviderStateMixin {
  bool showMenu = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  // Variable to track selected sidebar item
  String selectedMenuItem = "Personal Information"; // Default selection

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _toggleMenu() {
    setState(() {
      showMenu = !showMenu;
      if (showMenu) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyHomePageController controller = Get.put(MyHomePageController());
    controller.loadJewellaryBannerImages();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth > 800;

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: Header()),
              SliverPersistentHeader(
                pinned: true,
                delegate: Header2Delegate(child: const Header2()),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const TextContainer(title: "Welcome To Your Profile"),
                        const SizedBox(height: 10),
                        if (!isLargeScreen)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(showMenu ? Icons.close : Icons.menu,
                                    size: 30),
                                onPressed: _toggleMenu,
                              ),
                            ],
                          ),
                        if (!isLargeScreen)
                          AnimatedBuilder(
                            animation: _slideAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_slideAnimation.value * 250, 0),
                                child: child,
                              );
                            },
                            child: showMenu
                                ? SidebarMenu(
                                    onItemSelected: (title) {
                                      setState(() {
                                        selectedMenuItem = title;
                                        _toggleMenu();
                                      });
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLargeScreen)
                              SidebarMenu(
                                isLargeScreen: true,
                                onItemSelected: (title) {
                                  setState(() {
                                    selectedMenuItem = title;
                                  });
                                },
                              ),
                            Expanded(
                              child:
                                  _buildContent(), // Dynamically show content
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ]),
              ),
              const SliverToBoxAdapter(
                child: TextContainer(
                  title: "🌟 Over 6 Million Happy Customers! 🌟",
                ),
              ),
              const SliverToBoxAdapter(child: ResponsiveFooter()),
            ],
          );
        },
      ),
    );
  }

  // Widget to build dynamic content
// Widget to build dynamic content
  Widget _buildContent() {
    switch (selectedMenuItem) {
      case "Overview":
      // Display both UserDetailsCard and UserAddressCard in a Column
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserDetailsCard(),
            SizedBox(height: 20), // Add spacing between the cards
            UserAddressCard(),
          ],
        );
      case "Your Address":
        return const UserAddressCard();

      case "Order History":
        return  const OrderHistoryCard();
      case "Personal Information":
      default:
        return const UserDetailsCard();
    }
  }

}
