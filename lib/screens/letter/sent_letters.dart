import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:skriftes_project/screens/letter/letter_container.dart';
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
  @override
  Widget build(BuildContext context) {
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
                  future: getFalseFutureString(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      color: ColorRepository.getColor(
                          ColorName.primaryColor, widget.controller.themeMode),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Wrap(
                                children: [
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                  LetterContainer(
                                      controller: widget.controller),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
