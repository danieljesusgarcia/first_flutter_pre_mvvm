//lib/data/services/sentence_service.dart
import 'package:english_words/english_words.dart';
import 'package:first_flutter/data/models/sentence.dart';

class SentenceService {
 Sentence getNext() {
   return Sentence(text: WordPair.random().asString);
 }
}