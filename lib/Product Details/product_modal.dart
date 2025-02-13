class Product {
  final int itemId;
  final String itemTitle;
  final String itemName;
  final String itemPrice;
  final String itemSize;
  final String itemDesc;
  final String itemImg;

  Product({
    required this.itemId,
    required this.itemTitle,
    required this.itemName,
    required this.itemPrice,
    required this.itemSize,
    required this.itemDesc,
    required this.itemImg,
  });

  // Convert the Product object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': itemId,
      'item_title': itemTitle,
      'item_name': itemName,
      'item_price': itemPrice,
      'item_size': itemSize,
      'item_desc': itemDesc,
      'item_img': itemImg,
    };
  }

  // Factory method to create a Product from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      itemId: int.tryParse(json['id']?.toString() ?? '') ??
          0, // Safely parse to int
      itemTitle: json['item_title']?.toString() ?? '', // Ensure non-null String
      itemName: json['item_name']?.toString() ?? '', // Ensure non-null String
      itemPrice: json['item_price']?.toString() ?? '', // Ensure non-null String
      itemSize: json['item_size']?.toString() ?? '', // Ensure non-null String
      itemDesc: json['item_desc']?.toString() ?? '', // Ensure non-null String
      itemImg: json['item_img']?.toString() ?? '', // Ensure non-null String
    );
  }
}



