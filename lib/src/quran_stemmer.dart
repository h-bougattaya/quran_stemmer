import 'package:dartarabic/dartarabic.dart';

abstract class Stemmer {
  String stem(String word);
}

class QuranStemmer implements Stemmer {
  // length three prefixes
  final List<String> p3 = [
    "\u0643\u0627\u0644",
    "\u0628\u0627\u0644",
    "\u0648\u0644\u0644",
    "\u0648\u0627\u0644",
  ];

  // length two prefixes
  final List<String> p2 = ["\u0627\u0644", "\u0644\u0644"];

  // length three suffixes
  final List<String> s3 = [
    "\u062a\u0645\u0644",
    "\u0647\u0645\u0644",
    "\u062a\u0627\u0646",
    "\u062a\u064a\u0646",
    "\u0643\u0645\u0644",
  ];

  // length two suffixes
  final List<String> s2 = [
    "\u0648\u0646",
    "\u0627\u062a",
    "\u0627\u0646",
    "\u064a\u0646",
    "\u062a\u0646",
    "\u0643\u0645",
    "\u0647\u0646",
    "\u0646\u0627",
    "\u064a\u0627",
    "\u0647\u0627",
    "\u062a\u0645",
    "\u0643\u0646",
    "\u0646\u064a",
    "\u0648\u0627",
    "\u0645\u0627",
    "\u0647\u0645",
  ];

  // length one suffixes
  final List<String> s1 = [
    "\u0629",
    "\u0647",
    "\u064a",
    "\u0643",
    "\u062a",
    "\u0627",
    "\u0646"
  ];

  // groups of length four patterns
  final List<List<String>> pr4 = [
    ["\u0645"],
    ["\u0627"],
    ["\u0627", "\u0648", "\u064A"],
    ["\u0629"],
  ];

  // Groups of length five patterns and length three roots
  final List<List<String>> pr53 = [
    ["\u0627", "\u062a"],
    ["\u0627", "\u064a", "\u0648"],
    ["\u0627", "\u062a", "\u0645"],
    ["\u0645", "\u064a", "\u062a"],
    ["\u0645", "\u062a"],
    ["\u0627", "\u0648"],
    ["\u0627", "\u0645"],
  ];

  final List stopWords = [
    "\u064a\u0643\u0648\u0646",
    "\u0648\u0644\u064a\u0633",
    "\u0648\u0643\u0627\u0646",
    "\u0643\u0630\u0644\u0643",
    "\u0627\u0644\u062a\u064a",
    "\u0648\u0628\u064a\u0646",
    "\u0639\u0644\u064a\u0647\u0627",
    "\u0645\u0633\u0627\u0621",
    "\u0627\u0644\u0630\u064a",
    "\u0648\u0643\u0627\u0646\u062a",
    "\u0648\u0644\u0643\u0646",
    "\u0648\u0627\u0644\u062a\u064a",
    "\u062a\u0643\u0648\u0646",
    "\u0627\u0644\u064a\u0648\u0645",
    "\u0627\u0644\u0644\u0630\u064a\u0646",
    "\u0639\u0644\u064a\u0647",
    "\u0643\u0627\u0646\u062a",
    "\u0644\u0630\u0644\u0643",
    "\u0623\u0645\u0627\u0645",
    "\u0647\u0646\u0627\u0643",
    "\u0645\u0646\u0647\u0627",
    "\u0645\u0627\u0632\u0627\u0644",
    "\u0644\u0627\u0632\u0627\u0644",
    "\u0644\u0627\u064a\u0632\u0627\u0644",
    "\u0645\u0627\u064a\u0632\u0627\u0644",
    "\u0627\u0635\u0628\u062d",
    "\u0623\u0635\u0628\u062d",
    "\u0623\u0645\u0633\u0649",
    "\u0627\u0645\u0633\u0649",
    "\u0623\u0636\u062d\u0649",
    "\u0627\u0636\u062d\u0649",
    "\u0645\u0627\u0628\u0631\u062d",
    "\u0645\u0627\u0641\u062a\u0626",
    "\u0645\u0627\u0627\u0646\u0641\u0643",
    "\u0644\u0627\u0633\u064a\u0645\u0627",
    "\u0648\u0644\u0627\u064a\u0632\u0627\u0644",
    "\u0627\u0644\u062d\u0627\u0644\u064a",
    "\u0627\u0644\u064a\u0647\u0627",
    "\u0627\u0644\u0630\u064a\u0646",
    "\u0641\u0627\u0646\u0647",
    "\u0648\u0627\u0644\u0630\u064a",
    "\u0648\u0647\u0630\u0627",
    "\u0644\u0647\u0630\u0627",
    "\u0641\u0643\u0627\u0646",
    "\u0633\u062a\u0643\u0648\u0646",
    "\u0627\u0644\u064a\u0647",
    "\u064a\u0645\u0643\u0646",
    "\u0628\u0647\u0630\u0627",
    "\u0627\u0644\u0630\u0649",
  ];

