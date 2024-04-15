extension StringExtensions on String {
  String capitalizeWords() {
    if (isEmpty) return this;

    List<String> words = split(" ");
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] =
            words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }
    return words.join(" ");
  }

  List<String> progressiveSubstrings() {
    List<String> substrings = [];
    for (int i = 1; i <= length; i++) {
      substrings.add(substring(0, i));
    }
    return substrings;
  }
}

class StringExtensionsClass {
  static String capitalizeWords(String input) {
    if (input.isEmpty) return input;

    List<String> words = input.split(" ");
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] =
            words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }
    return words.join(" ");
  }

  List<String> progressiveSubstrings(String input) {
    List<String> substrings = [];
    for (int i = 1; i <= input.length; i++) {
      substrings.add(input.substring(0, i));
    }
    return substrings;
  }
}
