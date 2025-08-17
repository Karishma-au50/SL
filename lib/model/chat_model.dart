class ChatAnswer {
  final String label;
  final String nextId;

  ChatAnswer({
    required this.label,
    required this.nextId,
  });

  factory ChatAnswer.fromJson(Map<String, dynamic> json) {
    return ChatAnswer(
      label: json['label'] ?? '',
      nextId: json['nextId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'nextId': nextId,
    };
  }
}

class ChatModel {
  final String id;
  final String? question;
  final String? answer;
  final List<ChatAnswer> answers;
  final bool isActive;
  final int updatedAt;
  final bool isDeleted;
  final dynamic deletedAt;
  final dynamic deletedBy;
  final int createdAt;
  final int v;

  ChatModel({
    required this.id,
    this.question,
    this.answer,
    required this.answers,
    required this.isActive,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
    this.deletedBy,
    required this.createdAt,
    required this.v,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      question: json['question'],
      answer: json['answer'],
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => ChatAnswer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isActive: json['isActive'] ?? false,
      updatedAt: json['updatedAt'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      deletedBy: json['deletedBy'],
      createdAt: json['createdAt'] ?? 0,
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'answer': answer,
      'answers': answers.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'updatedAt': updatedAt,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
      'deletedBy': deletedBy,
      'createdAt': createdAt,
      '__v': v,
    };
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, question: $question, answer: $answer, answers: $answers)';
  }
}

class ChatPagination {
  final int currentPage;
  final int totalPages;
  final int totalChats;
  final bool hasNextPage;
  final bool hasPrevPage;

  ChatPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalChats,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory ChatPagination.fromJson(Map<String, dynamic> json) {
    return ChatPagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalChats: json['totalChats'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalChats': totalChats,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}

class ChatResponseModel {
  final List<ChatModel> chats;
  final ChatPagination pagination;

  ChatResponseModel({
    required this.chats,
    required this.pagination,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      chats: (json['chats'] as List<dynamic>?)
              ?.map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: ChatPagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chats': chats.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
