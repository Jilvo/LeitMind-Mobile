class Question {
  final int id;
  final String text;
  final String? imageUrl;

  Question({required this.id, required this.text, this.imageUrl});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      imageUrl: json['image_path'],
    );
  }
}
