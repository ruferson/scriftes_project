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
class ReceivedLettersView extends StatefulWidget {
  const ReceivedLettersView({
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
  State<ReceivedLettersView> createState() => _ReceivedLettersViewState();
}

class _ReceivedLettersViewState extends State<ReceivedLettersView> {
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
    List<String> images = [
      "assets/images/detailed_house.png",
      "assets/images/undraw_friendship_mni7.png",
      "assets/images/undraw_friends_r511_1.png",
      "assets/images/undraw_taken_re_yn20_1.png",
    ];

    String selectRandomImage() {
      Random random = Random();
      int randomNumber = random.nextInt(100);

      if (randomNumber < 60) {
        return images[0];
      } else if (randomNumber < 74) {
        return images[1];
      } else if (randomNumber < 88) {
        return images[2];
      } else {
        return images[3];
      }
    }

    return Scaffold(

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: ListenableBuilder(
            listenable: widget.controller,
            builder: (BuildContext context, Widget? child) {
              return FutureBuilder<List<Letter>>(
                  future: _firebaseService.getReceivedLetters(_userId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Letter>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        color: ColorRepository.getColor(ColorName.primaryColor,
                            widget.controller.themeMode),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorRepository.getColor(
                                ColorName.specialColor,
                                widget.controller.themeMode),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        color: ColorRepository.getColor(ColorName.primaryColor,
                            widget.controller.themeMode),
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                  child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ))),
                        ),
                      );
                    } else {
                      final letters = snapshot.data;
                      if (letters != null && letters.isNotEmpty) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          color: ColorRepository.getColor(
                              ColorName.primaryColor,
                              widget.controller.themeMode),
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Column(
                                children: [
                                  Wrap(
                                      children: letters.map((letter) {
                                    return LetterContainer(
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
                      } else {
                        return Container(
                            color: ColorRepository.getColor(
                                ColorName.primaryColor,
                                widget.controller.themeMode),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  selectRandomImage(),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  semanticLabel: 'House',
                                ),
                                const SizedBox(height: 36),
                                Text(
                                  "Por ahora no has recibido nada...",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ColorRepository.getColor(
                                        ColorName.secondaryTextColor,
                                        widget.controller.themeMode),
                                  ),
                                ),
                                const SizedBox(height: 48),
                              ],
                            ));
                      }
                    }
                  });
            }));
  }
}
