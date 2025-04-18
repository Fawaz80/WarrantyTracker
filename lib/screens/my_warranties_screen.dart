import 'package:flutter/material.dart';
import '../models/user.dart';
import 'new_warranty_screen.dart';
import 'selected_warranty_screen.dart';

class MyWarrantiesScreen extends StatelessWidget {
  final User user;  // Add this line to accept user parameter

  const MyWarrantiesScreen({super.key, required this.user});  // Update constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Warranties')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewWarrantyScreen(user: user)),
                );
              },
              child: const Text('Add New Warranty'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectedWarrantyScreen()),
                );
              },
              child: const Text('View Selected Warranty'),
            ),
            const SizedBox(height: 20),
            Text('Logged in as: ${user.email}'),  // Example of using the user data
            Text('You have ${user.items.length} warranty items'),  // Show item count
          ],
        ),
      ),
    );
  }
}