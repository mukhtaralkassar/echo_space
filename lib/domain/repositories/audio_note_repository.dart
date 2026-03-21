import '../entities/audio_note.dart';

/// Abstract repository defining the contract for audio note data operations.
/// Updated to include update functionality for transcripts.
abstract class AudioNoteRepository {
  Future<List<AudioNote>> getAllNotes();
  Future<void> addNote(AudioNote note);
  Future<void> removeNote(String id);
  
  /// Specifically updates the transcript text of an existing note
  Future<void> updateNoteTranscript(String id, String newTranscript);
}