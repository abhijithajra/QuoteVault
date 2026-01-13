class Quote {
  final String id;
  final String text;
  final String author;
  final String category;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
  });

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as String,
      text: map['text'] ?? '',
      author: map['author'] ?? '',
      category: map['category'] ?? '',
    );
  }

  // For direct API or JSON use
  factory Quote.fromJson(Map<String, dynamic> json) =>
      Quote.fromMap(json);
}
