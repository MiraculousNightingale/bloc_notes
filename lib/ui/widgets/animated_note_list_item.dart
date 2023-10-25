import 'package:bloc_notes/models/note/note.dart';
import 'package:flutter/material.dart';

import 'note_list_item.dart';

class AnimatedNoteListItem extends StatelessWidget {
  const AnimatedNoteListItem({
    super.key,
    required this.note,
    required this.animation,
    this.confirmDismiss,
    this.onDismissed,
  });
  final Animation<double> animation;
  final Note note;
  final Future<bool?> Function(DismissDirection direction)? confirmDismiss;
  final void Function(DismissDirection direction)? onDismissed;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: NoteListItem(
        note: note,
        confirmDismiss: confirmDismiss,
        onDismissed: onDismissed,
      ),
    );
  }
}
