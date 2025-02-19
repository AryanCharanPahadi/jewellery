import 'package:flutter/material.dart';

import '../Component/text_container.dart';
import '../Headers/custom_header.dart';
import '../Headers/header2_delegates.dart';
import '../Headers/second_header.dart';
import '../Footer/footer.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Center(
                    child: TextContainer(title: "✨ About Dazzle Den ✨")),
                const SizedBox(height: 20),

                // Centered Column for about us content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "At Dazzle Den, we bring you the finest collection of premium artificial jewelry that blends luxury, elegance, and affordability. "
                        "Our pieces are carefully curated to ensure that every woman feels confident and radiant, no matter the occasion.",
                        textAlign: TextAlign.justify, // Justify the text
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "From timeless classics to modern statement pieces, we have something for everyone! Whether you're looking for "
                        "everyday elegance or a dazzling addition to your special outfit, Dazzle Den is your ultimate jewelry destination.",
                        textAlign: TextAlign.justify, // Justify the text
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Center(
                    child: TextContainer(title: "✨ Why Choose Dazzle Den? ✨")),
                const SizedBox(height: 15),

                // Centered feature list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 16.0, // Space between columns
                    runSpacing: 16.0, // Space between rows
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFeatureTile("🌟 Exquisite Craftsmanship",
                          "Every piece is designed with precision and love."),
                      _buildFeatureTile("💎 High-Quality Materials",
                          "Durable, hypoallergenic, and skin-friendly jewelry."),
                      _buildFeatureTile("🎁 Perfect for Every Occasion",
                          "Whether casual or grand, we have a design for you."),
                      _buildFeatureTile("🚀 Fast & Secure Shipping",
                          "Your favorite jewelry, delivered to your doorstep."),
                      _buildFeatureTile("❤️ Affordable Luxury",
                          "Shine bright without breaking the bank!"),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Center(
                    child: TextContainer(
                        title: "🌟 Over 6 Million Happy Customers 🌟")),
                const SizedBox(height: 40),

                const ResponsiveFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Centered Feature Tile
  Widget _buildFeatureTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.pinkAccent, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
