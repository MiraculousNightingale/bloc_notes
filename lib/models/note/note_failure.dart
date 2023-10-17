import 'package:bloc_notes/models/failure/failure.dart';

class NotesCreateFailure extends Failure {
  const NotesCreateFailure([super.error]);
}

class NotesLoadFailure extends Failure {
  const NotesLoadFailure([super.error]);
}

class NoteUpdateFailure extends Failure {
  const NoteUpdateFailure([super.error]);
}

class NoteDeleteFailure extends Failure {
  const NoteDeleteFailure([super.error]);
}
