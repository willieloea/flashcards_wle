
class Flashcard {
  final String front;
  final String back;
  final List<String> tags;

  Flashcard({
    required this.front,
    required this.back,
    this.tags = const [],
  });
}
