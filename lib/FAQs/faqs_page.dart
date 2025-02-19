import 'package:flutter/material.dart';

import '../Component/text_container.dart';
import '../Headers/custom_header.dart';
import '../Headers/header2_delegates.dart';
import '../Headers/second_header.dart';
import '../Footer/footer.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

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
                const Center(child: TextContainer(title: "✨ FAQs ✨")),
                const SizedBox(height: 20),

                // FAQ Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildFaqTile(
                        "What is Dazzle Den?",
                        "Dazzle Den is your ultimate destination for premium artificial jewelry. We specialize in offering stunning, high-quality designs that cater to every occasion, from casual outings to formal events. Our collection is carefully curated to ensure that you find the perfect piece to complement your style.",
                      ),
                      _buildFaqTile(
                        "Do you offer cash on delivery?",
                        "Yes, we offer cash on delivery (COD) for select locations. This option allows you to pay for your order in cash when it is delivered to your doorstep. Please note that COD availability may vary depending on your region, so we recommend checking the payment options during checkout.",
                      ),
                      _buildFaqTile(
                        "What materials are used in your jewelry?",
                        "Our jewelry is crafted from high-quality, hypoallergenic materials to ensure both durability and comfort. We use materials such as stainless steel, brass, and zinc alloy, which are known for their resistance to tarnishing and skin irritation. Additionally, our pieces are often adorned with crystals, pearls, and other embellishments to add a touch of elegance.",
                      ),
                      _buildFaqTile(
                        "How can I track my order?",
                        "Once your order has been shipped, you will receive a tracking link via email or SMS. This link will allow you to monitor the status of your shipment in real-time. You can also log in to your account on our website and navigate to the 'Order History' section to view the tracking details.",
                      ),
                      _buildFaqTile(
                        "Do you offer returns or exchanges?",
                        "Yes, we offer a hassle-free return and exchange policy. If you are not completely satisfied with your purchase, you can return or exchange the item within 30 days of delivery. Please ensure that the item is in its original condition with all tags attached. For more details, please refer to our Returns & Exchanges policy on our website.",
                      ),
                      _buildFaqTile(
                        "How long does shipping take?",
                        "Shipping times may vary depending on your location and the shipping method selected during checkout. Typically, orders are processed within 1-2 business days and delivered within 5-7 business days for domestic shipments. International shipping may take longer, depending on customs and local delivery services.",
                      ),
                      _buildFaqTile(
                        "Do you ship internationally?",
                        "Yes, we offer international shipping to most countries. During checkout, you can select your country, and the available shipping options will be displayed. Please note that international orders may be subject to customs duties and taxes, which are the responsibility of the customer.",
                      ),
                      _buildFaqTile(
                        "Can I cancel my order?",
                        "You can cancel your order as long as it has not yet been shipped. To cancel, please contact our customer support team with your order number, and they will assist you with the process. If your order has already been shipped, you will need to follow our return policy once the item is delivered.",
                      ),
                      _buildFaqTile(
                        "What payment methods do you accept?",
                        "We accept a variety of payment methods, including credit/debit cards, PayPal, and cash on delivery (for select locations). All transactions are securely processed to ensure the safety of your personal and payment information.",
                      ),
                      _buildFaqTile(
                        "How do I care for my jewelry?",
                        "To maintain the beauty and longevity of your jewelry, we recommend storing it in a cool, dry place away from direct sunlight. Avoid exposing your jewelry to water, perfumes, or harsh chemicals, as these can cause damage. Gently clean your pieces with a soft cloth to remove any dirt or oils.",
                      ),
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

  // Helper method to build FAQ items
  Widget _buildFaqTile(String question, String answer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
