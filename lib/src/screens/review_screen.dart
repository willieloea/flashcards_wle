import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../widgets/flashcard_widget.dart';

class ReviewScreen extends StatefulWidget {
  final Deck deck;
  final int initialCardIndex;

  const ReviewScreen({
    super.key,
    required this.deck,
    this.initialCardIndex = 0,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialCardIndex;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                '${_currentPage + 1} / ${widget.deck.cards.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.deck.cards.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlashcardWidget(flashcard: widget.deck.cards[index]),
          );
        },
      ),
    );
  }
}
