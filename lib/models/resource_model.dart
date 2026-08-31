enum ResourceType { pdf, image, link, note }

class Resource {
  final String id;
  final String userId;
  final String? goalId;
  final String? milestoneId;

  final ResourceType type;
  final String title;
  final String category;

  final String? fileUrl;
  final int? fileSizeBytes;
  final String? linkUrl;
  final String? noteContent;

  final List<String> relatedTaskIds;

  final DateTime createdAt;

  Resource({
    required this.id,
    required this.userId,
    this.goalId,
    this.milestoneId,
    required this.type,
    required this.title,
    required this.category,
    this.fileUrl,
    this.fileSizeBytes,
    this.linkUrl,
    this.noteContent,
    this.relatedTaskIds = const [],
    required this.createdAt,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as String,
      userId: json['userId'] as String,
      goalId: json['goalId'] as String?,
      milestoneId: json['milestoneId'] as String?,
      type: ResourceType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => ResourceType.note,
      ),
      title: json['title'] as String,
      category: json['category'] as String,
      fileUrl: json['fileUrl'] as String?,
      fileSizeBytes: json['fileSizeBytes'] as int?,
      linkUrl: json['linkUrl'] as String?,
      noteContent: json['noteContent'] as String?,
      relatedTaskIds: (json['relatedTaskIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'goalId': goalId,
      'milestoneId': milestoneId,
      'type': type.name,
      'title': title,
      'category': category,
      'fileUrl': fileUrl,
      'fileSizeBytes': fileSizeBytes,
      'linkUrl': linkUrl,
      'noteContent': noteContent,
      'relatedTaskIds': relatedTaskIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}