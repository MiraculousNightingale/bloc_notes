import 'package:bloc_notes/ui/screens/note_list_screen.dart';
import 'package:flutter/material.dart';

class NoteFormScreen extends StatelessWidget {
  static const subPath = 'form';
  static const path = '${NoteListScreen.path}/$subPath';

  final bool isCreateMode;

  const NoteFormScreen({
    super.key,
    required this.isCreateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isCreateMode ? 'Create' : 'Update'} Note'),
      ),
    );
  }
}
