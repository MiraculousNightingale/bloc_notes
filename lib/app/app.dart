import 'package:bloc_notes/bloc/notes_bloc.dart';
import 'package:bloc_notes/ui/screens/note_form_screen.dart';
import 'package:bloc_notes/ui/screens/note_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotesApp extends MaterialApp {
  NotesApp({super.key})
      : super.router(
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: _router,
        );
}

final _router = GoRouter(
  initialLocation: NoteListScreen.path,
  routes: [
    GoRoute(
      path: NoteListScreen.path,
      builder: (context, state) => const NoteListScreen(),
      routes: [
        GoRoute(
          path: NoteFormScreen.subPathCreate,
          builder: (context, state) => const NoteFormScreen(),
        ),
        GoRoute(
          path: '${NoteFormScreen.subPathUpdate}/:userId',
          builder: (context, state) => NoteFormScreen(
            initialValue: context.read<NotesBloc>().state.notes.firstWhere(
                  (note) => note.id == state.pathParameters['userId'],
                ),
          ),
        ),
        //TODO: implement update route
        // GoRoute(
        //   path: NoteFormScreen.subPath,
        //   builder: (context, state) => const NoteFormScreen(
        //     isCreateMode: false,
        //   ),
        // ),
      ],
    ),
  ],
);
