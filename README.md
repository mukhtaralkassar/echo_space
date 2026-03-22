# Echo Space

A voice-first note-taking app that records audio, transcribes it to text in real time using Speech-to-Text, and tags each note with your current location.

## Features

- Record audio notes directly from the app
- Real-time Speech-to-Text transcription with language code support
- Edit or update transcripts after recording
- Geolocation tagging: each note stores latitude, longitude, and location name
- Custom animated `WavePlayerBubble` widget for audio playback
- Offline-first storage with Hive
- Clean BLoC/Cubit architecture

## Highlight: WavePlayerBubble

A custom stateful widget using `SingleTickerProviderStateMixin` to animate a waveform indicator during audio playback. The animation starts and stops in sync with the audio player state.

## Tech Stack

- **Audio:** record ^6.2.0
- **Speech:** speech_to_text ^7.3.0
- **Location:** geolocator ^14.0.2
- **State Management:** Cubit (flutter_bloc) with Equatable
- **Storage:** Hive + hive_flutter
- **Other:** UUID

## Architecture

```
lib/
├── data/
│   ├── models/         — AudioNoteModel
│   ├── repositories/   — AudioNoteRepositoryImpl
│   └── data_sources/   — AudioNoteLocalDataSourceImpl (Hive)
├── domain/
│   ├── entities/       — AudioNote (id, transcriptText, locationName, lat, lng, duration, languageCode, createdAt)
│   └── repositories/   — AudioNoteRepository (abstract)
└── presentation/
    ├── cubit/          — AudioNoteCubit, AudioNoteState
    └── widgets/        — WavePlayerBubble, AudioTranscriptCard
```

