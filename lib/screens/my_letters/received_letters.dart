
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skriftes_project/screens/my_letters/mini_letter.dart';
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
    return Scaffold(
        body: ListenableBuilder(
            listenable: widget.controller,
            builder: (BuildContext context, Widget? child) {
              return FutureBuilder<List<Letter>>(
                  future: _firebaseService.getReceivedLetters(_userId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Letter>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ReveivedLettersLoading(widget: widget);
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return ReceivedLettersError(widget: widget, snapshot: snapshot);
                    } else {
                      final letters = snapshot.data;
                      if (letters != null && letters.isNotEmpty) {
                        return ReceivedLettersList(
                            widget: widget, letters: letters);
                      } else {
                        return ReceivedLettersEmpty(widget: widget);
                      }
                    }
                  });
            }));
  }
}

class ReceivedLettersEmpty extends StatelessWidget {
  const ReceivedLettersEmpty({
    super.key,
    required this.widget,
  });

  final ReceivedLettersView widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: ColorRepository.getColor(
            ColorName.primaryColor,
            widget.controller.themeMode),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Image.asset(
                "assets/images/detailed_house.png",
                width:
                    MediaQuery.of(context).size.width * 0.8,
                semanticLabel: 'House',
              ),
              const SizedBox(height: 48),
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
          ),
        ));
  }
}

class ReceivedLettersList extends StatelessWidget {
  const ReceivedLettersList({
    super.key,
    required this.widget,
    required this.letters,
  });

  final ReceivedLettersView widget;
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
                return MiniLetterContainer(
                  received: true,
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

class ReceivedLettersError extends StatelessWidget {
  const ReceivedLettersError({
    super.key,
    required this.widget,
    required this.snapshot,
  });

  final ReceivedLettersView widget;
  final AsyncSnapshot<List<Letter>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: ColorRepository.getColor(
          ColorName.primaryColor, widget.controller.themeMode),
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
  }
}

class ReveivedLettersLoading extends StatelessWidget {
  const ReveivedLettersLoading({
    super.key,
    required this.widget,
  });

  final ReceivedLettersView widget;

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
