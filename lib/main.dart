import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'bloc/notes_bloc.dart';
import 'models/note/note.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => NotesBloc(),
    child: NotesApp(),
  ));
}

// TODO: Remove later
final kRandom = Random();
List<Note> generateNotes() {
  final list = <Note>[];
  for (var i = 1; i <= 15; ++i) {
    final createdAt = kRandom.nextInt(i);
    final updatedAt = createdAt + kRandom.nextInt(i + 10);
    list.add(
      Note(
        title: 'Note $i',
        text: 'Text $i',
        createdAt: DateTime.now().add(Duration(days: createdAt)),
        updatedAt: DateTime.now().add(Duration(days: updatedAt)),
      ),
    );
  }
  return list;
}

final kDummyNotes = [...generateNotes()];
