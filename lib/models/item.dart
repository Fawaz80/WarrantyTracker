class Item {
  String? id; // Add this for Firestore document ID
  String name;
  String? receipt;
  String startDate;
  String endDate;
  String? notes;

  Item({
    this.id,
    required this.name,
    this.receipt,
    required this.startDate,
    required this.endDate,
    this.notes,
  });

  // Remove all getters/setters and keep just the basic model
  // Add fromJson and toJson methods

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? '',
      receipt: json['receipt'],
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'receipt': receipt,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
    };
  }
}