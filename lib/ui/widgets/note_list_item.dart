import 'package:bloc_notes/bloc/notes_bloc.dart';
import 'package:bloc_notes/models/note/note.dart';
import 'package:bloc_notes/models/note/note_failure.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
      listenWhen: (previous, current) => current.hasError<NotesDeleteFailure>(),
      listener: (context, state) {
        final error = state.getError<NotesDeleteFailure>()!;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(error.message),
          ),
        );
        context.read<NotesBloc>().add(NotesErrorHandled(error));
      },
      child: Dismissible(
        key: ValueKey(note.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          final notesBloc = context.read<NotesBloc>();
          notesBloc.add(NotesDeleted(id: note.id));
          final deleteHandledState = await notesBloc.stream.firstWhere(
              (state) => state.status == NotesStatus.deleteFinished);
          return !deleteHandledState.hasError<NotesDeleteFailure>();
        },
        background: Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 18),
            child: BlocBuilder<NotesBloc, NotesState>(
              buildWhen: (previous, current) =>
                  previous.isDeleting != current.isDeleting,
              builder: (context, state) {
                if (state.isDeleting) {
                  return const CircularProgressIndicator();
                }
                return const Icon(Icons.delete_outline);
              },
            ),
          ),
        ),
        child: Material(
          child: ListTile(
            leading: const Icon(Icons.note),
            title: Text(note.title),
            trailing: Text(note.createdAtFormatted),
          ),
        ),
      ),
    );
  }
}
