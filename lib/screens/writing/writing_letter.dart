import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/services/firebase_service.dart';
import 'package:skriftes_project_2/services/models/letter.dart';
import 'package:skriftes_project_2/services/models/user.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';

Future<String> getFalseFutureString() async {
  await Future.delayed(Duration.zero);
  return "value";
}

/// The WritingLetterView widget displays a letter writing interface.
class WritingLetterView extends StatefulWidget {
  const WritingLetterView({
    super.key,
    required this.controller,
    required this.title,
    required this.recipientData,
  });

  final SettingsController controller;
  final String title;
  final UserData recipientData;

  static const routeName = '/';

  @override
  State<WritingLetterView> createState() => _WritingLetterViewState();
}

class _WritingLetterViewState extends State<WritingLetterView> {
  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kTextTabBarHeight;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(toolbarHeight),
        child: ScriftesScreenBar(
          toolbarHeight: toolbarHeight,
          controller: widget.controller,
          title: widget.title,
        ),
      ),
      backgroundColor: ColorRepository.getColor(
          ColorName.primaryColor, widget.controller.themeMode),
      body: WritingAreaContent(
          widget: widget, recipientData: widget.recipientData),
    );
  }
}

class WritingAreaContent extends StatefulWidget {
  const WritingAreaContent({
    super.key,
    required this.widget,
    required this.recipientData,
  });

  final WritingLetterView widget;
  final UserData recipientData;

  @override
  _WritingAreaContentState createState() => _WritingAreaContentState();
}

class _WritingAreaContentState extends State<WritingAreaContent> {
  late QuillController _controller;

  /// Converts the Quill document into a list of LetterContent.
  List<LetterContent> _convertToLetterContent() {
    final List<LetterContent> letterContentList = [];

    final doc = _controller.document;
    final delta = doc.toDelta();

    for (var change in delta.toList()) {
      final String text = change.data as String? ?? ''; // Cast to String
      final Map<String, dynamic> styles = {};

      if (change.attributes != null) {
        styles.addAll(change.attributes!); // Add styles to map
      }

      if (text.isNotEmpty) {
        letterContentList.add(LetterContent(
            text: text,
            styles: styles)); // Add text and styles as LetterContent
      }
    }

    return letterContentList;
  }

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.widget.controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(
              top: 20.0, bottom: 40.0, left: 20.0, right: 20.0),
          decoration: BoxDecoration(
            color: ColorRepository.getColor(
                ColorName.white, widget.widget.controller.themeMode),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(50, 0, 0, 0),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: _controller,
                configurations: const QuillSimpleToolbarConfigurations(
                  showDividers: false,
                  showFontFamily: false,
                  showFontSize: false,
                  showBoldButton: true,
                  showItalicButton: true,
                  showSmallButton: false,
                  showUnderLineButton: true,
                  showLineHeightButton: false,
                  showStrikeThrough: false,
                  showInlineCode: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showClearFormat: false,
                  showAlignmentButtons: false,
                  showLeftAlignment: false,
                  showCenterAlignment: false,
                  showRightAlignment: false,
                  showJustifyAlignment: false,
                  showHeaderStyle: true,
                  showListNumbers: false,
                  showListBullets: false,
                  showListCheck: false,
                  showCodeBlock: false,
                  showQuote: false,
                  showIndent: false,
                  showLink: false,
                  showUndo: false,
                  showRedo: false,
                  showDirection: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showClipboardCut: false,
                  showClipboardCopy: false,
                  showClipboardPaste: false,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: QuillEditor.basic(
                  controller: _controller,
                  configurations: const QuillEditorConfigurations(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: ColorRepository.getColor(
                      ColorName.primaryColor,
                      widget.widget.controller.themeMode),
                  overlayColor: ColorRepository.getColor(
                      ColorName.secondaryTextColor,
                      widget.widget.controller.themeMode),
                  foregroundColor: ColorRepository.getColor(
                      ColorName.textColor, widget.widget.controller.themeMode),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: ColorRepository.getColor(
                            ColorName.white,
                            widget.widget.controller.themeMode),
                        shadowColor: ColorRepository.getColor(
                            ColorName.primaryColor,
                            widget.widget.controller.themeMode),
                        title: const Text("Confirmar envío"),
                        content: Text(
                          "¿Estás seguro de que quieres enviar la carta?",
                          style: TextStyle(
                            color: ColorRepository.getColor(ColorName.textColor,
                                widget.widget.controller.themeMode),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(), // Cancel
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                color: ColorRepository.getColor(
                                    ColorName.specialColor,
                                    widget.widget.controller.themeMode),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final String content =
                                  _controller.document.toPlainText();
                              final List<LetterContent> letterContent =
                                  _convertToLetterContent();

                              String recipientId = widget.recipientData
                                  .id; // Ensure you obtain this ID

                              try {
                                await FirebaseService()
                                    .sendLetter(recipientId, letterContent);
                                // Success message or redirect user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "¡Carta enviada correctamente!")),
                                );
                              } catch (e) {
                                // Error handling if something goes wrong
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error al enviar la carta: $e")),
                                );
                              }

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Enviar",
                              style: TextStyle(
                                color: ColorRepository.getColor(
                                    ColorName.specialColor,
                                    widget.widget.controller.themeMode),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Enviar carta"),
              ),
            ],
          ),
        );
      },
    );
  }
}
