import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skriftes_project/services/models/letter.dart';
import 'package:skriftes_project/utils/helpers.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    throw Exception('User not logged in');
  }

  Future<String> getSenderId() async {
    try {
      final userId = await getCurrentUserId();
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      final userData = userSnapshot.data();
      if (userData != null) {
        return userId;
      }
      throw Exception('User data not found');
    } catch (e) {
      print('Error getting senderId: $e');
      throw e;
    }
  }

  Future<GeoPoint> getUserLocation(String userId) async {
    try {
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      final userData = userSnapshot.data();
      if (userData != null && userData['location'] != null) {
        return userData['location'];
      }
      throw Exception('User location not found');
    } catch (e) {
      print('Error getting user location: $e');
      throw e;
    }
  }

  Future<void> sendLetter(String recipientId, List<LetterItem> message) async {
    try {
      final senderId = await getSenderId();
      final senderLocation = await getUserLocation(senderId);
      final recipientLocation = await getUserLocation(recipientId);

      var result = await _firestore.collection('letters').add({
        'senderId': senderId,
        'recipientId': recipientId,
        'message': message.map((e) => ({"text": e.text, "styles": e.styles})),
        '_createdAt': DateTime.now(),
        '_deliveredAt': calculateArrivalDate(Letter(
            DateTime.now(),
            Location(senderLocation.latitude, senderLocation.longitude),
            Location(recipientLocation.latitude, recipientLocation.longitude))),
      });
    } catch (e) {
      print('Error sending letter: $e');
      rethrow;
    }
  }

  Stream<List<DocumentSnapshot>> getLetters(String userId) {
    return _firestore
        .collection('letters')
        .where('recipientId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  FirebaseService();

  Future<void> initFirebase() async {}
}
