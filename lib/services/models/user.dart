import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String username;
  final GeoPoint location;
  final String friendCode;
  final List<String> friends;
  final DateTime createdAt;

  UserData({
    required this.username,
    required this.location,
    required this.friendCode,
    required this.friends,
    required this.createdAt,
  });
}
