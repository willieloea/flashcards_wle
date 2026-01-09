import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/deck.dart';
import '../services/markdown_parser.dart';
import 'review_screen.dart';
import 'tag_screen.dart';
import 'settings_screen.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  late Future<List<Deck>> _decksFuture;
  late Future<Directory> _documentsDirectoryFuture;

  @override
  void initState() {
    super.initState();
    _decksFuture = MarkdownParser().parseDecks();
    _documentsDirectoryFuture = getApplicationDocumentsDirectory();
  }

  void _refreshDecks() {
    setState(() {
      _decksFuture = MarkdownParser().parseDecks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TagScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDecks,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_decksFuture, _documentsDirectoryFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data![0] as List<Deck>).isEmpty) {
            final docDir = snapshot.data![1] as Directory;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No decks found.\n\nPlease place your .md flashcard files in:\n${docDir.path}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          } else {
            final decks = snapshot.data![0] as List<Deck>;
            return ListView.builder(
              itemCount: decks.length,
              itemBuilder: (context, index) {
                final deck = decks[index];
                return ListTile(
                  title: Text(deck.name),
                  subtitle: Text('${deck.cards.length} cards'),
                  onTap: () {
                    if (deck.cards.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewScreen(deck: deck),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This deck has no cards.'),
                        ),
                      );
                    }
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
