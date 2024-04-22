import 'package:flutter/material.dart';
import 'package:skriftes_project/screens/settings/settings_controller.dart';
import 'package:skriftes_project/services/models/letter.dart';
import 'package:skriftes_project/themes/color_repository.dart';

Future<String> getFalseFutureString() async {
  await Future.delayed(Duration.zero);
  return "value";
}

/// Displays a list of SampleItems.
class ReadLettersView extends StatefulWidget {
  const ReadLettersView({
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
  State<ReadLettersView> createState() => _ReadLetterViewState();
}

class _ReadLetterViewState extends State<ReadLettersView> {
  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight;
    List<Widget> textWidgets = widget.letter.message.map((item) {
      TextStyle textStyle = TextStyle(
        fontSize: item.styles != null ? item.styles!['fontSize'] ?? 14.0 : 14.0,
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

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(toolbarHeight),
          child: ScriftesScreenBar(
              toolbarHeight: toolbarHeight, controller: widget.controller),
        ),
        body: ReadLetterContent(widget: widget, textWidgets: textWidgets));
  }
}

class ReadLetterContent extends StatelessWidget {
  const ReadLetterContent({
    super.key,
    required this.widget,
    required this.textWidgets,
  });

  final ReadLettersView widget;
  final List<Widget> textWidgets;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(18),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: textWidgets,
            ),
          ),
        );
      },
    );
  }
}

class ScriftesScreenBar extends StatelessWidget {
  const ScriftesScreenBar({
    super.key,
    required this.toolbarHeight,
    required this.controller,
  });

  final double toolbarHeight;
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromARGB(41, 0, 0, 0),
          offset: Offset(0, 2.0),
          blurRadius: 4.0,
        )
      ]),
      child: AppBar(
        centerTitle: true,
        toolbarHeight: toolbarHeight,
        backgroundColor: ColorRepository.getColor(
            ColorName.primaryColor, controller.themeMode),
        title: Image.asset(
          controller.themeMode == ThemeMode.light
              ? 'assets/images/logo.png'
              : controller.themeMode == ThemeMode.dark
                  ? 'assets/images/dark_logo.png'
                  : 'assets/images/logo.png',
          width: 180,
          semanticLabel: 'Scrifte\'s logo',
        ),
      ),
    );
  }
}
