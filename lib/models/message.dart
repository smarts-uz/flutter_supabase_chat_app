class Message {
  Message({
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    required this.roomId,
    required this.isMine,
  });

  /// ID of the message
  final String id;

  /// ID of the user who posted the message
  final String profileId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime createdAt;

  final String roomId;

  /// Whether the message is sent by the user or not.
  final bool isMine;

  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'],
        profileId = map['profile_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']),
        roomId = map['room_id'],
        isMine = myUserId == map['profile_id'];

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profileId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'room_id': roomId,
    };
  }
}
