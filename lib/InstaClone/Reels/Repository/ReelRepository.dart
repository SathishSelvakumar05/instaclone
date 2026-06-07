import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/ReelModel.dart';

class ReelRepository {
  final _collection = FirebaseFirestore.instance.collection('reels');

  static const _seedReels = [
    {
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'username': 'nature_vibes',
      'caption': 'Beautiful bee in action 🐝',
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'likeCount': 1842,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
      'username': 'video_sample',
      'caption': 'Quick sample reel 🎬',
      'avatarUrl': 'https://i.pravatar.cc/150?img=12',
      'likeCount': 3210,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
      'username': 'travel_world',
      'caption': 'Adventure starts here ✈️',
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
      'likeCount': 5670,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://samplelib.com/lib/preview/mp4/sample-15s.mp4',
      'username': 'road_trip',
      'caption': 'Road trip memories 🚗',
      'avatarUrl': 'https://i.pravatar.cc/150?img=14',
      'likeCount': 2987,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://samplelib.com/lib/preview/mp4/sample-20s.mp4',
      'username': 'daily_life',
      'caption': 'Just another day ✨',
      'avatarUrl': 'https://i.pravatar.cc/150?img=15',
      'likeCount': 9123,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
  ];

  Future<List<ReelModel>> loadReels() async {
    final snapshot = await _collection.orderBy('likeCount', descending: true).get();

    if (snapshot.docs.isEmpty) {
      await _seedData();
      return loadReels();
    }

    return snapshot.docs
        .map((doc) => ReelModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> _seedData() async {
    final batch = FirebaseFirestore.instance.batch();
    for (final reel in _seedReels) {
      batch.set(_collection.doc(), reel);
    }
    await batch.commit();
  }

  Future<ReelModel> toggleLike(String reelId, String userId) async {
    final doc = _collection.doc(reelId);
    final snapshot = await doc.get();
    final data = snapshot.data()!;
    final likedBy = List<String>.from(data['likedBy'] as List? ?? []);
    final isLiked = likedBy.contains(userId);

    if (isLiked) {
      likedBy.remove(userId);
    } else {
      likedBy.add(userId);
    }

    final newCount = likedBy.length;
    await doc.update({'likedBy': likedBy, 'likeCount': newCount});

    return ReelModel.fromFirestore(
      {...data, 'likedBy': likedBy, 'likeCount': newCount},
      reelId,
    );
  }

  Future<ReelModel> addComment({
    required String reelId,
    required String userId,
    required String username,
    required String text,
  }) async {
    final doc = _collection.doc(reelId);
    final snapshot = await doc.get();
    final data = snapshot.data()!;
    final comments = List<Map<String, dynamic>>.from(
      (data['comments'] as List? ?? []).map((c) => Map<String, dynamic>.from(c as Map)),
    );

    final newComment = {
      'userId': userId,
      'username': username,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    };
    comments.add(newComment);

    await doc.update({'comments': comments});
    return ReelModel.fromFirestore({...data, 'comments': comments}, reelId);
  }
}
