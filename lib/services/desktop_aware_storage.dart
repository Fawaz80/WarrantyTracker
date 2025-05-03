import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class DesktopAwareStorage {
  static const String _dummyDataPath = 'assets/dummy_data.json';
  static const String _fileName = 'warranty_tracker_data.json';
  static bool _assetsLoaded = false;
  static List<User>? _cachedUsers;
  
  // ALWAYS use the custom desktop path, even for simulators
  static const bool _forceDesktopPath = true;
  
  // The custom path to use - now inside the project folder
  static const String _customDesktopPath = '../../assets';
  
  // Get the appropriate file path based on platform
  Future<File> _getDataFile() async {
    // For iOS simulator during development, we'll use the project path
    if (_forceDesktopPath) {
      final path = _customDesktopPath;
      
      // Create directory if it doesn't exist
      final directory = Directory(path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      final filePath = '$path/$_fileName';
      debugPrint('Forcing use of project file at: $filePath');
      return File(filePath);
    } else {
      // Standard approach - use app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$_fileName';
      debugPrint('Using app directory file at: $filePath');
      return File(filePath);
    }
  }
  
  // Check if data file exists
  Future<bool> _dataFileExists() async {
    final file = await _getDataFile();
    return await file.exists();
  }
  
  // Initialize data file from assets if needed
  Future<void> _initializeDataFile() async {
    if (await _dataFileExists()) {
      // File exists - check for updates from dummy data
      await _syncWithDummyData();
      return;
    }
    
    try {
      // Load asset data
      final jsonString = await rootBundle.loadString(_dummyDataPath);
      
      // Parse and re-format with indentation
      final jsonData = json.decode(jsonString);
      final JsonEncoder encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(jsonData);
      
      final file = await _getDataFile();
      
      // Write formatted data to file
      await file.writeAsString(prettyJson);
      debugPrint('Data file initialized from assets at: ${file.path}');
    } catch (e) {
      debugPrint('Error initializing data file: $e');
      throw Exception('Failed to initialize data file: $e');
    }
  }
  
  // Sync with dummy data - add any new sample data without overwriting existing users
  Future<void> _syncWithDummyData() async {
    try {
      // Load current data
      final file = await _getDataFile();
      final currentDataString = await file.readAsString();
      final Map<String, dynamic> currentData = json.decode(currentDataString);
      
      // Load dummy data
      final dummyDataString = await rootBundle.loadString(_dummyDataPath);
      final Map<String, dynamic> dummyData = json.decode(dummyDataString);
      
      bool hasChanges = false;
      
      // Check if there are any changes in dummy data that need to be merged
      final currentUsers = currentData['users'] as List;
      final dummyUsers = dummyData['users'] as List;
      
      // Create a map of emails to users for easier lookup
      final Map<String, dynamic> currentUserMap = {};
      for (var user in currentUsers) {
        currentUserMap[user['email']] = user;
      }
      
      // Check for new users in dummy data
      for (var dummyUser in dummyUsers) {
        final String email = dummyUser['email'];
        
        if (!currentUserMap.containsKey(email)) {
          // This is a new sample user - add to our data
          currentUsers.add(dummyUser);
          hasChanges = true;
          debugPrint('Added new sample user: $email');
        } else {
          // User exists - check if they have new items
          final currentUser = currentUserMap[email];
          final currentItems = currentUser['items'] as List;
          final dummyItems = dummyUser['items'] as List;
          
          // Create a map of item names for easier lookup
          final Map<String, dynamic> currentItemMap = {};
          for (var item in currentItems) {
            currentItemMap[item['name']] = item;
          }
          
          // Check for new items
          for (var dummyItem in dummyItems) {
            final String itemName = dummyItem['name'];
            
            if (!currentItemMap.containsKey(itemName)) {
              // This is a new sample item - add to user
              currentItems.add(dummyItem);
              hasChanges = true;
              debugPrint('Added new sample item "$itemName" to user: $email');
            }
          }
        }
      }
      
      // Save changes if any were made
      if (hasChanges) {
        final JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final updatedJson = encoder.convert(currentData);
        await file.writeAsString(updatedJson);
        debugPrint('Synced with dummy data - added new sample content');
        
        // Clear cache to ensure we reload the updated data
        _cachedUsers = null;
      } else {
        debugPrint('No new sample content to sync from dummy data');
      }
    } catch (e) {
      debugPrint('Error syncing with dummy data: $e');
      // Don't throw exception here - just log the error and continue
    }
  }
  
  // Save data to file
  Future<void> _saveData(List<User> users) async {
    try {
      final file = await _getDataFile();
      final userData = users.map((user) => user.toJson()).toList();
      final data = {'users': userData};
      
      // Use JsonEncoder with indentation for pretty printing
      final JsonEncoder encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(data);
      
      await file.writeAsString(jsonString);
      debugPrint('Data saved to file: ${file.path}');
      
      // Update cache
      _cachedUsers = List.from(users);
    } catch (e) {
      debugPrint('Error saving data: $e');
      throw Exception('Failed to save data: $e');
    }
  }
  
  // Load all users
  Future<List<User>> loadAllUsers() async {
    // Return cached users if available
    if (_cachedUsers != null) {
      return _cachedUsers!;
    }
    
    try {
      if (!_assetsLoaded) {
        await _loadAssets();
        _assetsLoaded = true;
      }
      
      // Initialize data file if needed
      await _initializeDataFile();
      
      // Read data file
      final file = await _getDataFile();
      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString);
      
      if (jsonData['users'] == null) {
        debugPrint('No users found in data file');
        return [];
      }
      
      final usersList = jsonData['users'] as List;
      _cachedUsers = usersList.map((userJson) => User.fromJson(userJson)).toList();
      
      // Print file location for debugging
      debugPrint('Data loaded from: ${file.path}');
      return _cachedUsers!;
    } catch (e) {
      debugPrint('Error loading data: $e');
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
  
  // Force sync with dummy data - can be called manually
  Future<void> syncWithDummyData() async {
    await _syncWithDummyData();
    // Clear cache to ensure we reload the updated data
    _cachedUsers = null;
  }
  
  // Authenticate user
  Future<User?> authenticateUser(String email, String password) async {
    try {
      final users = await loadAllUsers();
      final user = users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      debugPrint('User authenticated: ${user.email}');
      return user;
    } on StateError catch (_) {
      debugPrint('User not found with email: $email');
      return null;
    } catch (e) {
      debugPrint('Authentication error: $e');
      return null;
    }
  }
  
  // Register new user
  Future<bool> registerUser(String email, String password) async {
    try {
      // Load users
      final users = await loadAllUsers();
      
      // Check if email already exists
      final bool emailExists = users.any((user) => user.email == email);
      
      if (emailExists) {
        debugPrint('Email already exists: $email');
        return false;
      }
      
      // Create new user
      final newUser = User(
        email: email,
        password: password,
        items: [],
      );
      
      // Add to users list
      users.add(newUser);
      
      // Save to file
      await _saveData(users);
      
      debugPrint('New user registered and saved: $email');
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }
  
  // For debugging: Print data file path
  Future<void> printDataFilePath() async {
    final file = await _getDataFile();
    debugPrint('=============================');
    debugPrint('DATA FILE PATH: ${file.path}');
    debugPrint('=============================');
  }
} 