import 'dart:convert';
import 'package:flutter/material.dart';

class Item {
  final String name;
  String? receipt;
  String startDate;
  String endDate;
  String? notes;
  Image? image;

  Item({
    required this.name,
    this.receipt,
    required this.startDate,
    required this.endDate,
    this.notes,
    this.image,
  });

  // Getters
  String get getName => name;
  String? get getReceipt => receipt;
  String get getStartDate => startDate;
  String get getEndDate => endDate;
  String? get getNotes => notes;
  Image? get getImage => image;

  // Setters
  set setReceipt(String? newReceipt) {
    receipt = newReceipt;
  }

  set setStartDate(String newStartDate) {
    startDate = newStartDate;
  }

  set setEndDate(String newEndDate) {
    endDate = newEndDate;
  }

  set setNotes(String? newNotes) {
    notes = newNotes;
  }

  set setImage(Image? newImage) {
    image = newImage;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'receipt': receipt,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
      // Note: Image is not serialized here - you'll need to handle image storage separately
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      receipt: json['receipt'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      notes: json['notes'],
      // Image would need to be loaded separately
    );
  }
}