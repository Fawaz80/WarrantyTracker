import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if email already exists
  Future<bool> emailExists(String email) async {
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  // Register new user
  Future<Map<String, dynamic>?> signUpUser(String email, String password) async {
    try {
      if (await emailExists(email)) {
        return null;
      }

      final docRef = await _firestore.collection('users').add({
        'email': email,
        'password': password, // In production, never store plain passwords
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'userId': docRef.id,
        'email': email,
      };
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  // Login user
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return {
          'userId': query.docs.first.id,
          'email': query.docs.first.data()['email'],
        };
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Get user's items with IDs
  Future<List<QueryDocumentSnapshot>> getUserItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('items')
          .get();
      return snapshot.docs;
    } catch (e) {
      print('Error getting items: $e');
      return [];
    }
  }

  // Add new item
  Future<String> addItem(String userId, Map<String, dynamic> itemData) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('items')
          .add(itemData);
      return docRef.id;
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  // Update item
  Future<void> updateItem(
    String userId, 
    String itemId, 
    Map<String, dynamic> data
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .update(data);
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  // Delete item
  Future<void> deleteItem(String userId, String itemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .delete();
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }
}