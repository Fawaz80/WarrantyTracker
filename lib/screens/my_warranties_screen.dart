import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/item.dart';
import 'new_warranty_screen.dart';
import 'selected_warranty_screen.dart';
import '../services/firebase_service.dart';
import 'package:intl/intl.dart';

class MyWarrantiesScreen extends StatefulWidget {
  final User user;
  final String userId;

  const MyWarrantiesScreen({
    super.key,
    required this.user,
    required this.userId,
  });

  @override
  State<MyWarrantiesScreen> createState() => _MyWarrantiesScreenState();
}

class _MyWarrantiesScreenState extends State<MyWarrantiesScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _sortOption = 'Sort by Date (Oldest First)';

  String calculateTimeLeft(String endDate) {
    final end = DateFormat('yyyy-MM-dd').parse(endDate);
    final remaining = end.difference(DateTime.now());
    return remaining.isNegative 
        ? "Expired" 
        : "${(remaining.inDays / 7).floor()} weeks left";
  }

  void _sortWarranties(String option) {
    setState(() {
      _sortOption = option;
      widget.user.items.sort((a, b) {
        final endA = DateFormat('yyyy-MM-dd').parse(a.endDate);
        final endB = DateFormat('yyyy-MM-dd').parse(b.endDate);
        return option == 'Sort by Date (Oldest First)'
            ? endA.compareTo(endB)
            : endB.compareTo(endA);
      });
    });
  }

  Future<void> _deleteItem(int index) async {
    final item = widget.user.items[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Warranty'),
        content: Text('Delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firebaseService.deleteItem(widget.userId, item.id!);
                setState(() => widget.user.items.removeAt(index));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Warranty deleted')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Warranties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              value: _sortOption,
              onChanged: (value) => _sortWarranties(value!),
              items: [
                'Sort by Date (Oldest First)',
                'Sort by Date (Newest First)',
              ].map((value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.user.items.length,
              itemBuilder: (context, index) {
                final item = widget.user.items[index];
                return Dismissible(
                  key: Key(item.id!),
                  background: Container(color: Colors.red),
                  onDismissed: (_) => _deleteItem(index),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(calculateTimeLeft(item.endDate)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(index),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedWarrantyScreen(
                          user: widget.user,
                          item: item,
                          userId: widget.userId,
                          itemId: item.id!,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewWarrantyScreen(
                        userId: widget.userId,
                        onItemAdded: (newItem) {
                          setState(() => widget.user.items.add(newItem));
                        },
                      ),
                    ),
                  ),
                  child: const Text('Add New Warranty'),
                ),
                Text('Logged in as: ${widget.user.email}'),
                Text('Total items: ${widget.user.items.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}