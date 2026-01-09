import 'flashcard.dart';

class Deck {
  final String name;
  final List<Flashcard> cards;

  Deck({
    required this.name,
    this.cards = const [],
  });
}
