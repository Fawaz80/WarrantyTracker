import 'package:flutter/material.dart';
import '../models/user.dart';
import 'new_warranty_screen.dart';
import 'selected_warranty_screen.dart';
import 'package:intl/intl.dart'; // To format the date easily

class MyWarrantiesScreen extends StatefulWidget {
  final User user; // Accept user parameter

  const MyWarrantiesScreen(
      {super.key, required this.user}); // Update constructor

  @override
  _MyWarrantiesScreenState createState() => _MyWarrantiesScreenState();
}

class _MyWarrantiesScreenState extends State<MyWarrantiesScreen> {
  String _sortOption = 'Sort by Date (Oldest First)'; // Default sort option

  // Function to calculate the time left for warranty
  String calculateTimeLeft(String endDate) {
    DateTime warrantyEndDate = DateFormat('yyyy-MM-dd').parse(endDate);
    Duration remaining = warrantyEndDate.difference(DateTime.now());

    if (remaining.isNegative) {
      return "Warranty is over";
    } else {
      int weeksLeft = (remaining.inDays / 7).floor();
      return "$weeksLeft weeks left";
    }
  }

  // Function to sort warranties by time left
  void _sortWarranties(String option) {
    setState(() {
      _sortOption = option;
      widget.user.items.sort((a, b) {
        DateTime endA = DateFormat('yyyy-MM-dd').parse(a.getEndDate);
        DateTime endB = DateFormat('yyyy-MM-dd').parse(b.getEndDate);
        return option == 'Sort by Date (Oldest First)'
            ? endA.compareTo(endB)
            : endB.compareTo(endA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Warranties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Simulating sign-out, replace with actual sign-out logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for sorting
            Align(
              alignment: Alignment.centerRight, // Align to the right
              child: DropdownButton<String>(
                value: _sortOption,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _sortWarranties(newValue);
                  }
                },
                items: <String>[
                  'Sort by Date (Oldest First)',
                  'Sort by Date (Newest First)',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Warranty List
            Expanded(
              child: ListView.builder(
                itemCount: widget
                    .user.items.length, // Iterate through user's warranty items
                itemBuilder: (context, index) {
                  final warranty = widget.user.items[index];
                  String timeLeft = calculateTimeLeft(warranty.getEndDate);

                  return ListTile(
                    title: Text(warranty.getName),
                    subtitle: Text(timeLeft),
                    onTap: () {
                      // Navigate to SelectedWarrantyScreen with warranty details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectedWarrantyScreen(
                            item: warranty,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // User Info and Buttons
            Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Align buttons in a row
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewWarrantyScreen(user: widget.user)),
                        );
                      },
                      child: const Text('Add New Warranty'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               const SelectedWarrantyScreen()),
                    //     );
                    //   },
                    //   child: const Text('View Selected Warranty'),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Logged in as: ${widget.user.email}'),
                Text('You have ${widget.user.items.length} warranty items'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
