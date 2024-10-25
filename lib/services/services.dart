// user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _box = GetStorage();

//get user info from UID
  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return null; // Handle error appropriately
    }
  }

  // Method to fetch user data
  Map<String, dynamic>? getUserData() {
    final userData = _box.read('userData');
    return userData != null ? Map<String, dynamic>.from(userData) : null;
  }

  // Example method to fetch a specific field
  String getUserName() {
    final userData = getUserData();
    return userData?['name'] ?? 'no name';
  }

  String getUserProfilePic() {
    final userData = getUserData();
    return userData?['profilePic'] ?? 'not pfp';
  }

  String getUserUID() {
    final userData = getUserData();
    return userData?['uid'] ?? 'No UID';
  }
}
