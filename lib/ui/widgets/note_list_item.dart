import 'package:bloc_notes/models/note.dart';
import 'package:flutter/material.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: const Icon(Icons.note),
        title: Text(note.title),
        trailing: Text(note.createdAtFormatted),
      ),
    );
  }
}
