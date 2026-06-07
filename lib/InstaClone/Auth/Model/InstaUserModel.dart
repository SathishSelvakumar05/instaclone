class InstaUserModel {
  final String uid;
  final String email;
  final String username;
  final String createdAt;

  const InstaUserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'username': username,
        'createdAt': createdAt,
      };

  factory InstaUserModel.fromFirestore(String uid, Map<String, dynamic> data) =>
      InstaUserModel(
        uid: uid,
        email: data['email'] as String,
        username: data['username'] as String,
        createdAt: data['createdAt'] as String,
      );
}
