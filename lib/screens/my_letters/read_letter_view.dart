import 'package:flutter/material.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/services/models/letter.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

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
  double _getFontSize(dynamic sizeValue) {
    if (sizeValue == null) return 16.0;

    if (sizeValue is num) return sizeValue.toDouble();

    if (sizeValue is String) {
      switch (sizeValue) {
        case 'large':
          return 22.0;
        case 'x-large':
          return 26.0;
        case 'huge':
          return 30.0;
        default:
          return 16.0;
      }
    }

    return 16.0;
  }

  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kTextTabBarHeight;
    print(widget.letter.message.toString());

    List<Widget> textWidgets = [];

    for (var line in widget.letter.message) {
      List<InlineSpan> spans = [];

      final fragments = line.styles?['line'] ?? [];

      for (var frag in fragments) {
        final String text = frag['text'] ?? '';
        final Map<String, dynamic> styles =
            Map<String, dynamic>.from(frag['styles'] ?? {});

        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            fontSize: _getFontSize(styles['fontSize']),
            fontWeight:
                styles['bold'] == true ? FontWeight.bold : FontWeight.normal,
            fontStyle:
                styles['italic'] == true ? FontStyle.italic : FontStyle.normal,
            decoration: styles['underline'] == true
                ? TextDecoration.underline
                : TextDecoration.none,
            fontFamily: 'Arial',
            color: ColorRepository.getColor(
              ColorName.fullBlack,
              widget.controller.themeMode,
            ),
            letterSpacing: 0.6,
          ),
        ));
      }

      textWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            text: TextSpan(children: spans),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: ScriftesScreenBar(
          toolbarHeight: toolbarHeight,
          controller: widget.controller,
          title: "Carta de ${widget.letter.senderName}",
        ),
      ),
      backgroundColor: ColorRepository.getColor(
        ColorName.primaryColor,
        widget.controller.themeMode,
      ),
      body: ReadLetterContent(widget: widget, textWidgets: textWidgets),
    );
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
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(
              top: 20.0, bottom: 40.0, left: 20.0, right: 20.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: textWidgets,
            ),
          ),
        );
      },
    );
  }
}
