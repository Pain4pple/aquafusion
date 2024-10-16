import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
    } catch (e) {
      print('Error adding user data: $e');
    }
  }

  Future<void> addSetupData(String userId, Map<String, dynamic> setupData) async {
    try {
      await _db.collection('users').doc(userId).collection('setup').add(setupData);
    } catch (e) {
      print('Error adding setup data: $e');
    }
  }
  
}
