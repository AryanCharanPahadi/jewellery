import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery/Login%20Page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Add To Cart/add_to_cart.dart';
import 'Profile Section/Main UI Profile Section/user_detail.dart';
import 'Page not Found/page_not_found.dart';
import 'Product Details/product_detail_page.dart';
import 'Product Details/product_grid.dart';
import 'Product Details/product_modal.dart';
import 'Home Screen/home_screen.dart';
import 'Profile Section/User Address/list_of_address.dart';
import 'Sign Up/sign_up.dart';
import 'Wishlist/wishlist_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Ensure initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Define GoRouter
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        // Root route for MenScreen
        GoRoute(
          path: '/',
          builder: (context, state) => const MenScreen(),
        ),
        GoRoute(
          path: '/login-page',
          builder: (context, state) => const LoginPage(),
        ),

        // Route for UserDetailsScreen
        GoRoute(
          path: '/user-details',
          builder: (context, state) => const UserDetailScreen(),
        ),

        // Route for WishlistPage
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => WishlistPage(),
        ),

        // Route for UserAddress
        GoRoute(
          path: '/user-address',
          builder: (context, state) => const ListOfAddress(),
        ),

        // Route for SignupContent (Authentication page)
        GoRoute(
          path: '/authPage',
          builder: (context, state) => const SignupContent(),
        ),

        // Route for AddToCart page
        GoRoute(
          path: '/add-to-cart',
          builder: (context, state) => const AddToCart(),
        ),

        // Dynamic route for ProductGridMen with nested routes
        GoRoute(
          path: '/:itemTitle',
          builder: (context, state) {
            final itemTitle = state.pathParameters['itemTitle']!;
            return ProductGridMen(itemTitle: itemTitle);
          },
          routes: [
            // Nested route for ProductDetailScreen
            GoRoute(
              path: 'product-detail',
              builder: (context, state) {
                // Here, we parse the 'extra' field from the state and ensure it's a valid Product object
                final productJson = state.extra as Map<String, dynamic>?;

                if (productJson != null) {
                  final product =
                      Product.fromJson(productJson); // Parse JSON to Product
                  return ProductDetailScreen(product: product);
                }

                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                );
              },
            ),

          ],
        ),
      ],
      errorBuilder: (context, state) =>
          PageNotFoundScreen(routeName: state.uri.toString()),
    );

    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Dazzle',
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
