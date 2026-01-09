import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../services/markdown_parser.dart';
import 'tag_results_screen.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  late Future<List<Deck>> _decksFuture;

  @override
  void initState() {
    super.initState();
    _decksFuture = MarkdownParser().parseDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tags'),
      ),
      body: FutureBuilder<List<Deck>>(
        future: _decksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tags found.'));
          } else {
            final decks = snapshot.data!;
            final allTags = decks
                .expand((deck) => deck.cards)
                .expand((card) => card.tags)
                .toSet()
                .toList();
            allTags.sort();

            if (allTags.isEmpty) {
              return const Center(child: Text('No tags found.'));
            }

            return ListView.builder(
              itemCount: allTags.length,
              itemBuilder: (context, index) {
                final tag = allTags[index];
                return ListTile(
                  title: Text('#$tag'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TagResultsScreen(
                          tag: tag,
                          decks: decks,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
