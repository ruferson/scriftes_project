
import 'package:flutter/material.dart';
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
                        alignment: Alignment.center,
                        color: ColorRepository.getColor(ColorName.primaryColor,
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
                                "assets/images/undraw_friendship_mni7.png",
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
                          ),
                        ));
                  });
            }));
  }
}
