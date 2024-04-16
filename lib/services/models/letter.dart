import 'package:flutter/widgets.dart';
import 'package:skriftes_project/utils/helpers.dart';

class LetterContent {
  final String text;
  final Map<String, dynamic>? styles;

  LetterContent({required this.text, required this.styles});

  factory LetterContent.fromJson(Map<String, dynamic> json) {
    return LetterContent(
      text: json['text'],
      styles: json['styles'],
    );
  }
}

class Letter {
  final String senderId;
  final String recipientId;
  final List<LetterContent> message;
  final DateTime createdAt;
  final DateTime deliveredAt;

  Letter({
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.createdAt,
    required this.deliveredAt,
  });
}
