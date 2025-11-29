import 'package:flutter/material.dart';
import 'package:hackathon_2025_app/i18n/strings.g.dart';

/// 保存ダイアログの結果
class SaveKoemyakuResult {
  final String title;
  final String message;

  const SaveKoemyakuResult({
    required this.title,
    required this.message,
  });
}

/// Koemyaku保存ダイアログ
class SaveKoemyakuDialog extends StatefulWidget {
  const SaveKoemyakuDialog({super.key});

  /// ダイアログを表示
  static Future<SaveKoemyakuResult?> show(BuildContext context) {
    return showDialog<SaveKoemyakuResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SaveKoemyakuDialog(),
    );
  }

  @override
  State<SaveKoemyakuDialog> createState() => _SaveKoemyakuDialogState();
}

class _SaveKoemyakuDialogState extends State<SaveKoemyakuDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(SaveKoemyakuResult(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AlertDialog(
      title: Text(t.map.saveKoemyaku),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: t.map.title,
                hintText: t.map.titleHint,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return t.map.titleRequired;
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: t.map.message,
                hintText: t.map.messageHint,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.common.cancel),
        ),
        FilledButton(
          onPressed: _onSave,
          child: Text(t.common.save),
        ),
      ],
    );
  }
}
