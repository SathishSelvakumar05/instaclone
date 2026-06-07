class ReelComment {
  final String userId;
  final String username;
  final String text;
  final String timestamp;

  const ReelComment({
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  factory ReelComment.fromMap(Map<String, dynamic> map) => ReelComment(
        userId: map['userId'] as String? ?? '',
        username: map['username'] as String? ?? '',
        text: map['text'] as String? ?? '',
        timestamp: map['timestamp'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'username': username,
        'text': text,
        'timestamp': timestamp,
      };
}

class ReelModel {
  final String id;
  final String videoUrl;
  final String username;
  final String caption;
  final String avatarUrl;
  int likeCount;
  List<String> likedBy;
  List<ReelComment> comments;

  ReelModel({
    required this.id,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.avatarUrl,
    this.likeCount = 0,
    List<String>? likedBy,
    List<ReelComment>? comments,
  })  : likedBy = likedBy ?? [],
        comments = comments ?? [];

  factory ReelModel.fromFirestore(Map<String, dynamic> data, String docId) => ReelModel(
        id: docId,
        videoUrl: data['videoUrl'] as String? ?? '',
        username: data['username'] as String? ?? '',
        caption: data['caption'] as String? ?? '',
        avatarUrl: data['avatarUrl'] as String? ?? '',
        likeCount: (data['likeCount'] as num?)?.toInt() ?? 0,
        likedBy: List<String>.from(data['likedBy'] as List? ?? []),
        comments: (data['comments'] as List? ?? [])
            .map((c) => ReelComment.fromMap(c as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toFirestore() => {
        'videoUrl': videoUrl,
        'username': username,
        'caption': caption,
        'avatarUrl': avatarUrl,
        'likeCount': likeCount,
        'likedBy': likedBy,
        'comments': comments.map((c) => c.toMap()).toList(),
      };

  ReelModel copyWith({
    int? likeCount,
    List<String>? likedBy,
    List<ReelComment>? comments,
  }) =>
      ReelModel(
        id: id,
        videoUrl: videoUrl,
        username: username,
        caption: caption,
        avatarUrl: avatarUrl,
        likeCount: likeCount ?? this.likeCount,
        likedBy: likedBy ?? List.from(this.likedBy),
        comments: comments ?? List.from(this.comments),
      );
}
