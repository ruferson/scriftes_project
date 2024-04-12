import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:skriftes_project/src/palette/color_repository.dart';
import 'package:skriftes_project/src/settings/settings_controller.dart';

Future<String> getJson() async {
  return rootBundle.loadString('assets/json/carta.json');
}

class LetterItem {
  final String text;
  final Map<String, dynamic> styles;

  LetterItem({required this.text, required this.styles});

  factory LetterItem.fromJson(Map<String, dynamic> json) {
    return LetterItem(
      text: json['text'],
      styles: json['styles'],
    );
  }
}

/// Displays a list of SampleItems.
class LetterView extends StatefulWidget {
  const LetterView({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  static const routeName = '/';

  @override
  State<LetterView> createState() => _LetterViewState();
}

class _LetterViewState extends State<LetterView> {
  final Future<String> _calculation = getJson();

  @override
  Widget build(BuildContext context) {
    getJson();
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
              return FutureBuilder<String>(
                  future: _calculation,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      String textData = snapshot.data!;
                      List<Map<String, dynamic>> parsedJson =
                          jsonDecode(textData)
                              .map((jsonString) => jsonDecode(jsonString)
                                  as Map<String, dynamic>)
                              .cast<Map<String, dynamic>>()
                              .toList();

                      List<LetterItem> fragmentList = parsedJson
                          .map((json) => LetterItem.fromJson(json))
                          .toList();

                      List<Widget> textWidgets = fragmentList.map((item) {
                        // Parse the styles from the item
                        TextStyle textStyle = TextStyle(
                          fontSize: item.styles['fontSize'] ?? 14.0,
                          fontFamily: 'Arial', // Vintage font
                          color: ColorRepository.getColor(ColorName.textColor,
                              widget.controller.themeMode), // Dark brown color
                          letterSpacing: 1.0,
                          // Add more style properties as needed
                        );

                        return Column(
                          children: [
                            const SizedBox(
                                height: 10), // Adjust height as needed
                            Text(
                              item.text,
                              style: textStyle,
                            ),
                          ],
                        );
                      }).toList();

                      /* List<LetterItem> listaFragmentos = listaFragmentosJson
                      .map((fragmentoJson) =>
                          LetterItem.fromJson(fragmentoJson))
                      .toList(); */

                      return SingleChildScrollView(
                        child: Container(
                          color: ColorRepository.getColor(
                              ColorName.primaryColor,
                              widget.controller.themeMode),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Letter(
                                textWidgets: textWidgets,
                                controller: widget.controller),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                              color: ColorRepository.getColor(
                                  ColorName.specialColor,
                                  widget.controller.themeMode)));
                    }
                  });
            }));
  }
}

class Letter extends StatefulWidget {
  const Letter({
    super.key,
    required this.textWidgets,
    required this.controller,
  });

  final SettingsController controller;
  final List<Widget> textWidgets;

  @override
  State<Letter> createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.controller,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              color: ColorRepository.getColor(ColorName.white,
                  widget.controller.themeMode), // Creamy background color
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(50, 0, 0, 0), // Soft shadow
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(
                24.0), // Increased padding for vintage look
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.textWidgets,
            ),
          );
        });
  }
}
