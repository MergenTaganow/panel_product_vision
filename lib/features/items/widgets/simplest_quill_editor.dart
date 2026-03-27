import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:markdown_quill/markdown_quill.dart';

import 'package:markdown/markdown.dart' as md;

import '../../../config/colors.dart';

class SimplestQuillEditor extends StatelessWidget {
  const SimplestQuillEditor({
    super.key,
    required this.descriptionCont,
    required this.textFieldHeight,
    this.borderColor,
  });

  final QuillController descriptionCont;
  final double textFieldHeight;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: textFieldHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Col.gray50),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            color: Col.white,
          ),
          child: QuillEditor.basic(
            config: QuillEditorConfig(
              showCursor: true,
              onTapOutsideEnabled: true,
              autoFocus: false,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              customStyles: DefaultStyles(
                lists: defaultListBlockStyle,
                paragraph: DefaultTextBlockStyle(
                  TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  const HorizontalSpacing(4, 4),
                  const VerticalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  null,
                ),
              ),
            ),
            controller: descriptionCont,
          ),
        ),
        ClipRRect(
          // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: borderColor ?? Col.gray50),
                left: BorderSide(color: borderColor ?? Col.gray50),
                bottom: BorderSide(color: borderColor ?? Col.gray50),
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
              color: Col.white,
            ),
            child: QuillSimpleToolbar(
              // key: _key,
              config: QuillSimpleToolbarConfig(
                multiRowsDisplay: false,
                showAlignmentButtons: false,
                showInlineCode: false,
                showQuote: false,
                showIndent: false,
                showClearFormat: false,
                showUndo: false,
                showRedo: false,
                showHeaderStyle: false,
                showCodeBlock: false,
                showDirection: false,
                showSearchButton: false,
                showFontFamily: false,
                showFontSize: false,
                showSubscript: false,
                showSuperscript: false,
                showBackgroundColorButton: false,
                showClipboardCopy: false,
                showClipboardCut: false,
                showClipboardPaste: false,
                showDividers: false,
                showColorButton: false,
                showUnderLineButton: false,

                // Optional styling
                toolbarIconAlignment: WrapAlignment.start,
                toolbarSectionSpacing: 4,
                // ✅ Keep these
                showListBullets: true,
                showLink: true,
                showStrikeThrough: true,
                showListNumbers: true,
                showBoldButton: true,
                showItalicButton: true,
                toolbarSize: 40,
                decoration: const BoxDecoration(color: Col.white),
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarColorButtonOptions(
                    iconTheme: QuillIconTheme(
                      iconButtonSelectedData: IconButtonData(
                        color: Colors.blue,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.surfaceBright, // selected background
                          ),
                        ),
                      ),
                      iconButtonUnselectedData: IconButtonData(
                        color: Col.black,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.transparent, // unselected background
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              controller: descriptionCont,
            ),
          ),
        ),
      ],
    );
  }
}

String getMarkDown(QuillController controller) {
  try {
    final delta = controller.document.toDelta();

    final converter = DeltaToMarkdown(
      visitLineHandleNewLine: (style, sink) {
        sink.write('\n');
      },
      customEmbedHandlers: {
        'mention': (embed, sink) {
          dynamic value = embed.value;

          Map<String, dynamic>? mentionMap;

          // Case 1: embed.value is a Map containing 'mention'
          if (value is Map && value.containsKey('mention')) {
            mentionMap = value['mention'] as Map<String, dynamic>;
          } else {
            // Case 2: fallback, encode & decode to Map
            final decoded = jsonDecode(jsonEncode(value));
            if (decoded is Map && decoded.containsKey('mention')) {
              mentionMap = decoded['mention'] as Map<String, dynamic>;
            }
          }

          if (mentionMap != null) {
            // write exactly [mention]{…inner map…}
            sink.write('[mention][${jsonEncode(mentionMap)}]');
          } else {
            // fallback: write whatever is in value
            sink.write('[mention][${jsonEncode(value)}]');
          }
        },
      },
    );

    var markdown = converter.convert(delta);

    return markdown;
  } catch (e) {
    return controller.getPlainText();
  }
}

