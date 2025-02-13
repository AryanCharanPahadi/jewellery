import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../Api Helper/api_helper.dart';

class MyHomePageController extends GetxController {
  // Observables
  var images = <String>[].obs;
  var imageScales = <int, double>{}.obs;

  var jewellaryCategoryImages = <Map<String, dynamic>>[].obs;

  // Load Banner Images for Men
  Future<void> loadJewellaryBannerImages() async {
    try {
      List<String> banners = await ApiService.fetchJewellaryBannerImages();
      images.assignAll(banners);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading banners: $e');
      }
    }
  }

  // Load Category Images for Men
  Future<void> loadJewellaryCategoryImages() async {
    try {
      List<Map<String, dynamic>> images =
          await ApiService.fetchJewellaryCategoryImages();
      jewellaryCategoryImages.assignAll(images);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading category images: $e');
      }
    }
  }
}
