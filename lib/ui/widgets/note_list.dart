import 'package:bloc_notes/ui/widgets/note_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/notes_bloc.dart';
import '../../models/note/note.dart';
import '../../models/note/note_failure.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key, required this.notes});
  final List<Note> notes;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final _deletionInProgressIds = <String>{};
  final _notesFinishedDeleting = <Note>{};

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
      child: ListView.builder(
        itemCount: widget.notes.length,
        itemBuilder: (context, index) {
          final note = widget.notes[index];
          return NoteListItem(
            note: note,
            confirmDismiss: (direction) async {
              _deletionInProgressIds.add(note.id);

              final notesBloc = context.read<NotesBloc>();
              notesBloc.add(NotesDeleted(id: note.id));
              final deleteHandledState = await notesBloc.stream.firstWhere(
                (state) => !state.isBeingDeleted(note.id),
              );

              final isSuccess =
                  !deleteHandledState.hasError<NotesDeleteFailure>();
              if (!isSuccess) {
                _deletionInProgressIds.remove(note.id);
              }

              return isSuccess;
            },
            onDismissed: (direction) {
              _deletionInProgressIds.remove(note.id);
              _notesFinishedDeleting.add(note);
              if (_deletionInProgressIds.isEmpty) {
                setState(() {
                  final difference =
                      {...widget.notes}.difference(_notesFinishedDeleting);
                  widget.notes
                    ..clear()
                    ..addAll(difference);
                  _notesFinishedDeleting.clear();
                });
              }
            },
          );
        }, //sss
      ),
    );
  }
}
