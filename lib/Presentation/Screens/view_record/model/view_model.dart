import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String name;
  final String email;

  UserData({
    required this.name,
    required this.email,
  });
  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }

}
