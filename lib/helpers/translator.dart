// helpers/translator.dart
import 'package:translator/translator.dart';

class TranslatorService {
  final GoogleTranslator translator = GoogleTranslator();

  Future<String> translateText(String text, String targetLang) async {
    var translation = await translator.translate(text, to: targetLang);
    return translation.text;
  }
}
