// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notes_bloc.dart';

enum NotesStatus {
  initial,
  creating,
  createFinished,
  fetching,
  fetchFinished,
  updating,
  updateFinished,
  deleting,
  deleteFinished,
}

@immutable
class NotesState extends Equatable {
  const NotesState({
    required this.notes,
    this.status = NotesStatus.initial,
    this.errors = const <Failure>{},
    this.beingDeletedIds = const <String>{},
    // this.lastDeletedId = '',
  });

  final List<Note> notes;
  final NotesStatus status;

  List<Note> get notesSortedByCreatedAt => [...notes]..sort(
      (a, b) {
        return b.createdAt.compareTo(a.createdAt);
      },
    );

  bool get isCreating => status == NotesStatus.creating;
  bool get isFetching => status == NotesStatus.fetching;
  bool get isUpdating => status == NotesStatus.updating;
  bool get isDeleting => status == NotesStatus.deleting;
  final Set<String> beingDeletedIds;
  // final String lastDeletedId;

  bool isBeingDeleted(String noteId) => beingDeletedIds.contains(noteId);

  final Set<Failure> errors;

  bool get hasErrors => errors.isNotEmpty;

  bool hasError<T>() {
    return errors.any((element) => element.runtimeType == T);
  }

  T? getError<T>() {
    try {
      return errors.firstWhere((element) => element.runtimeType == T) as T;
    } on StateError {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        notes,
        isCreating,
        isFetching,
        isUpdating,
        isDeleting,
        errors,
        beingDeletedIds,
        // lastDeletedId,
      ];

  NotesState copyWith({
    List<Note>? notes,
    NotesStatus? status,
    Set<Failure>? errors,
    Set<String>? beingDeletedIds,
    // String? lastDeletedId,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      status: status ?? this.status,
      errors: errors ?? this.errors,
      beingDeletedIds: beingDeletedIds ?? this.beingDeletedIds,
      // lastDeletedId: lastDeletedId ?? this.lastDeletedId,
    );
  }
}
