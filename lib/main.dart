import 'dart:math';

import 'package:bloc_notes/app/app.dart';
import 'package:flutter/material.dart';

import 'models/note.dart';

void main() {
  runApp(NotesApp());
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
