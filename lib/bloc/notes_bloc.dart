import 'package:bloc/bloc.dart';
import 'package:bloc_notes/main.dart';
import 'package:bloc_notes/core/errors/failure.dart';
import 'package:bloc_notes/models/note/note_failure.dart';
import 'package:bloc_notes/models/note/note.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesState(notes: [])) {
    on<NotesErrorHandled>(_onNotesErrorHandled);
    on<NotesFetched>(_onNotesFetched);
    on<NotesCreated>(_onNotesCreated);
    on<NotesUpdated>(_onNotesUpdated);
    on<NotesDeleted>(_onNotesDeleted);
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

  Future<void> _onNotesCreated(
    NotesCreated event,
    Emitter<NotesState> emit,
  ) async {
    final newNote = event.newNote;
    emit(state.copyWith(status: NotesStatus.creating));
    try {
      // TODO: saving with sqflite
      await Future.delayed(const Duration(seconds: 1)); // TODO: remove later
      // throw (Exception('Test error.'));

      kDummyNotes.add(newNote);

      emit(state.copyWith(
        notes: [...state.notes, newNote],
        status: NotesStatus.createFinished,
      ));
    } on Exception catch (_) {
      emit(state.copyWith(
        errors: {
          ...state.errors,
          const NotesCreateFailure('Error when creating.'),
        },
        status: NotesStatus.createFinished,
      ));
    }
  }

  Future<void> _onNotesUpdated(
    NotesUpdated event,
    Emitter<NotesState> emit,
  ) async {
    final updatedNote = event.updatedNote;
    emit(state.copyWith(status: NotesStatus.updating));
    try {
      // TODO: saving with sqflite
      await Future.delayed(const Duration(seconds: 1)); // TODO: remove later
      // throw (Exception('Test error.'));

      // for now this is a db
      final index = kDummyNotes.indexWhere((note) => note.id == updatedNote.id);
      kDummyNotes[index] = updatedNote;

      final stateIndex =
          state.notes.indexWhere((note) => note.id == updatedNote.id);
      emit(state.copyWith(
        notes: [...state.notes..[stateIndex] = updatedNote],
        status: NotesStatus.updateFinished,
      ));
    } on Exception catch (_) {
      emit(state.copyWith(
        errors: {
          ...state.errors,
          const NotesUpdateFailure('Error when updating.'),
        },
        status: NotesStatus.updateFinished,
      ));
    }
  }

  Future<void> _onNotesFetched(
    NotesFetched event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(status: NotesStatus.fetching));
    try {
      // TODO: fetching with sqflite
      await Future.delayed(const Duration(seconds: 1)); // TODO: remove later
      //throw (Exception('Test error.'));
      emit(state.copyWith(
        notes: [...kDummyNotes],
        status: NotesStatus.fetchFinished,
      ));
    } on Exception catch (_) {
      emit(state.copyWith(
        errors: {
          ...state.errors,
          const NotesFetchFailure('Error when fetching.'),
        },
        status: NotesStatus.fetchFinished,
      ));
    }
  }

  Future<void> _onNotesDeleted(
    NotesDeleted event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(
      status: NotesStatus.deleting,
      beingDeletedIds: {...state.beingDeletedIds, event.id},
    ));
    try {
      // TODO: deleting with sqflite
      await Future.delayed(const Duration(seconds: 1)); // TODO: remove later
      // throw (Exception('Test error.'));
      kDummyNotes.removeWhere((note) => note.id == event.id);
      final newBeingDeletedIds = {
        ...state.beingDeletedIds.difference({event.id})
      };
      emit(state.copyWith(
        notes: [...state.notes..removeWhere((note) => note.id == event.id)],
        status: newBeingDeletedIds.isEmpty ? NotesStatus.deleteFinished : null,
        beingDeletedIds: newBeingDeletedIds,
        // lastDeletedId: event.id,
      ));
    } on Exception catch (_) {
      final newBeingDeletedIds = {
        ...state.beingDeletedIds.difference({event.id})
      };
      emit(state.copyWith(
        errors: {
          ...state.errors,
          const NotesDeleteFailure('Error when deleting.'),
        },
        status: newBeingDeletedIds.isEmpty ? NotesStatus.deleteFinished : null,
        beingDeletedIds: newBeingDeletedIds,
        // lastDeletedId: event.id,
      ));
    }
  }

  @override
  void onTransition(Transition<NotesEvent, NotesState> transition) {
    super.onTransition(transition);
  }
}
