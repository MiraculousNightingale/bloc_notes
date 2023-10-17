part of 'notes_bloc.dart';

@immutable
class NotesState extends Equatable {
  const NotesState({
    required this.notes,
    this.isCreating = false,
    this.isLoading = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.errors = const <Failure>{},
  });

  final List<Note> notes;

  List<Note> get notesSortedByCreatedAt => [...notes]..sort(
      (a, b) {
        return b.createdAt.compareTo(a.createdAt);
      },
    );

  final bool isCreating;
  final bool isLoading;
  final bool isUpdating;
  final bool isDeleting;

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
  List<Object?> get props =>
      [notes, isCreating, isLoading, isUpdating, isDeleting, errors];

  NotesState copyWith({
    List<Note>? notes,
    bool? isCreating,
    bool? isLoading,
    bool? isUpdating,
    bool? isDeleting,
    Set<Failure>? errors,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isCreating: isCreating ?? this.isCreating,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      errors: errors ?? this.errors,
    );
  }
}
