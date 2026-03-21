import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:record/record.dart'; // Library for actual recording
import 'package:speech_to_text/speech_to_text.dart' as stt; // Library for Speech to Text
import 'package:geolocator/geolocator.dart'; // Library for Geolocation
import '../bloc/audio_note_cubit.dart';
import '../bloc/audio_note_state.dart';
import '../../domain/entities/audio_note.dart';
import '../widgets/cards/audio_transcript_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Services for recording and speech recognition
  late AudioRecorder _audioRecorder;
  late stt.SpeechToText _speech;
  bool _isRecording = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _speech = stt.SpeechToText();
    context.read<AudioNoteCubit>().loadNotes();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  // --- Logic for Real Recording and Speech Recognition ---

  Future<void> _startRecording() async {
    // 1. Check & Request Permissions
    bool hasSpeechPermission = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    
    if (await _audioRecorder.hasPermission() && hasSpeechPermission) {
      // 2. Start Speech to Text (Multi-language support is built-in)
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _wordsSpoken = result.recognizedWords;
            _confidenceLevel = result.confidence;
          });
        },
        localeId: 'en_US', // You can change this or make it dynamic for AR
      );

      // 3. Start Audio File Recording
      const config = RecordConfig();
      // In a real app, provide a local path for the .m4a or .wav file
      await _audioRecorder.start(config, path: 'temporary_path.m4a');

      setState(() {
        _isRecording = true;
        _wordsSpoken = "Listening...";
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    await _speech.stop();

    // 4. Get Current Location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 5. Create the Final Note with actual data
    final noteId = const Uuid().v4();
    final newNote = AudioNote(
      id: noteId,
      locationName: "Current Echo (${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)})",
      latitude: position.latitude,
      longitude: position.longitude,
      durationText: "0:30", // This would be calculated from start/stop times
      transcriptText: _wordsSpoken.isEmpty ? "No text captured" : _wordsSpoken,
      languageCode: "AUTO", // Speech to text can detect language
      createdAt: DateTime.now(),
    );

    if (mounted) {
      context.read<AudioNoteCubit>().addNote(newNote);
      setState(() {
        _isRecording = false;
        _wordsSpoken = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: BlocBuilder<AudioNoteCubit, AudioNoteState>(
                    builder: (context, state) {
                      if (state is AudioNoteLoading) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
                      } else if (state is AudioNoteLoaded) {
                        if (state.notes.isEmpty) return _buildEmptyState();
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 120, top: 10),
                          itemCount: state.notes.length,
                          itemBuilder: (context, index) {
                            final note = state.notes[index];
                            return AudioTranscriptCard(
                              id: note.id,
                              locationName: note.locationName,
                              durationText: note.durationText,
                              transcriptText: note.transcriptText,
                              languageCode: note.languageCode,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isRecording) _buildRecordingOverlay(),
        ],
      ),
      floatingActionButton: _buildRecordButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildRecordingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.graphic_eq_rounded, size: 100, color: Color(0xFFFDE047)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _wordsSpoken,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 40),
          const Text("Recording and Transcribing...", style: TextStyle(color: Color(0xFF6366F1))),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("EchoSpace", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text("Recording real-time echoes.", style: TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("No echoes found.", style: TextStyle(color: Colors.white24)));
  }

  Widget _buildRecordButton() {
    return GestureDetector(
      onLongPress: _startRecording,
      onLongPressUp: _stopRecording,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: _isRecording ? Colors.redAccent : const Color(0xFF6366F1),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.4), blurRadius: 20)],
        ),
        child: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, size: 40, color: Colors.white),
      ),
    );
  }
}