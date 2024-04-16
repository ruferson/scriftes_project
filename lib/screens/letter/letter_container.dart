import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:skriftes_project/services/firebase_service.dart';
import 'package:skriftes_project/services/models/letter.dart';
import 'package:skriftes_project/themes/color_repository.dart';
import 'package:skriftes_project/screens/settings/settings_controller.dart';
import 'package:skriftes_project/utils/helpers.dart';

Future<String> getJson() async {
  return rootBundle.loadString('assets/json/carta.json');
}

/// Displays a list of SampleItems.
class LetterContainer extends StatefulWidget {
  const LetterContainer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SettingsController controller;

  static const routeName = '/';

  @override
  State<LetterContainer> createState() => _LetterContainerState();
}

class _LetterContainerState extends State<LetterContainer> {
  final Future<String> _calculation = getJson();
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    getJson();
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return FutureBuilder<String>(
          future: _calculation,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              String textData = snapshot.data!;
              List<Map<String, dynamic>> parsedJson = jsonDecode(textData)
                  .map((jsonString) =>
                      jsonDecode(jsonString) as Map<String, dynamic>)
                  .cast<Map<String, dynamic>>()
                  .toList();

              List<LetterItem> fragmentList =
                  parsedJson.map((json) => LetterItem.fromJson(json)).toList();

              List<Widget> textWidgets = fragmentList.map((item) {
                TextStyle textStyle = TextStyle(
                  fontSize: item.styles != null
                      ? item.styles!['fontSize'] ?? 14.0
                      : 14.0,
                  fontFamily: 'Arial',
                  color: ColorRepository.getColor(
                      ColorName.textColor, widget.controller.themeMode),
                  letterSpacing: 1.0,
                );

                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      item.text,
                      style: textStyle,
                    ),
                  ],
                );
              }).toList();

              return Stack(children: [
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(18),
                    child: Letter(
                      textWidgets: textWidgets,
                      fragmentList: fragmentList,
                      controller: widget.controller,
                      onPressed: onPressed,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () {
                      FirebaseService()
                          .sendLetter("qLh7ol1UjMgiAaCs0q52auxDO672", [
                        LetterItem(
                            text: "Primer texto",
                            styles: textStyleToMap(TextStyle(fontSize: 14.0)))
                      ]);
                    },
                    mini: true,
                    backgroundColor: ColorRepository.getColor(
                        ColorName.specialColor, widget.controller.themeMode),
                    child: Icon(
                      Icons.open_in_full,
                      size: 16,
                      color: ColorRepository.getColor(ColorName.secondaryColor,
                          widget.controller.themeMode),
                    ),
                  ),
                ),
              ]);
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorRepository.getColor(
                      ColorName.specialColor, widget.controller.themeMode),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class Letter extends StatefulWidget {
  const Letter({
    Key? key,
    required this.textWidgets,
    required this.controller,
    required this.fragmentList,
    required this.onPressed,
  }) : super(key: key);

  final SettingsController controller;
  final List<Widget> textWidgets;
  final List<LetterItem> fragmentList;
  final void Function() onPressed;

  @override
  State<Letter> createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            height: 80,
            width: 140,
            decoration: BoxDecoration(
              color: ColorRepository.getColor(
                  ColorName.white, widget.controller.themeMode),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(50, 0, 0, 0),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0),
            child: const Text("De Jose"),
          ),
        );
      },
    );
  }
}
