import 'package:bloc_notes/ui/screens/note_form_screen.dart';
import 'package:bloc_notes/ui/screens/note_list_screen.dart';
import 'package:flutter/material.dart';
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
          path: NoteFormScreen.subPath,
          builder: (context, state) => const NoteFormScreen(),
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
