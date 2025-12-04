import 'dart:collection';

import 'package:first_flutter/data/models/sentence.dart';
import 'package:first_flutter/data/repositories/sentence_repository.dart';
import 'package:flutter/material.dart';

class SentenceVM extends ChangeNotifier {
  final SentenceRepository _sentenceRepository;

  SentenceVM({SentenceRepository? sentenceRepository})
    : _sentenceRepository = sentenceRepository ?? SentenceRepository() {
    _favorites = _sentenceRepository.favorites;
    _history = _sentenceRepository.history;
    _current = _sentenceRepository.current;
  }

  // Internal State
  late Sentence _current;
  List<Sentence> _history = [];
  List<Sentence> _favorites = [];

  // Getters
  Sentence get current => _current;
  UnmodifiableListView<Sentence> get history => UnmodifiableListView(_history);
  UnmodifiableListView<Sentence> get favorites =>
      UnmodifiableListView(_favorites);

  void next() {
    _current = _sentenceRepository.getNext();
    notifyListeners();
  }

  void toggleFavorite(Sentence sentence) {
    _sentenceRepository.toggleFavorite(sentence);
    notifyListeners();
  }

  void toggleCurrentFavorite() {
    toggleFavorite(_current);
  }

  bool isFavorite(Sentence pair) {
    return _sentenceRepository.isFavorite(pair);
  }
}
