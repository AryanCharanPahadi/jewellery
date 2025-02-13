import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../Component/text_style.dart';
import '../../Component/value_builder.dart';
import '../product_modal.dart';

class RelatedProducts extends StatelessWidget {
  final Future<List<Product>> productsFuture;
  final ScrollController scrollController;

  const RelatedProducts({
    super.key,
    required this.productsFuture,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Center(child: Text('No Products Found'));
        } else {
          var products = snapshot.data!;

          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  child: Row(
                    children: List.generate(products.length, (index) {
                      List<String> images = products[index].itemImg.split(',');
                      ValueNotifier<int> hoveredImageIndex =
                          ValueNotifier<int>(0);
                      ValueNotifier<bool> isZoomed = ValueNotifier<bool>(false);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the new screen
                            GoRouter.of(context).push(
                              '/${products[index].itemTitle}/product-detail',
                              extra: products[index].toJson(),
                            );

                            // Scroll to the top of the screen after navigation
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (scrollController.hasClients) {
                                scrollController
                                    .jumpTo(0); // Instantly scroll to the top
                              }
                            });
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
                              builder: (context, hoveredIndex, zoomed, child) {
                                return Container(
                                  width: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
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
                                        color: Colors.black26.withOpacity(0.2),
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
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(8.0),
                                              ),
                                              child: AnimatedScale(
                                                scale: zoomed ? 1.5 : 1.0,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                child: Image.network(
                                                  images[hoveredIndex],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          products[index].itemName,
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                    }),
                  ),
                ),
              ),
              // Add navigation buttons
              Positioned(
                left: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      scrollController.animateTo(
                        scrollController.offset - 200,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.black),
                    onPressed: () {
                      scrollController.animateTo(
                        scrollController.offset + 200,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
