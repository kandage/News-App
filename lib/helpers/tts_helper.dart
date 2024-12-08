import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }
}
