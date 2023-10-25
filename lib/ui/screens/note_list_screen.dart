import 'package:bloc_notes/models/note/note_failure.dart';
import 'package:bloc_notes/ui/screens/note_form_screen.dart';
import 'package:bloc_notes/ui/widgets/animated_note_list.dart';
import 'package:bloc_notes/ui/widgets/note_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/notes_bloc.dart';
import '../widgets/note_list_item.dart';

class NoteListScreen extends StatefulWidget {
  static const path = '/notes';
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(NotesFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes with BLoC'),
        actions: [
          BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              return IconButton(
                onPressed: state.isDeleting
                    ? null
                    : () => context.go(NoteFormScreen.path),
                icon: const Icon(Icons.add),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) =>
            previous.isFetching != current.isFetching ||
            current.status == NotesStatus.createFinished ||
            current.status == NotesStatus.updateFinished,
        builder: (context, state) {
          final error = state.getError<NotesFetchFailure>();
          if (error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final notesBloc = context.read<NotesBloc>();
                      notesBloc.add(NotesErrorHandled(error));
                      notesBloc.add(NotesFetched());
                    },
                    child: const Text(
                      'Retry',
                    ),
                  ),
                ],
              ),
            );
          }
          if (state.isFetching) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final sortedNotes = state.notesSortedByCreatedAt;
          // TODO: replace with animated list
          // return ListView.builder(
          return NoteList(notes: sortedNotes);
        },
      ),
    );
  }
}
