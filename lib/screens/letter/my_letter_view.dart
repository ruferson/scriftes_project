import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:skriftes_project/screens/letter/letter_container.dart';
import 'package:skriftes_project/screens/letter/received_letters.dart';
import 'package:skriftes_project/screens/letter/sent_letters.dart';
import 'package:skriftes_project/themes/color_repository.dart';
import 'package:skriftes_project/screens/settings/settings_controller.dart';

Future<String> getFalseFutureString() async {
  await Future.delayed(Duration.zero);
  return "value";
}

/// Displays a list of SampleItems.
class MyLettersView extends StatefulWidget {
  const MyLettersView({
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
  State<MyLettersView> createState() => _MyLettersViewState();
}

class _MyLettersViewState extends State<MyLettersView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: ColorRepository.getColor(
              ColorName.primaryColor, widget.controller.themeMode),
              
        appBar: TabBar(
          labelColor: ColorRepository.getColor(
              ColorName.brownTextColor, widget.controller.themeMode),
          indicatorColor: ColorRepository.getColor(
              ColorName.specialColor, widget.controller.themeMode),
          tabs: const <Widget>[
            Tab(
              iconMargin: EdgeInsets.all(4),
              icon: Icon(Icons.call_received_rounded),
              text: "Recibidas",
            ),
            Tab(
              iconMargin: EdgeInsets.all(4),
              icon: Icon(Icons.send_rounded),
              text: "Enviadas",
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: ReceivedLettersView(controller: widget.controller)),
            Center(child: SentLettersView(controller: widget.controller)),
          ],
        ),
      ),
    );
  }
}
