import 'package:bloc_notes/main.dart';
import 'package:bloc_notes/models/note/note_failure.dart';
import 'package:bloc_notes/ui/screens/note_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/notes_bloc.dart';
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
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          final error = state.getError<NotesLoadFailure>();
          if (error != null) {
            return Center(
              child: Text(error.toString()),
            );
          }
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final sortedNotes = state.notesSortedByCreatedAt;
          return ListView.builder(
            itemCount: sortedNotes.length,
            itemBuilder: (context, index) {
              final note = sortedNotes[index];
              return NoteListItem(note: note);
            },
          );
        },
      ),
    );
  }
}
