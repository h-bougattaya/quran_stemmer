# Quran Stemmer

The Quran Stemmer is an implementation of the ISRI Stemmer algorithm for the Arabic language. The stemmer is specifically designed to process Quranic Arabic text by reducing words to their root forms, enabling various text analysis tasks such as information retrieval, text mining, and natural language processing.

## Features

- Implements the ISRI Stemmer algorithm for Arabic text stemming.
- Handles diacritics representing Arabic short vowels and normalizes initial hamza.
- Supports the removal of stop words from the stemming process.
- Provides pattern-based rules for processing length three prefixes, length two prefixes, length three suffixes, length two suffixes, and length one suffixes.
- Includes special handling for connective 'و' if it precedes a word beginning with 'و'.
- Accommodates length-specific stemming rules for words of different lengths.
- Designed for the processing of Quranic Arabic text.

## Usage

1. Instantiate the `QuranStemmer` class.
2. Call the `stem` method with an Arabic word as input to obtain its stem.

```dart
QuranStemmer stemmer = QuranStemmer();
String word = 'العـــــربيةُ';
String stem = stemmer.stem(word);
print(stem); // Output: عربي
```


#License
This project is licensed under the BSD 3-Clause License.

