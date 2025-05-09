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

/// Displays the main writing interface for a letter.
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
        widget: widget,
        recipientData: widget.recipientData,
      ),
    );
  }
}

/// Displays the writing area where the user can compose a letter.
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

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  /// Converts the Quill editor content into a structured list of LetterContent objects.
  List<LetterContent> _convertToLetterContent() {
    final List<LetterContent> letterContentList = [];
    final deltaList = _controller.document.toDelta().toList();
    List<Map<String, dynamic>> currentLine = [];

    for (var op in deltaList) {
      if (op.key == 'insert') {
        final String? text = op.value;
        final Map<String, dynamic> styleMap = op.attributes != null
            ? Map<String, dynamic>.from(op.attributes!)
            : {};

        // Translate header levels into font size styles
        if (styleMap.containsKey('header')) {
          final headerLevel = styleMap['header'];
          for (var styleChange in currentLine) {
            styleChange['styles']['bold'] = true;
            switch (headerLevel) {
              case 1:
                styleChange['styles']['fontSize'] = 'huge';
                break;
              case 2:
                styleChange['styles']['fontSize'] = 'x-large';
                break;
              case 3:
                styleChange['styles']['fontSize'] = 'large';
                break;
            }
          }
        }

        if (text != null) {
          final parts = text.split('\n');
          for (int i = 0; i < parts.length; i++) {
            final part = parts[i];
            if (part.isNotEmpty) {
              currentLine.add({
                'text': part,
                'styles': styleMap,
              });
            }

            // When encountering a newline, close the current line
            if (i < parts.length - 1) {
              letterContentList.add(
                LetterContent(
                  text: '',
                  styles: {'line': currentLine},
                ),
              );
              currentLine = [];
            }
          }
        }
      }
    }

    // Add remaining content if the document does not end with a newline
    if (currentLine.isNotEmpty) {
      letterContentList.add(
        LetterContent(
          text: '',
          styles: {'line': currentLine},
        ),
      );
    }

    return letterContentList;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.widget.controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                  // Show confirmation dialog before sending letter
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmar envío"),
                        content: Text(
                          "¿Estás seguro de que quieres enviar la carta?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(), // Cancel
                            child: Text(
                              "Cancelar",
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final List<LetterContent> letterContent =
                                  _convertToLetterContent();

                              final recipientId = widget.recipientData.id;

                              try {
                                await FirebaseService()
                                    .sendLetter(recipientId, letterContent);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("¡Carta enviada correctamente!"),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Error al enviar la carta: $e"),
                                  ),
                                );
                              }

                              Navigator.of(context).pop(); // Close dialog
                              Navigator.of(context).pop(); // Go back
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
