class LetterContent {
  final String text;
  final Map<String, dynamic>? styles;

  LetterContent({required this.text, required this.styles});
}

class Letter {
  final String senderId;
  final String recipientId;
  final String senderName;
  final String recipientName;
  final List<LetterContent> message;
  final DateTime createdAt;
  final DateTime deliveredAt;

  Letter({
    required this.senderId,
    required this.recipientId,
    required this.senderName,
    required this.recipientName,
    required this.message,
    required this.createdAt,
    required this.deliveredAt,
  });
}
