import 'package:equatable/equatable.dart';

/// Enterprise domain entity representing a Geolocation Audio Note.
/// This core entity is independent of any frameworks or database structures.
class AudioNote extends Equatable {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final String durationText;
  final String transcriptText;
  final String languageCode;
  final DateTime createdAt;

  const AudioNote({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.durationText,
    required this.transcriptText,
    required this.languageCode,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        locationName,
        latitude,
        longitude,
        durationText,
        transcriptText,
        languageCode,
        createdAt,
      ];
}