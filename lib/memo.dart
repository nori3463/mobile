class Memo {
  final String title;
  final String content;

  Memo({
    required this.title,
    required this.content,
  });

  // JSON → Memo
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  // Memo → JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
