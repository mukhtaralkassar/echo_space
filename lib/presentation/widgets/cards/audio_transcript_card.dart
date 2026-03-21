import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/audio_note_cubit.dart';

/// Card displaying the audio player and a transcript that can be edited.
class AudioTranscriptCard extends StatefulWidget {
  final String id;
  final String locationName;
  final String durationText;
  final String transcriptText;
  final String languageCode;

  const AudioTranscriptCard({
    super.key,
    required this.id,
    required this.locationName,
    required this.durationText,
    required this.transcriptText,
    required this.languageCode,
  });

  @override
  State<AudioTranscriptCard> createState() => _AudioTranscriptCardState();
}

class _AudioTranscriptCardState extends State<AudioTranscriptCard> {
  bool _isTranscriptExpanded = false;
  bool _isPlaying = false;
  late TextEditingController _editController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.transcriptText);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _saveNewTranscript() {
    // Updates the transcript in the local database via Cubit
    context.read<AudioNoteCubit>().updateTranscript(widget.id, _editController.text);
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        // Updated withOpacity to withValues to resolve deprecation warnings
        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Audio Control Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton.filled(
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                  icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: _isPlaying ? const Color(0xFFFDE047) : const Color(0xFF6366F1),
                    foregroundColor: _isPlaying ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.locationName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.durationText,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Language Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE047).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.languageCode,
                    style: const TextStyle(
                      color: Color(0xFFFDE047),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                // Edit/Save Icon
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.check_circle : Icons.edit_note,
                    color: const Color(0xFFFDE047),
                  ),
                  onPressed: () {
                    if (_isEditing) {
                      _saveNewTranscript();
                    } else {
                      setState(() {
                        _isEditing = true;
                        _isTranscriptExpanded = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Collapsible Transcript Toggle
          GestureDetector(
            onTap: () => setState(() => _isTranscriptExpanded = !_isTranscriptExpanded),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.05),
                borderRadius: _isTranscriptExpanded 
                    ? BorderRadius.zero 
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
              ),
              child: Icon(
                _isTranscriptExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xFF6366F1),
              ),
            ),
          ),
          
          // Transcript Body with AnimatedSize for smooth transitions
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _isTranscriptExpanded
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isEditing
                        ? TextField(
                            controller: _editController,
                            maxLines: null,
                            autofocus: true,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              hintText: "Edit transcript...",
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                            ),
                          )
                        : Text(
                            widget.transcriptText,
                            style: const TextStyle(color: Colors.white70, height: 1.5),
                          ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}