import 'package:flutter/material.dart';
import 'src/screens/deck_list_screen.dart';

void main() {
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markdown Flashcards',
      theme: ThemeData.dark(useMaterial3: true),
      home: const DeckListScreen(),
    );
  }
}