String getMarkdownPlainText(String markdownText) {
  if (markdownText.trim().isEmpty) return '';
  final delta = MarkdownToDelta(
    markdownDocument: md.Document(
      encodeHtml: false,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      blockSyntaxes: [const EmbeddableTableSyntax()],
    ),
  ).convert(markdownText);
  final doc = Document.fromDelta(delta);
  return doc.toPlainText();
}

List<Map<String, dynamic>> restoreNewlines(String markdown, List<Map<String, dynamic>> delta) {
  final matches = RegExp(r'\n+').allMatches(markdown).toList();
  if (matches.isEmpty) return delta;

  int opIndex = 0;
  final result = <Map<String, dynamic>>[];

  for (final op in delta) {
    final insert = op['insert'];
    final attributes = op['attributes']; // preserve inline or block attributes

    if (insert is String && insert.contains('\n')) {
      final parts = insert.split('\n');
      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];
        if (part.isNotEmpty) {
          final textOp = <String, dynamic>{'insert': part};
          // only keep inline attrs (bold, italic, code, etc.)
          if (attributes != null && !_isBlockAttribute(attributes)) {
            textOp['attributes'] = attributes;
          }
          result.add(textOp);
        }

        // Add newline(s)
        if (i < parts.length - 1) {
          final newlineOp = <String, dynamic>{'insert': '\n'};

          // preserve block-level attributes (list, header, etc.)
          if (attributes != null && _isBlockAttribute(attributes)) {
            newlineOp['attributes'] = attributes;
          }

          result.add(newlineOp);

          // If markdown had multiple consecutive newlines, add extras
          if (opIndex < matches.length) {
            final match = matches[opIndex];
            final extraCount = match.group(0)!.length - 1;
            for (int j = 0; j < extraCount; j++) {
              result.add({'insert': '\n'});
            }
          }
          opIndex++;
        }
      }
    } else {
      // Non-string or no newline → keep original op intact
      result.add(op);
    }
  }

  return result;
}

/// Helper: checks whether an attribute map has block-level attributes
bool _isBlockAttribute(Map<String, dynamic> attrs) {
  const blockKeys = ['list', 'header', 'blockquote', 'code-block', 'align'];
  return attrs.keys.any(blockKeys.contains);
}

Delta convertMarkdownToDelta(String markdown) {
  // 🔍 Check if the input is already a delta JSON string (old format)
  if (_isDeltaString(markdown)) {
    try {
      final decoded = jsonDecode(markdown);

      // Case 1: {"ops": [...]}
      if (decoded is Map && decoded.containsKey('ops')) {
        return Delta.fromJson(decoded['ops']);
      }

      // Case 2: [{"insert": "..."}] (direct ops array)
      if (decoded is List) {
        return Delta.fromJson(decoded);
      }
    } catch (e) {
      // Fall through to markdown parsing
    }
  }

  markdown = _forceLineBreaks(markdown);

  // 1️⃣ Convert markdown to delta
  final delta = MarkdownToDelta(
    markdownDocument: md.Document(
      encodeHtml: false,
      extensionSet: md.ExtensionSet.gitHubFlavored,
    ),
  ).convert(markdown);

  // 2️⃣ Convert to JSON list
  final json = delta.toJson().cast<Map<String, dynamic>>();
  final result = <Map<String, dynamic>>[];

  for (final op in json) {
    final insert = op['insert'];
    final attributes = op['attributes']; // <-- preserve this

    if (insert is String) {
      int lastIndex = 0;
      final matches = mentionRegex.allMatches(insert);

      if (matches.isEmpty) {
        // No mention → keep the whole op (with attributes)
        result.add({
          'insert': insert,
          if (attributes != null) 'attributes': attributes,
        });
        continue;
      }

      for (final m in matches) {
        // text before mention
        if (m.start > lastIndex) {
          final before = insert.substring(lastIndex, m.start);
          result.add({
            'insert': before,
            if (attributes != null) 'attributes': attributes,
          });
        }

        // mention itself
        final mentionJson = m.group(1)!;
        try {
          final mentionMap = jsonDecode(mentionJson);
          result.add({
            'insert': {'mention': mentionMap}
          });
        } catch (_) {
          // fallback to text
          result.add({
            'insert': m.group(0),
            if (attributes != null) 'attributes': attributes,
          });
        }

        lastIndex = m.end;
      }

      // text after last mention
      if (lastIndex < insert.length) {
        result.add({
          'insert': insert.substring(lastIndex),
          if (attributes != null) 'attributes': attributes,
        });
      }
    } else {
      // embed (image, etc.) → keep as-is
      result.add(op);
    }
  }

  // 3️⃣ Restore original markdown newlines (attributes preserved there too)
  final restoredJson = restoreNewlines(markdown, result);

  // 4️⃣ Convert back to Delta
  return Delta.fromJson(restoredJson);
}

