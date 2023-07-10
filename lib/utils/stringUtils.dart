
class StringUtils {

  static String breakWord(String text) {
    if(text == null){
      return '';
    }
    if (text.isEmpty) {
      return text;
    }

    String breakWord = ' ';
    text.runes.forEach((element) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    });
    return breakWord;
  }

}