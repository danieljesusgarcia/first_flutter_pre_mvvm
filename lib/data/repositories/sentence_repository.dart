import 'package:first_flutter/data/models/sentence.dart';
import 'package:first_flutter/data/services/sentence_service.dart';

class SentenceRepository {
  SentenceRepository({SentenceService? sentenceService})
    : _sentenceService = sentenceService ?? SentenceService();

  // ↓ Add the code below.
  late var _current = _sentenceService.getNext();
  var _favorites = <Sentence>[];

  // History of all generated word pairs.
  var _history = <Sentence>[];

  Sentence get current => _current;
  List<Sentence> get history => _history;
  List<Sentence> get favorites => _favorites;

  final SentenceService _sentenceService;

 Sentence getNext() {
   _history.insert(0, _current);
   _current = _sentenceService.getNext();
   return _current;
 }

 void toggleFavorite(Sentence sentence) {
   if (_favorites.contains(sentence)) {
     _favorites.remove(sentence);
   } else {
     _favorites.add(sentence);
   }
 } 

 bool isFavorite(Sentence pair) {
   return _favorites.contains(pair);
 } 
}
