import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../Component/text_container.dart';
import '../Component/text_style.dart';
import '../Headers/custom_header.dart';
import '../Headers/header2_delegates.dart';
import '../Headers/second_header.dart';
import '../Footer/footer.dart';
import '../Shared Preferences/shared_preferences_helper.dart';

class WishlistPage extends StatefulWidget {
  WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> wishlistItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlistItems();
  }

  Future<void> _loadWishlistItems() async {
    try {
      final items = await SharedPreferencesHelper.getWishlistItems();
      setState(() {
        wishlistItems = items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error loading wishlist items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                const TextContainer(title: "Welcome To Wishlist"),
                const SizedBox(height: 30),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : wishlistItems.isEmpty
                        ? _buildEmptyWishlistButton(context)
                        : _buildWishlistGrid(screenWidth),
                const SizedBox(height: 30),
                const TextContainer(
                    title:
                        "\uD83C\uDF1F Over 6 Million Happy Customers! \uD83C\uDF1F"),
                const ResponsiveFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlistButton(BuildContext context) {
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

  Widget _buildWishlistGrid(double screenWidth) {
    int crossAxisCount = screenWidth > 1000
        ? 4
        : screenWidth > 800
            ? 3
            : screenWidth > 600
                ? 2
                : 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: screenWidth < 400 ? 0.7 : 0.8,
        ),
        itemCount: wishlistItems.length,
        itemBuilder: (context, index) {
          final product = wishlistItems[index];
          final images = product["itemImg"].split(',');
          final itemName = product["itemName"];
          ValueNotifier<int> hoveredImageIndex = ValueNotifier<int>(0);

          return GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/${product["itemTitle"]}/product-detail',
                  extra: product);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: images.isNotEmpty
                              ? Image.network(
                                  images[hoveredImageIndex.value],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : const Icon(Icons.image,
                                  size: 100, color: Colors.grey),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Remove from wishlist",
                            onPressed: () async {
                              await SharedPreferencesHelper.removeFromWishlist(
                                  product["itemId"]);
                              _loadWishlistItems();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(itemName,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 18,
                          color: Colors.brown[800] ?? Colors.black,
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      bool isInCart = await SharedPreferencesHelper.isItemInCart(product["itemId"]);
                      if (!isInCart) {
                        await SharedPreferencesHelper.addToCart(product);
                      }
                      await SharedPreferencesHelper.removeFromWishlist(product["itemId"]);
                      _loadWishlistItems();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("Add To Cart", style: getTextStyle()),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
