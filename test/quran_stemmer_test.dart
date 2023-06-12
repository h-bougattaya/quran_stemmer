import 'package:quran_stemmer/quran_stemmer.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final quranStemmer = QuranStemmer();

    setUp(() {
      // Additional setup goes here.
    });

    test('Stem test', () {
      expect(quranStemmer.stem("بِسْم ٱللّٰهِِ ٱلرَّحْمٰنِ ِِٱلرَّحِيمِ"),
          "بسم ٱلله ٱلرحمن ٱلرحيم");
      expect(quranStemmer.stem("العـــــربيةُ"), "عربي");
      expect(quranStemmer.stem("جاء سؤال الأئمة عن الإسلام آجلا"),
          "جاء سوال الايمة عن الاسلام اجلا");
    });
  });
}
