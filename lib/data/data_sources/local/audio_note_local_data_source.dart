import 'package:hive/hive.dart';
import '../../models/audio_note_model.dart';

/// Abstract contract for local data operations
abstract class AudioNoteLocalDataSource {
  Future<List<AudioNoteModel>> getAudioNotes();
  Future<void> saveAudioNote(AudioNoteModel note);
  Future<void> deleteAudioNote(String id);
}

/// Concrete implementation using Hive for fast local key-value storage
class AudioNoteLocalDataSourceImpl implements AudioNoteLocalDataSource {
  static const String _boxName = 'audio_notes_box';

  @override
  Future<List<AudioNoteModel>> getAudioNotes() async {
    final box = await Hive.openBox<String>(_boxName);
    
    // Convert all stored JSON strings back to AudioNoteModel objects
    final notes = box.values
        .map((jsonStr) => AudioNoteModel.fromJson(jsonStr))
        .toList();
        
    // Sort by creation date descending (newest first)
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  @override
  Future<void> saveAudioNote(AudioNoteModel note) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.put(note.id, note.toJson());
  }

  @override
  Future<void> deleteAudioNote(String id) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.delete(id);
  }
}