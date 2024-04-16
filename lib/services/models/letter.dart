import 'package:flutter/widgets.dart';

class LetterItem {
  final String text;
  final Map<String, dynamic>? styles;

  LetterItem({required this.text, required this.styles});

  factory LetterItem.fromJson(Map<String, dynamic> json) {
    return LetterItem(
      text: json['text'],
      styles: json['styles'],
    );
  }
}
