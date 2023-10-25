import 'package:bloc_notes/ui/widgets/animated_note_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/notes_bloc.dart';
import '../../models/note/note.dart';
import '../../models/note/note_failure.dart';

class AnimatedNoteList extends StatelessWidget {
  AnimatedNoteList({super.key, required this.notes});

  final List<Note> notes;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  void removeItem(int index) {
    final note = notes[index];
    listKey.currentState!.removeItem(
      index,
      (context, animation) => AnimatedNoteListItem(
        note: note,
        animation: animation,
      ),
      duration: const Duration(milliseconds: 300),
    );
    notes.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Error handling
        BlocListener<NotesBloc, NotesState>(
          listenWhen: (previous, current) =>
              current.hasError<NotesDeleteFailure>(),
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
        ),
        BlocListener<NotesBloc, NotesState>(
          listenWhen: (previous, current) =>
              current.hasError<NotesDeleteFailure>(),
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
        ),
      ],
      child: AnimatedList(
        key: listKey,
        // itemCount: notes.length,
        initialItemCount: notes.length,
        // itemBuilder: (context, index) {
        itemBuilder: (context, index, animation) {
          final note = notes[index];
          return AnimatedNoteListItem(
            note: notes[index],
            animation: animation,
            confirmDismiss: (direction) async {
              final notesBloc = context.read<NotesBloc>();
              notesBloc.add(NotesDeleted(id: note.id));
              final deleteHandledState = await notesBloc.stream.firstWhere(
                (state) => !state.isBeingDeleted(note.id),
              );
              if (!deleteHandledState.hasError<NotesDeleteFailure>()) {
                removeItem(index);
                return true;
              }
              return false;
            },
          );
        },
      ),
    );
  }
}
