import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceSearch {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isInitialized = false;

  VoiceSearch() {
    _speech = stt.SpeechToText();
  }

  Future<void> listen(Function(String) onResultCallback) async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await requestMicrophonePermission();
    }

    if (!_isInitialized) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech recognition status: $status'),
        onError: (error) => print('Speech recognition error: $error'),
      );
      if (available) {
        _isInitialized = true;
        print('Speech recognition initialized successfully');
      } else {
        print('Speech recognition is not available');
        return;
      }
    }

    if (!_isListening) {
      _speech.listen(
        onResult: (val) {
          print('Recognized words: ${val.recognizedWords}');
          onResultCallback(val.recognizedWords);
        },
        listenFor: const Duration(seconds: 30), // Increased timeout duration
      );
      _isListening = true;
    } else {
      _speech.stop();
      _isListening = false;
    }
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
