class TextAnalyzer {
  static final RegExp _wordPattern = RegExp(
    r"[A-Za-zА-Яа-яЁёІіЇїЄєҐґ0-9]+(?:['’-][A-Za-zА-Яа-яЁёІіЇїЄєҐґ0-9]+)*",
  );

  Map<String, dynamic> analyze(String text) {
    final words = _wordPattern
        .allMatches(text.toLowerCase())
        .map((match) => match.group(0)!)
        .toList();
    final frequencies = <String, int>{};
    for (final word in words) {
      frequencies.update(word, (count) => count + 1, ifAbsent: () => 1);
    }
    final sortedFrequencies = frequencies.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });

    return {
      'characters': text.runes.length,
      'charactersWithoutWhitespace': text.runes
          .where((rune) => String.fromCharCode(rune).trim().isNotEmpty)
          .length,
      'words': words.length,
      'uniqueWords': frequencies.length,
      'lines': text.isEmpty ? 0 : '\n'.allMatches(text).length + 1,
      'wordFrequencies': Map<String, int>.fromEntries(sortedFrequencies),
    };
  }
}
