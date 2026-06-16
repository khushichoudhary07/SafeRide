import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static const String userId = "test_user";

  static CollectionReference get contacts =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('contacts');

  static Future<void> addContact(String name, String phone) async {
    await contacts.add({
      'name': name,
      'phone': phone,
    });
  }

  static Future<void> deleteContact(String id) async {
    await contacts.doc(id).delete();
  }
}