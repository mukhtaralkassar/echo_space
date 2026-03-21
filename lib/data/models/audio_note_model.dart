import 'dart:convert';
import '../../domain/entities/audio_note.dart';

/// Data model that extends the domain entity to include serialization logic.
/// Handles mapping between local storage JSON format and the app's entity.
class AudioNoteModel extends AudioNote {
  const AudioNoteModel({
    required super.id,
    required super.locationName,
    required super.latitude,
    required super.longitude,
    required super.durationText,
    required super.transcriptText,
    required super.languageCode,
    required super.createdAt,
  });

  /// Factory method to create a model from a JSON map
  factory AudioNoteModel.fromMap(Map<String, dynamic> map) {
    return AudioNoteModel(
      id: map['id'] as String,
      locationName: map['locationName'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      durationText: map['durationText'] as String,
      transcriptText: map['transcriptText'] as String,
      languageCode: map['languageCode'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// Converts the model to a JSON map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'durationText': durationText,
      'transcriptText': transcriptText,
      'languageCode': languageCode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Factory method to create a model from a JSON string
  factory AudioNoteModel.fromJson(String source) => 
      AudioNoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Converts the model to a JSON string
  String toJson() => json.encode(toMap());
}