String _forceLineBreaks(String md) {
  return md.replaceAllMapped(
    RegExp(r'([^\n])\n([^\n])'),
    (m) => '${m[1]}  \n${m[2]}',
  );
}

/// Helper function to detect if a string is a delta JSON string
bool _isDeltaString(String text) {
  if (text.isEmpty) return false;

  // Trim whitespace
  final trimmed = text.trim();

  // Check if it starts with { or [ (JSON format)
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) {
    return false;
  }

  // Check if it contains "ops" or "insert" keywords typical of delta format
  // Delta strings typically have: {"ops":[...]} or [{"insert":"..."}]
  return trimmed.contains('"ops"') || (trimmed.startsWith('[') && trimmed.contains('"insert"'));
}

final mentionRegex = RegExp(r'\[mention\]\{(.+?)\}');

class CheckBoxQuillBuilderTest extends QuillCheckboxBuilder {
  @override
  Widget build(
      {required BuildContext context,
      required bool isChecked,
      required ValueChanged<bool> onChanged}) {
    return Align(
      alignment: Alignment.topCenter, // top alignment like flex-start
      child: SizedBox(
        width: 20, // similar to CSS width: 20px
        height: 20,
        child: Checkbox(
          value: isChecked,
          onChanged: (c) {
            if (c != null) {
              onChanged(c);
            }
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

final defaultListBlockStyle = DefaultListBlockStyle(
  const TextStyle(fontSize: 14), // You can customize text style here if needed
  const HorizontalSpacing(0, 0), // Adjust vertical spacing
  const VerticalSpacing(0, 0),
  const VerticalSpacing(0, 0),
  null, // No decoration
  CheckBoxQuillBuilderTest(),
);

Widget topAlignedCheckboxBuilder(
  BuildContext context,
  bool isChecked,
  bool readOnly,
  void Function(bool?) onChanged,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start, // <-- FIX HERE
    children: [
      Checkbox(
        value: isChecked,
        onChanged: onChanged,
      ),
    ],
  );
}

class OnlyQuillEditor extends StatelessWidget {
  final QuillController descriptionCont;
  const OnlyQuillEditor(this.descriptionCont, {super.key});

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      config: QuillEditorConfig(
        showCursor: false,
        padding: const EdgeInsets.symmetric(vertical: 4),
        customStyles: DefaultStyles(
          lists: defaultListBlockStyle,
          paragraph: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 14,
              height: 1.4,
              // color: Theme.of(context).textTheme.bodyMedium?.color,
              color: Colors.black,
            ),
            const HorizontalSpacing(4, 4),
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
        ),
      ),
      controller: descriptionCont,
    );
  }
}
