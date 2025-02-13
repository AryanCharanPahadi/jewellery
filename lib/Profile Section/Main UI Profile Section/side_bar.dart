import 'package:flutter/material.dart';

class SidebarMenu extends StatefulWidget {
  final bool isLargeScreen;
  final Function(String) onItemSelected;

  const SidebarMenu({
    super.key,
    this.isLargeScreen = false,
    required this.onItemSelected,
  });

  @override
  SidebarMenuState createState() => SidebarMenuState();
}

class SidebarMenuState extends State<SidebarMenu> {
  String selectedItem = "Personal Information"; // Default selected item

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSidebarItem("Overview"),
            _buildSidebarItem("Personal Information"),
            _buildSidebarItem("Your Address"),
            _buildSidebarItem("Order History"),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(String title) {
    bool isSelected = selectedItem == title;

    return ListTile(
      tileColor: isSelected ? Colors.red.shade50 : Colors.transparent,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.redAccent : Colors.black87,
        ),
      ),
      onTap: () {
        setState(() {
          selectedItem = title; // Update the selected item
        });
        widget
            .onItemSelected(title); // Pass the selected item back to the parent
      },
    );
  }
}
