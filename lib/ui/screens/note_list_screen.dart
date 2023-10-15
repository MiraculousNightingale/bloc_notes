import 'package:bloc_notes/main.dart';
import 'package:bloc_notes/ui/screens/note_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/note.dart';
import '../widgets/note_list_item.dart';

class NoteListScreen extends StatelessWidget {
  static const path = '/notes';
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes with BLoC'),
        actions: [
          IconButton(
            onPressed: () {
              context.go(NoteFormScreen.path);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: kDummyNotes.length,
        itemBuilder: (context, index) {
          final note = kDummyNotes[index];
          return NoteListItem(note: note);
        },
      ),
    );
  }
}
