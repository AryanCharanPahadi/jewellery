// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ResponsiveFooter extends StatelessWidget {
//   const ResponsiveFooter({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//
//     // Responsive column width calculation
//     double columnWidth = screenWidth > 600
//         ? screenWidth / 4 - 16 // Show 4 columns on larger screens
//         : screenWidth / 2 - 16; // Show 2 columns on smaller screens
//
//     // Adjustments for very small screens including widths below 200 pixels
//     double textSize = screenWidth <= 200
//         ? 6
//         : screenWidth <= 250
//         ? 8
//         : screenWidth <= 300
//         ? 10
//         : 12; // Adjust text size for small screens
//     double iconSize = screenWidth <= 200
//         ? 10
//         : screenWidth <= 250
//         ? 12
//         : screenWidth <= 300
//         ? 14
//         : 16; // Adjust icon size for small screens
//     double storeLinkHeight = screenWidth <= 200
//         ? 25
//         : screenWidth <= 250
//         ? 30
//         : screenWidth <= 300
//         ? 35
//         : 40; // Adjust store link height
//     double storeLinkWidth = screenWidth <= 200
//         ? 70
//         : screenWidth <= 250
//         ? 80
//         : screenWidth <= 300
//         ? 100
//         : 120; // Adjust store link width
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[100], // Soft background color
//       ),
//       padding: EdgeInsets.all(screenWidth <= 200 ? 6.0 : screenWidth <= 250 ? 8.0 : 16.0), // Adjust padding
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Footer Sections
//           Padding(
//             padding: EdgeInsets.all(screenWidth <= 200 ? 6.0 : screenWidth <= 250 ? 8.0 : 12.0),
//             child: Wrap(
//               alignment: WrapAlignment.spaceBetween,
//               spacing: screenWidth <= 200 ? 6.0 : screenWidth <= 250 ? 8.0 : 16.0,
//               runSpacing: screenWidth <= 200 ? 10.0 : screenWidth <= 250 ? 12.0 : 20.0,
//               children: [
//                 _buildSection(
//                   "NEED HELP",
//                   [
//                     {"icon": Icons.contact_support, "text": "Contact Us"},
//                     {"icon": Icons.local_shipping, "text": "Track Order"},
//                     {"icon": Icons.undo, "text": "Returns & Refunds"},
//                     {"icon": Icons.help_outline, "text": "FAQs"},
//                     {"icon": Icons.account_circle, "text": "My Account"},
//                   ],
//                   columnWidth,
//                   textSize,
//                   iconSize,
//                 ),
//                 _buildSection(
//                   "COMPANY",
//                   [
//                     {"icon": Icons.info, "text": "About Us"},
//                     {"icon": Icons.work, "text": "Careers"},
//                     {"icon": Icons.card_giftcard, "text": "Gift Vouchers"},
//                   ],
//                   columnWidth,
//                   textSize,
//                   iconSize,
//                 ),
//                 _buildSection(
//                   "MORE INFO",
//                   [
//                     {"icon": Icons.description, "text": "T&C"},
//                     {"icon": Icons.privacy_tip, "text": "Privacy Policy"},
//                     {"icon": Icons.web, "text": "Sitemap"},
//                     {"icon": Icons.article, "text": "Blogs"},
//                   ],
//                   columnWidth,
//                   textSize,
//                   iconSize,
//                 ),
//                 _buildSection(
//                   "STORES",
//                   [
//                     {"icon": Icons.location_on, "text": "Mumbai"},
//                     {"icon": Icons.location_on, "text": "Pune"},
//                     {"icon": Icons.location_on, "text": "Bengaluru"},
//                     {"icon": Icons.location_on, "text": "View More"},
//                   ],
//                   columnWidth,
//                   textSize,
//                   iconSize,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 25),
//           // App Links Section
//           Column(
//             children: [
//               Text(
//                 "EXPERIENCE THE LUXURY APP",
//                 style: GoogleFonts.lora(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.brown[800],
//                   fontSize: textSize,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildStoreLink("Google Play", Colors.green, storeLinkHeight, storeLinkWidth),
//                   const SizedBox(width: 16),
//                   _buildStoreLink("App Store", Colors.blue, storeLinkHeight, storeLinkWidth),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 25),
//           // Social Media Section
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildSocialIcon(FontAwesomeIcons.facebook, Colors.blue, iconSize),
//               _buildSocialIcon(FontAwesomeIcons.instagram, Colors.purple, iconSize),
//               _buildSocialIcon(FontAwesomeIcons.twitter, Colors.lightBlue, iconSize),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Text(
//             "© 2025 DazzleDen. All rights reserved.",
//             style: GoogleFonts.lora(
//               fontSize: textSize - 2,
//               color: Colors.brown[800],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSection(
//       String title, List<Map<String, dynamic>> items, double width, double textSize, double iconSize) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//         maxWidth: width,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.dancingScript(
//               fontWeight: FontWeight.bold,
//               fontSize: textSize + 2,
//               color: Colors.brown[900],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: items.map((item) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: Row(
//                   children: [
//                     Icon(
//                       item["icon"],
//                       color: Colors.brown[800],
//                       size: iconSize,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       item["text"],
//                       style: GoogleFonts.lora(
//                         fontSize: textSize,
//                         color: Colors.brown[700],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStoreLink(String storeName, Color color, double height, double width) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         border: Border.all(color: color),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: Text(
//           storeName,
//           style: GoogleFonts.lora(
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSocialIcon(IconData icon, Color color, double iconSize) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: CircleAvatar(
//         backgroundColor: color.withOpacity(0.2),
//         child: Icon(
//           icon,
//           color: color,
//           size: iconSize,
//         ),
//       ),
//     );
//   }
// }
//
//
//
//

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Component/text_style.dart';

class ResponsiveFooter extends StatelessWidget {
  const ResponsiveFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double columnWidth = screenWidth > 800
        ? screenWidth / 4 - 24
        : screenWidth > 400
            ? screenWidth / 2 - 24
            : screenWidth - 48;

    double textSize = screenWidth <= 200
        ? 8
        : screenWidth <= 250
            ? 10
            : screenWidth <= 300
                ? 12
                : 14;
    double iconSize = textSize + 6;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
          vertical: screenWidth <= 250 ? 12 : 18, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 28,
              runSpacing: 22,
              children: [
                _buildSection(
                    "NEED HELP",
                    [
                      {"icon": Icons.contact_support, "text": "Contact Us"},
                      {"icon": Icons.local_shipping, "text": "Track Order"},
                      {"icon": Icons.undo, "text": "Returns & Refunds"},
                      {"icon": Icons.help_outline, "text": "FAQs"},
                      {"icon": Icons.account_circle, "text": "My Account"},
                    ],
                    columnWidth,
                    textSize,
                    iconSize),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                  FontAwesomeIcons.instagram, Colors.purple, iconSize),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            "© 2025 DazzleDen. All rights reserved.",
            style: getTextStyle(
              fontSize: textSize,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items,
      double width, double textSize, double iconSize) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textSize + 4,
              color: Colors.brown[900] ??
                  Colors.black, // Use black as fallback if null
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Icon(item["icon"],
                        color: Colors.brown[800], size: iconSize),
                    const SizedBox(width: 10),
                    Text(
                      item["text"],
                      style: getTextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: textSize,
                        color: Colors.brown[900] ??
                            Colors.black, // Use black as fallback if null
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, double iconSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
