import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery/Wishlist/wishlist_controller.dart';
import '../Component/text_container.dart';
import '../Component/text_style.dart';
import '../Headers/custom_header.dart';
import '../Headers/header2_delegates.dart';
import '../Headers/second_header.dart';
import '../Footer/footer.dart';

class WishlistPage extends StatelessWidget {
  WishlistPage({super.key});

  final WishlistController controller = Get.put(WishlistController());

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
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.products.isEmpty) {
                    return _buildEmptyWishlistButton(context);
                  } else {
                    return _buildWishlistGrid(screenWidth);
                  }
                }),
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
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          final images = product.itemImg.split(',');
          final itemName = product.itemName;
          ValueNotifier<int> hoveredImageIndex = ValueNotifier<int>(0);

          return GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/${product.itemTitle}/product-detail',
                  extra: product.toJson());
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
                              await controller
                                  .deleteItemFromCart(product.itemId);
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
                      await controller.addToCart(product, context);
                      controller.products.remove(product);
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
