import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery/Product%20Details/product_modal.dart';
import '../Api Helper/api_helper.dart';
import '../Component/text_style.dart';
import '../Component/value_builder.dart';
import '../Headers/custom_header.dart';
import '../Image Banner/custom_image_banner.dart';
import '../Headers/header2_delegates.dart';
import '../Headers/second_header.dart';
import '../Component/text_container.dart';
import '../Footer/footer.dart';
import '../Home Screen/home_controller.dart';
import '../Shared Preferences/shared_preferences_helper.dart';


class ProductGridMen extends StatefulWidget {
  final String itemTitle;

  const ProductGridMen({super.key, required this.itemTitle});

  @override
  State<ProductGridMen> createState() => _ProductGridMenState();
}

class _ProductGridMenState extends State<ProductGridMen> {
  late Future<List<Product>> _products;

  ValueNotifier<bool> isLiked = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _products = ApiService().fetchJewellaryProducts(widget.itemTitle);
    Get.put(MyHomePageController()).loadJewellaryBannerImages();
  }

  Future<bool> _checkLoginStatus() async {
    bool isLoggedIn = await SharedPreferencesHelper.getLoginStatus();
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyHomePageController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Header(),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: Header2Delegate(
              child: const Header2(),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => controller.images.isNotEmpty
                  ? ImageCarousel(
                      images: controller.images,
                    )
                  : const Center(
                      child: Text('Loading images...'),
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 30),
                TextContainer(
                  title: "Looking for ${widget.itemTitle}",
                ),
                const SizedBox(height: 30),
                FutureBuilder<List<Product>>(
                  future: _products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Products Found'));
                    } else {
                      var products = snapshot.data!;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = constraints.maxWidth > 600
                              ? 4
                              : (constraints.maxWidth > 300
                                  ? 2
                                  : (constraints.maxWidth > 200 ? 1 : 1));

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 15.0,
                              childAspectRatio:
                                  0.8, // Adjust for better proportions
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              List<String> images =
                                  products[index].itemImg.split(',');
                              ValueNotifier<int> hoveredImageIndex =
                                  ValueNotifier<int>(0);
                              ValueNotifier<bool> isZoomed =
                                  ValueNotifier<bool>(false);
                              ValueNotifier<bool> isLiked =
                                  ValueNotifier<bool>(false);

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Pass the resolved Product object to the next screen
                                    GoRouter.of(context).go(
                                        '/${products[index].itemTitle}/product-detail',
                                        extra: products[index].toJson());
                                  },
                                  child: MouseRegion(
                                    onEnter: (_) {
                                      if (images.length > 1) {
                                        hoveredImageIndex.value = 1;
                                      } else {
                                        isZoomed.value = true;
                                      }
                                    },
                                    onExit: (_) {
                                      hoveredImageIndex.value = 0;
                                      isZoomed.value = false;
                                    },
                                    child: ValueListenableBuilder2<int, bool>(
                                      first: hoveredImageIndex,
                                      second: isZoomed,
                                      builder: (context, hoveredIndex, zoomed,
                                          child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                color: Colors.white54,
                                                width: 1.5),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.amber.shade100
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26
                                                    .withOpacity(0.2),
                                                blurRadius: 10.0,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .vertical(
                                                        top: Radius.circular(
                                                            8.0),
                                                      ),
                                                      child: AnimatedScale(
                                                        scale:
                                                            zoomed ? 1.5 : 1.0,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        child: Image.network(
                                                          images[hoveredIndex],
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          // height: 600, // Fix height
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  products[index].itemName,
                                                  textAlign: TextAlign.center,
                                                  style: getTextStyle(),
                                                  maxLines:
                                                      1, // Ensure text is in one line
                                                  overflow: TextOverflow
                                                      .ellipsis, // Prevent overflow
                                                ),
                                              ),
                                              Text(
                                                '₹ ${products[index].itemPrice}',
                                                textAlign: TextAlign.center,
                                                style: getTextStyle(),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                const TextContainer(
                  title: "🌟 Over 6 Million Happy Customers! 🌟",
                ),
                const ResponsiveFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
