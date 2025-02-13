
import 'package:flutter/material.dart';

class PageNotFoundScreen extends StatelessWidget {
  final String routeName;

  const PageNotFoundScreen({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text('404 - Page Not Found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(
              'You tried to access: $routeName',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
