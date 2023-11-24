class Todo {
  String id; // Unique ID
  String content; // todo item

  Todo({
    required this.id,
    required this.content,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as String,
        content: json['content'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
      };
}
