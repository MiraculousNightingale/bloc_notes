import 'package:bloc/bloc.dart';
import 'package:bloc_notes/models/failure/failure.dart';
import 'package:bloc_notes/models/note/note.dart';
import 'package:bloc_notes/models/note/note_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesState(notes: [])) {
    on<NotesCreated>(_onNoteCreated);
    on<NotesErrorHandled>(_onNotesErrorHandled);
  }

  Future<void> _onNoteCreated(
    NotesCreated event,
    Emitter<NotesState> emit,
  ) async {
    final newNote = event.newNote;
    emit(state.copyWith(isCreating: true));
    try {
      // saving with sqflite logic
      await Future.delayed(const Duration(seconds: 1)); // TODO: remove later
      // throw (Exception('Test error.'));
      emit(state.copyWith(
        notes: [...state.notes, newNote],
        isCreating: false,
      ));
    } on Exception catch (_) {
      emit(state.copyWith(
        errors: {
          ...state.errors,
          const NotesCreateFailure('Error when creating.'),
        },
        isCreating: false,
      ));
    }
  }

  void _onNotesErrorHandled(
    NotesErrorHandled event,
    Emitter<NotesState> emit,
  ) {
    emit(state.copyWith(
      // errors: {...state.errors..remove(event.error)},
      errors: state.errors.difference({event.error}),
    ));
  }

  // TODO: _onNoteFetched?
}
