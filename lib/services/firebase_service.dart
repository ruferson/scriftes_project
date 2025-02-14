import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skriftes_project_2/services/models/letter.dart';
import 'package:skriftes_project_2/services/models/user.dart';
import 'package:skriftes_project_2/utils/helpers.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para obtener el ID del usuario actualmente autenticado
  Future<String> getCurrentUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    throw Exception('User not logged in');
  }

  Future<UserData> getUserData(String userId) async {
    try {
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      final userData = userSnapshot.data();
      if (userData != null) {
        return UserData(
            id: userId,
            createdAt: (userData['_createdAt'] as Timestamp).toDate(),
            friendCode: userData['friend_code'],
            friends: (userData['friends'] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
            location: userData['location'],
            username: userData['username']);
      }
      throw Exception('User data not found');
    } catch (e) {
      print('Error getting user data: $e');
      rethrow;
    }
  }

  Future<UserData> getMyUserData() async {
    try {
      final myId = await getCurrentUserId();
      return getUserData(myId);
    } catch (e) {
      print('Error getting user data: $e');
      rethrow;
    }
  }

  // Método para enviar una carta
  Future<void> sendLetter(
      String recipientId, List<LetterContent> message) async {
    try {
      final senderId = await getCurrentUserId();
      final sender = await getUserData(senderId);
      final recipient = await getUserData(recipientId);

      await _firestore.collection('letters').add({
        'senderId': senderId,
        'recipientId': recipientId,
        'message': message.map((e) => ({"text": e.text, "styles": e.styles})),
        '_createdAt': DateTime.now(),
        '_deliveredAt': calculateArrivalDate(SendingLetter(
            DateTime.now(),
            Location(sender.location.latitude, sender.location.longitude),
            Location(
                recipient.location.latitude, recipient.location.longitude))),
      });
    } catch (e) {
      print('Error sending letter: $e');
      rethrow;
    }
  }

  // Método para obtener las cartas recibidas por el usuario
  Future<List<Letter>> getReceivedLetters(String userId) {
    return _firestore
        .collection('letters')
        .where('recipientId', isEqualTo: userId)
        .where('_deliveredAt', isLessThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('_createdAt', descending: true)
        .get()
        .then((querySnapshot) async {
      List<Future<Letter>> letters = _convertSnapshotToLetters(querySnapshot);
      // Espera a que todas las cartas se resuelvan y devuelve la lista de cartas resueltas
      return Future.wait(letters);
    });
  }

  // Método para obtener las cartas enviadas por el usuario
  Future<List<Letter>> getSentLetters(String userId) async {
    return _firestore
        .collection('letters')
        .where('senderId', isEqualTo: userId)
        .orderBy('_createdAt', descending: true)
        .get()
        .then((querySnapshot) async {
      List<Future<Letter>> letters = _convertSnapshotToLetters(querySnapshot);
      // Espera a que todas las cartas se resuelvan y devuelve la lista de cartas resueltas
      return Future.wait(letters);
    });
  }

  // Método para convertir el snapshot de cartas en una lista de objetos Letter
  List<Future<Letter>> _convertSnapshotToLetters(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      UserData sender = await getUserData(data['senderId']);
      UserData recipient = await getUserData(data['recipientId']);
      // Parsea los datos del documento a un objeto Letter
      return Letter(
        senderId: data['senderId'],
        recipientId: data['recipientId'],
        senderName: sender.username,
        recipientName: recipient.username,
        message: _convertMessage(data['message']),
        createdAt: (data['_createdAt'] as Timestamp).toDate(),
        deliveredAt: (data['_deliveredAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  // Método para convertir los datos del mensaje en una lista de objetos LetterItem
  List<LetterContent> _convertMessage(List<dynamic> messageData) {
    return messageData.map((item) {
      return LetterContent(
        text: item['text'] as String,
        styles: item['styles'] as Map<String, dynamic>,
      );
    }).toList();
  }

  // Constructor de la clase FirebaseService
  FirebaseService();

  // Método para inicializar Firebase
  Future<void> initFirebase() async {}
}
