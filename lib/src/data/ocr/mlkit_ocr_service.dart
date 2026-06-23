import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../domain/services/ocr_service.dart';

class MlKitOcrService implements OcrService {
  @override
  Future<List<String>> readLines(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      return [
        for (final block in result.blocks)
          for (final line in block.lines) line.text,
      ];
    } catch (_) {
      return const [];
    } finally {
      await recognizer.close();
    }
  }
}
