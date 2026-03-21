import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/audio_note.dart';
import '../../domain/repositories/audio_note_repository.dart';
import 'audio_note_state.dart';

/// Cubit responsible for managing the state of Audio Notes.
class AudioNoteCubit extends Cubit<AudioNoteState> {
  final AudioNoteRepository repository;

  AudioNoteCubit({required this.repository}) : super(AudioNoteInitial());

  /// Loads all stored audio notes, sorted by date (handled in data source)
  Future<void> loadNotes() async {
    try {
      emit(AudioNoteLoading());
      final notes = await repository.getAllNotes();
      emit(AudioNoteLoaded(notes));
    } catch (e) {
      emit(AudioNoteError("Failed to load notes: ${e.toString()}"));
    }
  }

  /// Adds a new audio note and refreshes list
  Future<void> addNote(AudioNote note) async {
    try {
      await repository.addNote(note);
      await loadNotes();
    } catch (e) {
      emit(AudioNoteError("Failed to add note: ${e.toString()}"));
    }
  }

  /// Updates only the text content of a specific note
  Future<void> updateTranscript(String id, String newText) async {
    try {
      await repository.updateNoteTranscript(id, newText);
      await loadNotes();
    } catch (e) {
      emit(AudioNoteError("Failed to update transcript: ${e.toString()}"));
    }
  }

  /// Removes an audio note and its associated transcript
  Future<void> deleteNote(String id) async {
    try {
      await repository.removeNote(id);
      await loadNotes();
    } catch (e) {
      emit(AudioNoteError("Failed to delete note: ${e.toString()}"));
    }
  }
}