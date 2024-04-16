import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:skriftes_project/themes/color_repository.dart';
import 'package:skriftes_project/screens/settings/settings_controller.dart';

/// Displays a list of SampleItems.
class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  static const routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

Future<String> getFalseFutureString() async {
  await Future.delayed(Duration.zero);
  return "value";
}

class _HomeViewState extends State<HomeView> {
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
                        color: ColorRepository.getColor(ColorName.primaryColor,
                            widget.controller.themeMode),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              selectRandomImage(),
                              width: MediaQuery.of(context).size.width * 0.8,
                              semanticLabel: 'House',
                            ),
                            const SizedBox(height: 48),
                            Text(
                              "¡Hace un día estupendo!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: ColorRepository.getColor(
                                    ColorName.textColor,
                                    widget.controller.themeMode),
                              ),
                            ),
                            Text(
                              "¿Llegará alguna carta hoy...?",
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
                  });
            }));
  }
}
