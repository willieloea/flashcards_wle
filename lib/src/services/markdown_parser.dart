import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';

class MarkdownParser {
  Future<List<Deck>> parseDecks() async {
    final List<Deck> decks = [];
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().where((item) => item.path.endsWith('.md'));

    for (var file in files) {
      if (file is File) {
        final content = await file.readAsString();
        final deckName = p.basenameWithoutExtension(file.path);
        final cards = _parseCards(content);
        if (cards.isNotEmpty) {
          decks.add(Deck(name: deckName, cards: cards));
        }
      }
    }
    return decks;
  }

  List<Flashcard> _parseCards(String content) {
    final List<Flashcard> cards = [];
    final cardBlocks = content.split(RegExp(r'^\s*---\s*$', multiLine: true));

    for (var block in cardBlocks) {
      if (block.trim().isEmpty) continue;

      final lines = block.trim().split('\n');
      final front = lines.first.trim();
      var back = '';
      List<String> tags = [];

      if (lines.length > 1) {
        final backLines = lines.sublist(1);
        final tagLineIndex = backLines.indexWhere((line) => line.trim().startsWith('tags:'));

        if (tagLineIndex != -1) {
          final tagLine = backLines[tagLineIndex].trim();
          tags = tagLine.replaceFirst('tags:', '').split(',').map((t) => t.trim()).toList();
          back = backLines.sublist(0, tagLineIndex).join('\n').trim();
        } else {
          back = backLines.join('\n').trim();
        }
      }
      
      if (front.isNotEmpty) {
        cards.add(Flashcard(front: front, back: back, tags: tags));
      }
    }
    return cards;
  }
}
