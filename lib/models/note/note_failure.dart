import 'package:bloc_notes/core/errors/failure.dart';

class NotesCreateFailure extends Failure {
  const NotesCreateFailure([super.error]);
}

class NotesFetchFailure extends Failure {
  const NotesFetchFailure([super.error]);
}

class NotesUpdateFailure extends Failure {
  const NotesUpdateFailure([super.error]);
}

class NotesDeleteFailure extends Failure {
  const NotesDeleteFailure([super.error]);
}