  @override
  String stem(String token) {
    token =
        _norm(token, 1); // remove diacritics representing Arabic short vowels
    token = _norm(token, 2); // remove tatweel
    if (stopWords.contains(token)) {
      return token; // exclude stop words from being processed
    }
    token = _pre32(
        token); // remove length three and length two prefixes in this order
    token = _suf32(
        token); // remove length three and length two suffixes in this order
    token = _waw(
        token); // remove connective ‘و’ if it precedes a word beginning with ‘و’
    token = _norm(token, 3); // normalize initial hamza to bare alif

    // Stemming based on word length
    if (token.length == 4) {
      token = _proW4(token);
    } else if (token.length == 5) {
      token = _proW53(token);
      token = _endW5(token);
    } else if (token.length == 6) {
      token = _proW6(token);
      token = _endW6(token);
    } else if (token.length == 7) {
      token = _suf1(token);
      if (token.length == 7) {
        token = _pre1(token);
      }
      if (token.length == 6) {
        token = _proW6(token);
        token = _endW6(token);
      }
    }

    return token;
  }

  String _norm(String word, int num) {
    // Normalization:
    // num=1  normalize diacritics
    // num=2  normalize tatweel
    // num=3  normalize initial hamza
    // num=4  all 1&2&3
    if (num == 1) {
      word = DartArabic.stripDiacritics(word);
    } else if (num == 2) {
      word = DartArabic.stripTatweel(word);
    } else if (num == 3) {
      word = DartArabic.normalizeHamzaTasheel(word);
    } else if (num == 4) {
      word = DartArabic.stripDiacritics(word);
      word = DartArabic.stripTatweel(word);
      word = DartArabic.normalizeHamzaTasheel(word);
    }
    return word;
  }

  String _pre32(String word) {
    // Remove length three and length two prefixes in this order
    if (word.length >= 6) {
      for (var pre3 in p3) {
        if (word.startsWith(pre3)) {
          return word.substring(3);
        }
      }
    }
    if (word.length >= 5) {
      for (var pre2 in p2) {
        if (word.startsWith(pre2)) {
          return word.substring(2);
        }
      }
    }
    return word;
  }

  String _suf32(String word) {
    // Remove length three and length two suffixes in this order
    if (word.length >= 6) {
      for (var suf3 in s3) {
        if (word.endsWith(suf3)) {
          return word.substring(0, word.length - 3);
        }
      }
    }
    if (word.length >= 5) {
      for (var suf2 in s2) {
        if (word.endsWith(suf2)) {
          return word.substring(0, word.length - 2);
        }
      }
    }
    return word;
  }

  String _waw(String word) {
    // Remove connective ‘و’ if it precedes a word beginning with ‘و’
    if (word.length >= 5) {
      if (word.startsWith('\u0648')) {
        var nextChar = word[1];
        if (nextChar == '\u0648' || nextChar == '\u0627') {
          return word.substring(1);
        }
      }
    }
    return word;
  }

  String _proW4(String word) {
    // Process length four patterns and extract length three stem
    for (var pr in pr4) {
      if (word.endsWith(pr[0])) {
        return word.substring(0, word.length - 1);
      }
    }
    return word;
  }

  String _proW53(String word) {
    // Process length five patterns and extract length three stem
    for (var pr in pr53) {
      if (word.endsWith(pr[0])) {
        return word.substring(0, word.length - 2);
      }
      if (word.endsWith(pr[1])) {
        return word.substring(0, word.length - 1);
      }
    }
    return word;
  }

  String _endW5(String word) {
    // Remove length two suffixes and length one suffixes
    if (word.length >= 5) {
      if (word.endsWith(s1[0])) {
        return word.substring(0, word.length - 1);
      }
    }
    return word;
  }

  String _proW6(String word) {
    // Process length six patterns and extract length four stem
    if (word[4] == '\u0646') {
      return word.substring(0, 4) + word.substring(5);
    }
    return word;
  }

  String _endW6(String word) {
    // Remove length two suffixes and length one suffixes
    if (word.length >= 6) {
      if (word.endsWith(s1[0])) {
        return word.substring(0, word.length - 1);
      }
    }
    return word;
  }

  String _suf1(String word) {
    // Remove length one suffixes
    if (word.length >= 7) {
      for (var suf in s1) {
        if (word.endsWith(suf)) {
          return word.substring(0, word.length - 1);
        }
      }
    }
    return word;
  }

  String _pre1(String word) {
    // Remove length one prefixes
    if (word.length >= 7) {
      for (var pre in s1) {
        if (word.startsWith(pre)) {
          return word.substring(1);
        }
      }
    }
    return word;
  }
}
