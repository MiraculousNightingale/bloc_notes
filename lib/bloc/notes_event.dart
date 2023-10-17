part of 'notes_bloc.dart';

@immutable
sealed class NotesEvent {}

final class NotesCreated extends NotesEvent {
  NotesCreated({required this.newNote});
  final Note newNote;
}

final class NotesFetched extends NotesEvent {}

final class NotesErrorHandled extends NotesEvent {
  NotesErrorHandled(this.error);

  final Failure error;
  // final Set<Failure> errors;
}
