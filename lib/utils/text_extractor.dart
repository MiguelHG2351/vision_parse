// lib/utils/text_extractor.dart

class TextExtractor {
  // Expresión regular para detectar correos electrónicos
  static final RegExp _emailRegex = RegExp(
    r'\b[\w\.-]+@[\w\.-]+\.\w{2,}\b',
    caseSensitive: false,
  );

  // Expresión regular para detectar URLs (http/https)
  // Nota: es una regex básica. Refínala según tu necesidad.
  static final RegExp _urlRegex = RegExp(
    r'\bhttps?:\/\/[^\s/$.?#].[^\s]*\b',
    caseSensitive: false,
  );

  // Expresión regular para números de teléfono (varios formatos)
  // Admite:
  //  - +34 600-123-456
  //  - (600) 123 456
  //  - 600123456
  //  - 600 123 456
  static final RegExp _phoneRegex = RegExp(
    r'(\+?\d{1,3}[\s-]?)?(?:\(?\d{2,4}\)?[\s-]?)?\d{3,4}[\s-]?\d{3,4}',
  );

  /// Extrae todos los emails únicos de [inputText].
  static List<String> extractEmails(String inputText) {
    final matches = _emailRegex.allMatches(inputText);
    return matches.map((m) => m.group(0)!).toSet().toList();
  }

  /// Extrae todas las URLs únicas de [inputText].
  static List<String> extractUrls(String inputText) {
    final matches = _urlRegex.allMatches(inputText);
    return matches.map((m) => m.group(0)!).toSet().toList();
  }

  /// Extrae todos los números de teléfono únicos de [inputText].
  static List<String> extractPhones(String inputText) {
    final matches = _phoneRegex.allMatches(inputText);
    // Filtrar coincidencias que no sean realmente teléfonos (por ejemplo, fechas, códigos numéricos largos, etc.)
    // Este filtro es muy básico; ajústalo según tu caso real.
    return matches
        .map((m) => m.group(0)!.trim())
        .where((s) => s.replaceAll(RegExp(r'\D'), '').length >= 7)
        .toSet()
        .toList();
  }
}
