class ShareContent {
  final String sessionId;
  final String title;
  final List<String> messageIds;
  final DateTime sharedAt;

  ShareContent({
    required this.sessionId,
    required this.title,
    required this.messageIds,
    required this.sharedAt,
  });

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'title': title,
    'messageIds': messageIds,
    'sharedAt': sharedAt.toIso8601String(),
  };

  factory ShareContent.fromJson(Map<String, dynamic> json) => ShareContent(
    sessionId: json['sessionId'] as String,
    title: json['title'] as String,
    messageIds: (json['messageIds'] as List).cast<String>(),
    sharedAt: DateTime.parse(json['sharedAt'] as String),
  );
}