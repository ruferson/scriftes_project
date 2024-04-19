import 'package:flutter/material.dart';
import 'package:skriftes_project/screens/settings/settings_controller.dart';
import 'package:skriftes_project/services/models/letter.dart';
import 'package:skriftes_project/themes/color_repository.dart';

Future<String> getFalseFutureString() async {
  await Future.delayed(Duration.zero);
  return "value";
}

/// Displays a list of SampleItems.
class WritingView extends StatefulWidget {
  const WritingView({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  static const routeName = '/';

  @override
  State<WritingView> createState() => _WritingViewState();
}

class _WritingViewState extends State<WritingView> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    Widget stepWidget = ReadLetterContent(widget: widget);
    String dropdownValue = list.first;

    switch (step) {
      case 0:
        stepWidget = Container(
            alignment: Alignment.center,
            color: ColorRepository.getColor(
                ColorName.primaryColor, widget.controller.themeMode),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Elige un amigo:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorRepository.getColor(
                        ColorName.textColor, widget.controller.themeMode),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                DropdownMenu<String>(
                  initialSelection: list.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  menuStyle: MenuStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        ColorRepository.getColor(ColorName.primaryColor,
                            widget.controller.themeMode)),
                  ),
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ));
        break;
      case 1:
        stepWidget = ReadLetterContent(widget: widget);
        break;
      default:
        stepWidget = ReadLetterContent(widget: widget);
        break;
    }

    return Container(
      color: ColorRepository.getColor(
          ColorName.primaryColor, widget.controller.themeMode),
      child: stepWidget,
    );
  }
}

class ReadLetterContent extends StatelessWidget {
  const ReadLetterContent({
    super.key,
    required this.widget,
  });

  final WritingView widget;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(height: 20)],
            ),
          ),
        );
      },
    );
  }
}
