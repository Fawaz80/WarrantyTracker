import 'item.dart';

class User {
  final String email;
  final String password; // Note: This is only for the local model, not stored in Firestore
  List<Item> items;

  User({
    required this.email,
    this.password = '', // Default empty password
    this.items = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((itemJson) => Item.fromJson(itemJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  void printUserData() {
    print('User: $email');
    print('Number of items: ${items.length}');
    for (var item in items) {
      print('\nItem: ${item.name}');
      print('Warranty Period: ${item.startDate} to ${item.endDate}');
      if (item.notes != null) print('Notes: ${item.notes}');
      if (item.receipt != null) print('Receipt: ${item.receipt}');
    }
  }
}