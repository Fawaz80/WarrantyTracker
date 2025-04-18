import 'package:flutter/material.dart';

class SelectedWarrantyScreen extends StatelessWidget {
  const SelectedWarrantyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selected Warranty')),
      body: const Center(
        child: Text('Selected Warranty Screen'),
      ),
    );
  }
}