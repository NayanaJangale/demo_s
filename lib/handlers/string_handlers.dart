class StringHandlers{
  static const String NotAvailable = 'n/a';

  static String capitalizeWords(String inputString) {
    try {
      String outputString = '';
      inputString =
          inputString.toLowerCase().replaceAll(',', ', ').replaceAll('.', '. ');
      List<String> words = inputString.split(' ');

      for (String word in words) {
        if (word.trim() != '') {
          word = word.trim();
          word = '${word[0].toUpperCase()}${word.substring(1)}';

          if (outputString != '') outputString += ' ';
          outputString += word;
        }
      }

      return outputString.trim();
    } catch (ex) {
      return '';
    }
  }
}