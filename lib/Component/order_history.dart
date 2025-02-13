import 'package:flutter/material.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderHistory = [
      {
        'order_id': 'ORD12345',
        'date': '2024-01-10',
        'amount': '\$250.00',
        'status': 'Delivered',
      },
      {
        'order_id': 'ORD12346',
        'date': '2024-01-15',
        'amount': '\$150.00',
        'status': 'Shipped',
      },
      {
        'order_id': 'ORD12347',
        'date': '2024-01-20',
        'amount': '\$320.00',
        'status': 'Processing',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Order History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: orderHistory.map((order) {
                    return OrderDetailRow(
                      orderId: order['order_id'],
                      date: order['date'],
                      amount: order['amount'],
                      status: order['status'],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailRow extends StatelessWidget {
  final String orderId;
  final String date;
  final String amount;
  final String status;

  const OrderDetailRow({
    super.key,
    required this.orderId,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order ID: $orderId",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text("Date: $date", style: const TextStyle(fontSize: 14)),
          Text("Amount: $amount", style: const TextStyle(fontSize: 14)),
          Text("Status: $status", style: const TextStyle(fontSize: 14, color: Colors.green)),
          const Divider(),
        ],
      ),
    );
  }
}