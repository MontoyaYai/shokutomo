import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Get instance of the individual api's using instance of [Vision]
/// For example
/// To get an instance of [ImageLabeler]
/// ImageLabeler imageLabeler = GoogleMlKit.instance.imageLabeler();
class Vision {
  Vision._();

  // Creates an instance of [GoogleMlKit] by calling the private constructor
  static final Vision instance = Vision._();

  /// Return an instance of [TextRecognizer].
  TextRecognizer textRecognizer({script = TextRecognitionScript.latin}) {
    return TextRecognizer(script: script);
  }
}
