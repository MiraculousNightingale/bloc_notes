part of 'notes_bloc.dart';

@immutable
sealed class NotesEvent {}

final class NotesCreated extends NotesEvent {
  NotesCreated({required this.newNote});
  final Note newNote;
}

final class NotesUpdated extends NotesEvent {
  NotesUpdated({required this.updatedNote});
  final Note updatedNote;
}

final class NotesFetched extends NotesEvent {}

final class NotesDeleted extends NotesEvent {
  NotesDeleted({required this.id});
  final String id;
}

final class NotesErrorHandled extends NotesEvent {
  NotesErrorHandled(this.error);

  final Failure error;
  // final Set<Failure> errors;
}
