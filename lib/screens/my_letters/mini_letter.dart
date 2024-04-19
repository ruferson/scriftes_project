import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:skriftes_project/screens/my_letters/read_letter_view.dart';
import 'package:skriftes_project/services/models/letter.dart';
import 'package:skriftes_project/themes/color_repository.dart';
import 'package:skriftes_project/screens/settings/settings_controller.dart';

Future<String> getJson() async {
  return rootBundle.loadString('assets/json/carta.json');
}

/// Displays a list of SampleItems.
class MiniLetterContainer extends StatefulWidget {
  const MiniLetterContainer({
    super.key,
    required this.controller,
    required this.received,
    required this.letter,
  });

  final SettingsController controller;
  final bool received;
  final Letter letter;

  static const routeName = '/';

  @override
  State<MiniLetterContainer> createState() => _MiniLetterContainerState();
}

class _MiniLetterContainerState extends State<MiniLetterContainer> {
  void onPressed(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReadLettersView(received: widget.received, controller: widget.controller, letter: widget.letter)));
  
    /* FirebaseService().sendLetter("4JH4QnicznNPGQNvaPK4WxY1iLB2", [
      LetterContent(
          text: "Estimado Joseeeeee",
          styles: textStyleToMap(const TextStyle(fontSize: 18.0))),
      LetterContent(
          text: "Soy Ruben, es un placer escribirte.",
          styles: textStyleToMap(const TextStyle(fontSize: 14.0))),
      LetterContent(
          text: "Estoy probando a escribir una carta.",
          styles: textStyleToMap(const TextStyle(fontSize: 14.0))),
      LetterContent(
          text: "Un saludo, Ruben.",
          styles: textStyleToMap(const TextStyle(fontSize: 14.0))),
    ]); */
  }

  @override
  Widget build(BuildContext context) {
    getJson();
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return Stack(children: [
          Container(
            margin: const EdgeInsets.all(18),
            child: MiniLetterWidget(
              controller: widget.controller,
              onPressed: onPressed,
              letter: widget.letter,
            ),
          ),
          Positioned(
            top: 24,
            right: 22,
            child: IgnorePointer(
              ignoring: true,
              child: Icon(
                Icons.open_in_full,
                color: ColorRepository.getColor(
                    ColorName.specialColor, widget.controller.themeMode),
              ),
            ),
          ),
        ]);
      },
    );
  }
}

class MiniLetterWidget extends StatefulWidget {
  const MiniLetterWidget({
    Key? key,
    required this.controller,
    required this.onPressed,
    required this.letter,
  }) : super(key: key);

  final SettingsController controller;
  final void Function(BuildContext) onPressed;
  final Letter letter;

  @override
  State<MiniLetterWidget> createState() => _MiniLetterState();
}

class _MiniLetterState extends State<MiniLetterWidget> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: () => widget.onPressed(context),
          child: Container(
            height: 80,
            width: 160,
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
            child: Text(
              "Para " + widget.letter.recipientName,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
        );
      },
    );
  }
}
