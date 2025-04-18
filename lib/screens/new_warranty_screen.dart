import 'package:flutter/material.dart';
import '../models/user.dart';

class NewWarrantyScreen extends StatelessWidget {
  final User user;

  const NewWarrantyScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Warranty')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Add new warranty item here'),
            Text('For user: ${user.email}'), // Example usage
          ],
        ),
      ),
    );
  }
}