import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardWidget({super.key, required this.flashcard});

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _isFlipped = false;

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final frontWidget = _buildCardSide(content: widget.flashcard.front, isFront: true);
    final backWidget = _buildCardSide(content: widget.flashcard.back, isFront: false);

    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: 3.14, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(_isFlipped) != child!.key);
              var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
              tilt *= isUnder ? -1.0 : 1.0;
              final value = isUnder ? rotateAnim.value < 3.14 / 2 ? 1.0 : rotateAnim.value : rotateAnim.value;
              return Transform(
                transform: Matrix4.rotationY(value),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: _isFlipped ? backWidget : frontWidget,
        key: ValueKey(_isFlipped),
      ),
    );
  }

  Widget _buildCardSide({required String content, required bool isFront}) {
    return Card(
      key: ValueKey(content),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Markdown(
                data: content,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                builders: {
                  'tex': TeXViewMarkdownElementBuilder(),
                },
              ),
              if (!isFront && widget.flashcard.tags.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: widget.flashcard.tags
                      .map((tag) => Chip(label: Text('#$tag')))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TeXViewMarkdownElementBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(element, style) {
    final text = element.text;
    if (text.startsWith('S S') && text.endsWith('S S')) {
      final formula = text.substring(3, text.length - 3);
      return Math.tex(
        formula,
        textStyle: style,
      );
    }
    if (text.startsWith('S') && text.endsWith('S')) {
      final formula = text.substring(1, text.length - 1);
      return Math.tex(
        formula,
        textStyle: style,
      );
    }
    return Text(text, style: style);
  }
}
