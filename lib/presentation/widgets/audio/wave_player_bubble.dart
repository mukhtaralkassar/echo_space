import 'package:flutter/material.dart';

/// A custom audio player widget designed to look like a chat bubble.
/// It simulates an audio waveform and handles play/pause state locally.
class WavePlayerBubble extends StatefulWidget {
  final String durationText;
  final VoidCallback onPlayToggle;

  const WavePlayerBubble({
    super.key,
    required this.durationText,
    required this.onPlayToggle,
  });

  @override
  State<WavePlayerBubble> createState() => _WavePlayerBubbleState();
}

class _WavePlayerBubbleState extends State<WavePlayerBubble> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    // Controls the simulated wave animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
        _waveController.value = 0.0;
      }
    });
    widget.onPlayToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.15), // Soft Indigo translucent
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(4), // Chat bubble pointer effect
        ),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause Button
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFDE047), // Starlight Yellow
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF0F172A), // Cosmic Blue
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Simulated Audio Waveform (Human Touch Element)
          Row(
            children: List.generate(
              15, 
              (index) => AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  // Generate pseudo-random heights based on the animation
                  double height = _isPlaying 
                      ? 10 + (index % 3 == 0 ? 15 : 5) * _waveController.value 
                      : 4.0;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 3,
                    height: height,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1), // Soft Indigo
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          // Duration Indicator
          Text(
            widget.durationText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}