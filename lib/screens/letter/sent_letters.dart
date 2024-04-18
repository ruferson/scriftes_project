import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:skriftes_project/screens/letter/letter_container.dart';
import 'package:skriftes_project/services/firebase_service.dart';
import 'package:skriftes_project/services/models/letter.dart';
import 'package:skriftes_project/themes/color_repository.dart';
import 'package:skriftes_project/screens/settings/settings_controller.dart';

Future<String> getFalseFutureString() async {
  await Future.delayed(Duration.zero);
  return "value";
}

/// Displays a list of SampleItems.
class SentLettersView extends StatefulWidget {
  const SentLettersView({
    super.key,
    required this.controller,
  });

  final SettingsController controller;
  Future<String> getFalseFutureString() async {
    await Future.delayed(Duration.zero);
    return "value";
  }

  static const routeName = '/';

  @override
  State<SentLettersView> createState() => _SentLettersViewState();
}

class _SentLettersViewState extends State<SentLettersView> {
  final FirebaseService _firebaseService = FirebaseService();
  late String _userId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _userId = currentUser.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListenableBuilder(
            listenable: widget.controller,
            builder: (BuildContext context, Widget? child) {
              return FutureBuilder<List<Letter>>(
                  future: _firebaseService.getSentLetters(_userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return MyLettersLoading(widget: widget);
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final letters = snapshot.data;
                      if (letters != null && letters.isNotEmpty) {
                        return MyLettersList(widget: widget, letters: letters);
                      } else {
                        return MyLettersEmpty(widget: widget);
                      }
                    }
                  });
            }));
  }
}

class MyLettersLoading extends StatelessWidget {
  const MyLettersLoading({
    super.key,
    required this.widget,
  });

  final SentLettersView widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: ColorRepository.getColor(
          ColorName.primaryColor, widget.controller.themeMode),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: CircularProgressIndicator(
          color: ColorRepository.getColor(
              ColorName.specialColor, widget.controller.themeMode),
        ),
      ),
    );
  }
}

class MyLettersEmpty extends StatelessWidget {
  const MyLettersEmpty({
    super.key,
    required this.widget,
  });

  final SentLettersView widget;

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "assets/images/detailed_house.png",
      "assets/images/undraw_friendship_mni7.png",
      "assets/images/undraw_friends_r511_1.png",
      "assets/images/undraw_taken_re_yn20_1.png",
    ];

    String selectRandomImage() {
      Random random = Random();
      double randomNumber = random.nextDouble() * 100;

      if (randomNumber < 90) {
        return images[0];
      } else if (randomNumber < 95) {
        return images[1];
      } else if (randomNumber < 98) {
        return images[2];
      } else {
        return images[3];
      }
    }

    return Container(
        alignment: Alignment.center,
        color: ColorRepository.getColor(
            ColorName.primaryColor, widget.controller.themeMode),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                selectRandomImage(),
                width: MediaQuery.of(context).size.width * 0.8,
                semanticLabel: 'House',
              ),
              const SizedBox(height: 36),
              Text(
                "Por ahora no has enviado nada...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ColorRepository.getColor(ColorName.secondaryTextColor,
                      widget.controller.themeMode),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ));
  }
}

class MyLettersList extends StatelessWidget {
  const MyLettersList({
    super.key,
    required this.widget,
    required this.letters,
  });

  final SentLettersView widget;
  final List<Letter> letters;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: ColorRepository.getColor(
          ColorName.primaryColor, widget.controller.themeMode),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            children: [
              Wrap(
                  children: letters.map((letter) {
                return LetterContainer(
                  received: false,
                  controller: widget.controller,
                  letter: letter,
                  // Puedes pasar otras propiedades de la carta al LetterContainer si es necesario
                );
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
