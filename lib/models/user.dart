import 'item.dart';

class User {
  final String email;
  final String password;
  List<Item> items;

  User({
    required this.email,
    required this.password,
    this.items = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      items: (json['items'] as List)
          .map((itemJson) => Item.fromJson(itemJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
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
