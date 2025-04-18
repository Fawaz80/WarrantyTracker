import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class StorageService {
  static const String _dummyDataPath = 'assets/dummy_data.json';
  static bool _assetsLoaded = false;

  Future<List<User>> loadAllUsers() async {
    try {
      if (!_assetsLoaded) {
        await _loadAssets();
        _assetsLoaded = true;
      }
      
      final String jsonString = await rootBundle.loadString(_dummyDataPath);
      final jsonData = json.decode(jsonString);
      
      if (jsonData['users'] == null) {
        debugPrint('No users found in dummy data');
        return [];
      }
      
      final usersList = jsonData['users'] as List;
      return usersList.map((userJson) => User.fromJson(userJson)).toList();
    } catch (e) {
      debugPrint('Error loading dummy data: $e');
      return [];
    }
  }

  Future<void> _loadAssets() async {
    try {
      await rootBundle.loadString(_dummyDataPath);
    } catch (e) {
      debugPrint('Failed to load assets: $e');
      throw Exception('Could not load assets. Make sure dummy_data.json exists in assets/');
    }
  }

  Future<User?> authenticateUser(String email, String password) async {
    try {
      final users = await loadAllUsers();
      return users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } on StateError catch (_) {
      debugPrint('User not found');
      return null;
    } catch (e) {
      debugPrint('Authentication error: $e');
      return null;
    }
  }
}