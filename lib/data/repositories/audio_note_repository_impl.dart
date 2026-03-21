import '../../domain/entities/audio_note.dart';
import '../../domain/repositories/audio_note_repository.dart';
import '../data_sources/local/audio_note_local_data_source.dart';
import '../models/audio_note_model.dart';

/// Concrete implementation of the repository contract.
class AudioNoteRepositoryImpl implements AudioNoteRepository {
  final AudioNoteLocalDataSource localDataSource;

  AudioNoteRepositoryImpl({required this.localDataSource});

  @override
  Future<List<AudioNote>> getAllNotes() async {
    return await localDataSource.getAudioNotes();
  }

  @override
  Future<void> addNote(AudioNote note) async {
    final noteModel = AudioNoteModel(
      id: note.id,
      locationName: note.locationName,
      latitude: note.latitude,
      longitude: note.longitude,
      durationText: note.durationText,
      transcriptText: note.transcriptText,
      languageCode: note.languageCode,
      createdAt: note.createdAt,
    );
    await localDataSource.saveAudioNote(noteModel);
  }

  @override
  Future<void> removeNote(String id) async {
    await localDataSource.deleteAudioNote(id);
  }

  @override
  Future<void> updateNoteTranscript(String id, String newTranscript) async {
    // Fetch all notes, modify the specific one, and save back
    // In Hive with this model, we typically get the JSON, update it, and put it back
    final notes = await localDataSource.getAudioNotes();
    final index = notes.indexWhere((element) => element.id == id);
    
    if (index != -1) {
      final updatedModel = AudioNoteModel(
        id: notes[index].id,
        locationName: notes[index].locationName,
        latitude: notes[index].latitude,
        longitude: notes[index].longitude,
        durationText: notes[index].durationText,
        transcriptText: newTranscript, // New updated transcript
        languageCode: notes[index].languageCode,
        createdAt: notes[index].createdAt,
      );
      await localDataSource.saveAudioNote(updatedModel);
    }
  }
}