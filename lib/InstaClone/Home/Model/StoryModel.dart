class StoryModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String storyImageUrl;
  final bool isOwn;
  final bool hasNewStory;

  const StoryModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.storyImageUrl,
    this.isOwn = false,
    this.hasNewStory = true,
  });

  static List<StoryModel> staticStories() => const [
        StoryModel(
          id: '0',
          username: 'Your story',
          avatarUrl: 'https://i.pravatar.cc/150?img=10',
          storyImageUrl: 'https://picsum.photos/seed/s_own/400/700',
          isOwn: true,
          hasNewStory: false,
        ),
        StoryModel(
          id: '1',
          username: 'sarah_j',
          avatarUrl: 'https://i.pravatar.cc/150?img=1',
          storyImageUrl: 'https://picsum.photos/seed/s_sarah/400/700',
        ),
        StoryModel(
          id: '2',
          username: 'mike.photo',
          avatarUrl: 'https://i.pravatar.cc/150?img=2',
          storyImageUrl: 'https://picsum.photos/seed/s_mike/400/700',
        ),
        StoryModel(
          id: '3',
          username: 'travel_nina',
          avatarUrl: 'https://i.pravatar.cc/150?img=3',
          storyImageUrl: 'https://picsum.photos/seed/s_nina/400/700',
        ),
        StoryModel(
          id: '4',
          username: 'foodie_rao',
          avatarUrl: 'https://i.pravatar.cc/150?img=4',
          storyImageUrl: 'https://picsum.photos/seed/s_rao/400/700',
        ),
        StoryModel(
          id: '5',
          username: 'arjun.dev',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          storyImageUrl: 'https://picsum.photos/seed/s_arjun/400/700',
        ),
        StoryModel(
          id: '6',
          username: 'priya_art',
          avatarUrl: 'https://i.pravatar.cc/150?img=6',
          storyImageUrl: 'https://picsum.photos/seed/s_priya/400/700',
        ),
        StoryModel(
          id: '7',
          username: 'nature_kev',
          avatarUrl: 'https://i.pravatar.cc/150?img=7',
          storyImageUrl: 'https://picsum.photos/seed/s_kev/400/700',
        ),
        StoryModel(
          id: '8',
          username: 'fitlife_sam',
          avatarUrl: 'https://i.pravatar.cc/150?img=8',
          storyImageUrl: 'https://picsum.photos/seed/s_sam/400/700',
        ),
        StoryModel(
          id: '9',
          username: 'luna_vibes',
          avatarUrl: 'https://i.pravatar.cc/150?img=9',
          storyImageUrl: 'https://picsum.photos/seed/s_luna/400/700',
        ),
      ];
}
