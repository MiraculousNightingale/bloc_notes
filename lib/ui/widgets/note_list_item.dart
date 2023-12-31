import 'package:bloc_notes/bloc/notes_bloc.dart';
import 'package:bloc_notes/models/note/note.dart';
import 'package:bloc_notes/ui/screens/note_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem({
    super.key,
    required this.note,
    this.confirmDismiss,
    this.onDismissed,
  });

  final Note note;
  final Future<bool?> Function(DismissDirection direction)? confirmDismiss;
  final void Function(DismissDirection direction)? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: confirmDismiss,
      onDismissed: onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 18),
          child: BlocBuilder<NotesBloc, NotesState>(
            buildWhen: (previous, current) =>
                previous.isBeingDeleted(note.id) !=
                current.isBeingDeleted(note.id),
            builder: (context, state) {
              if (state.isBeingDeleted(note.id)) {
                return const CircularProgressIndicator();
              }
              return const Icon(Icons.delete_outline);
            },
          ),
        ),
      ),
      child: Material(
        child: ListTile(
          isThreeLine: true,
          leading: const Icon(Icons.note),
          title: Text(note.title),
          subtitle: Text(note.createdAtFormatted),
          trailing: IconButton(
            onPressed: () {
              context.go('${NoteFormScreen.pathUpdate}/${note.id}');
            },
            icon: const Icon(Icons.edit),
          ),
        ),
      ),
    );
  }
}
