/// On-device text recognition. Returns the recognized text lines, or an empty
/// list on failure. Never throws.
abstract class OcrService {
  Future<List<String>> readLines(String imagePath);
}
