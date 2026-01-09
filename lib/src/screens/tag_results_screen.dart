import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import 'review_screen.dart';

class TagResultsScreen extends StatelessWidget {
  final String tag;
  final List<Deck> decks;

  const TagResultsScreen({super.key, required this.tag, required this.decks});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> taggedCards = [];
    for (var deck in decks) {
      for (var card in deck.cards) {
        if (card.tags.contains(tag)) {
          taggedCards.add({'deck': deck, 'card': card});
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cards tagged with #$tag'),
      ),
      body: ListView.builder(
        itemCount: taggedCards.length,
        itemBuilder: (context, index) {
          final Deck deck = taggedCards[index]['deck'];
          final Flashcard card = taggedCards[index]['card'];
          return ListTile(
            title: Text(card.front),
            subtitle: Text('in ${deck.name}'),
            onTap: () {
              final initialIndex = deck.cards.indexOf(card);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(
                    deck: deck,
                    initialCardIndex: initialIndex,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
