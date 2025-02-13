import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

import '../Component/text_style.dart';
import '../Headers/custom_header.dart';
import '../Image Banner/custom_image_banner.dart';
import '../Headers/header2_delegates.dart';
import '../Headers/second_header.dart';
import '../Component/text_container.dart';
import '../Footer/footer.dart';
import 'home_controller.dart';

class MenScreen extends StatefulWidget {
  const MenScreen({super.key});

  @override
  State<MenScreen> createState() => _MenScreenState();
}

class _MenScreenState extends State<MenScreen> {
  final MyHomePageController homeController = Get.put(MyHomePageController());

  @override
  void initState() {
    super.initState();
    homeController.loadJewellaryBannerImages();
    homeController.loadJewellaryCategoryImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom Header (Non-sticky)
          const SliverToBoxAdapter(
            child: Header(),
          ),

          // Sticky Header2
          SliverPersistentHeader(
            pinned: true,

            delegate: Header2Delegate(
              child: const Header2(),
            ),
          ),

          // Image Carousel
          SliverToBoxAdapter(
            child: Obx(() {
              return homeController.images.isNotEmpty
                  ? ImageCarousel(
                      images: homeController.images,
                    )
                  : const Center(
                      child: Text('Loading images...'),
                    );
            }),
          ),

          // Product Grid and other sections
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 30,
                ),
                const TextContainer(
                  title: "CATEGORIES FOR JEWELLERY",
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(() {
                  return homeController.jewellaryCategoryImages.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Adjust number of columns based on screen width
                              int crossAxisCount = constraints.maxWidth > 600
                                  ? 4
                                  : (constraints.maxWidth > 300
                                      ? 2
                                      : (constraints.maxWidth > 200 ? 1 : 1));

                              // Dynamically adjust font size and image height based on screen width
                              double imageHeight = constraints.maxWidth < 200
                                  ? 100
                                  : (constraints.maxWidth < 250
                                      ? 130
                                      : (constraints.maxWidth < 300
                                          ? 150
                                          : 200));

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
                                itemCount: homeController
                                    .jewellaryCategoryImages.length,
                                itemBuilder: (context, index) {
                                  final item = homeController
                                      .jewellaryCategoryImages[index];
                                  final itemTitle = item['item_title'] ?? '';

                                  return InkWell(
                                    onTap: () {
                                      context.go('/$itemTitle');
                                    },
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                            color: Colors.white54, width: 1.5),
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
                                            color:
                                                Colors.black26.withOpacity(0.2),
                                            blurRadius: 10.0,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Animated Image with hover effect
                                          Expanded(
                                            child: MouseRegion(
                                              onEnter: (_) {
                                                setState(() {
                                                  homeController
                                                      .imageScales[index] = 1.5;
                                                });
                                              },
                                              onExit: (_) {
                                                setState(() {
                                                  homeController
                                                      .imageScales[index] = 1.0;
                                                });
                                              },
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Navigate to the selected item screen
                                                  context.go('/$itemTitle');
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(8.0),
                                                  ),
                                                  child: Transform.scale(
                                                    scale: homeController
                                                                .imageScales[
                                                            index] ??
                                                        1.0,
                                                    child: Image.network(
                                                      item['jewellary_home_img'] ??
                                                          '',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height:
                                                          imageHeight, // Dynamic image height
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Title Text with Better Styling
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              itemTitle,
                                              textAlign: TextAlign.center,
                                              style: getTextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }),
                const SizedBox(
                  height: 30,
                ),
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
