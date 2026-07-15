class Memo {
  final String title;
  final String content;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;

  Memo({
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 編集用
  Memo copyWith({
    String? title,
    String? content,
  }) {
    return Memo(
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// JSON → Memo
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Memo → JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}