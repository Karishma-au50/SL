String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return '';

  List<String> words = text.split(' ');
  List<String> capitalizedWords = [];

  for (String word in words) {
    if (word.isNotEmpty) {
      String capitalizedWord =
          word[0].toUpperCase() + word.substring(1).toLowerCase();
      capitalizedWords.add(capitalizedWord);
    }
  }

  return capitalizedWords.join(' ');
}
