import 'package:equatable/equatable.dart';
import '../../domain/entities/audio_note.dart';

/// Base state class for Audio Notes
abstract class AudioNoteState extends Equatable {
  const AudioNoteState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class AudioNoteInitial extends AudioNoteState {}

/// State representing active data fetching
class AudioNoteLoading extends AudioNoteState {}

/// State representing successful data retrieval
class AudioNoteLoaded extends AudioNoteState {
  final List<AudioNote> notes;

  const AudioNoteLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

/// State representing an error occurred during operations
class AudioNoteError extends AudioNoteState {
  final String message;

  const AudioNoteError(this.message);

  @override
  List<Object?> get props => [message];
}