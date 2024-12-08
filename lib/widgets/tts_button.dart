import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSButton extends StatefulWidget {
  final String text;

  TTSButton({Key? key, required this.text}) : super(key: key);

  @override
  _TTSButtonState createState() => _TTSButtonState();
}

class _TTSButtonState extends State<TTSButton> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((message) {
      setState(() {
        _isSpeaking = false;
      });
      print("TTS Error: $message");
    });
  }

  Future<void> _speak() async {
    await _flutterTts.stop(); // Stop any ongoing speech
    if (widget.text.isNotEmpty) {
      await _flutterTts.speak(widget.text);
    }
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isSpeaking ? Icons.stop : Icons.play_arrow),
      onPressed: () async {
        if (_isSpeaking) {
          await _stop();
        } else {
          await _speak();
        }
      },
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
