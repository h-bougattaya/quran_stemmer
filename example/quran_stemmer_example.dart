import 'package:quran_stemmer/quran_stemmer.dart';

void main() {
  var quranStemmer = QuranStemmer();
  print(
      'stem basmallah: ${quranStemmer.stem("بِسْم ٱللّٰهِِ ٱلرَّحْمٰنِ ِِٱلرَّحِيمِ")}');
}
