import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/ReelModel.dart';

class ReelRepository {
  final _collection = FirebaseFirestore.instance.collection('reels');

  static const _seedReels = [
    {
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'username': 'fire_vibes',
      'caption': 'Living for those blazing sunsets 🔥 #vibes #sunset',
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'likeCount': 1842,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'username': 'travel_escape',
      'caption': 'Escaping the ordinary every single day ✈️ #travel #adventure',
      'avatarUrl': 'https://i.pravatar.cc/150?img=12',
      'likeCount': 3210,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'username': 'funtime_daily',
      'caption': 'When weekends hit different 😂🎉 #fun #weekend #reels',
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
      'likeCount': 5670,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      'username': 'road_tripper',
      'caption': 'Not all those who wander are lost 🚗🛣️ #roadtrip #joyride',
      'avatarUrl': 'https://i.pravatar.cc/150?img=14',
      'likeCount': 2987,
      'likedBy': <String>[],
      'comments': <Map<String, dynamic>>[],
    },
    {
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      'username': 'drama_queen99',
      'caption': 'Monday mornings be like 😩☕ #relatable #monday #meltdown',
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
