class InstaPostModel {
  final String id;
  final String username;
  final String location;
  final String avatarUrl;
  final String imageUrl;
  final int likeCount;
  final String caption;
  final List<String> comments;
  final String timeAgo;
  bool isLiked;
  bool isBookmarked;

  InstaPostModel({
    required this.id,
    required this.username,
    required this.location,
    required this.avatarUrl,
    required this.imageUrl,
    required this.likeCount,
    required this.caption,
    required this.comments,
    required this.timeAgo,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  static List<InstaPostModel> staticPosts() => [
        InstaPostModel(
          id: '1',
          username: 'nature_kev',
          location: 'Manali, Himachal Pradesh',
          avatarUrl: 'https://i.pravatar.cc/150?img=7',
          imageUrl: 'https://picsum.photos/seed/nature1/600/600',
          likeCount: 3421,
          caption: 'The mountains never get old 🏔️ #mountains #travel #nature',
          comments: ['Stunning view!', 'I need to visit this place!'],
          timeAgo: '1 hour ago',
        ),
        InstaPostModel(
          id: '2',
          username: 'foodie_rao',
          location: 'Mumbai, Maharashtra',
          avatarUrl: 'https://i.pravatar.cc/150?img=4',
          imageUrl: 'https://picsum.photos/seed/food2/600/600',
          likeCount: 1892,
          caption: 'Best biryani in town 🍛 #foodie #mumbai #biryani',
          comments: ['Looks delicious!', 'Where is this place?'],
          timeAgo: '2 hours ago',
        ),
        InstaPostModel(
          id: '3',
          username: 'sarah_j',
          location: 'Goa, India',
          avatarUrl: 'https://i.pravatar.cc/150?img=1',
          imageUrl: 'https://picsum.photos/seed/beach3/600/600',
          likeCount: 5673,
          caption: 'Golden hour at the beach 🌅 #goa #beach #sunset #vibes',
          comments: ['Paradise!', 'Wish I was there ✨', 'Beautiful!'],
          timeAgo: '3 hours ago',
          isLiked: true,
        ),
        InstaPostModel(
          id: '4',
          username: 'arjun.dev',
          location: 'Bangalore, Karnataka',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          imageUrl: 'https://picsum.photos/seed/city4/600/600',
          likeCount: 987,
          caption: 'City lights and coffee ☕ #bangalore #nightlife #developer',
          comments: ['Classic Bangalore!'],
          timeAgo: '5 hours ago',
        ),
        InstaPostModel(
          id: '5',
          username: 'priya_art',
          location: 'Jaipur, Rajasthan',
          avatarUrl: 'https://i.pravatar.cc/150?img=6',
          imageUrl: 'https://picsum.photos/seed/art5/600/600',
          likeCount: 2341,
          caption: 'Colors of Rajasthan 🎨 #art #jaipur #pinkcity',
          comments: ['So vibrant!', 'Art is everywhere 🎨'],
          timeAgo: '6 hours ago',
        ),
        InstaPostModel(
          id: '6',
          username: 'mike.photo',
          location: 'Kerala, India',
          avatarUrl: 'https://i.pravatar.cc/150?img=2',
          imageUrl: 'https://picsum.photos/seed/kerala6/600/600',
          likeCount: 4102,
          caption: 'Gods own country 🌿 #kerala #backwaters #photography',
          comments: ['Breathtaking!', 'Amazing shot Mike!'],
          timeAgo: '8 hours ago',
          isLiked: true,
        ),
        InstaPostModel(
          id: '7',
          username: 'fitlife_sam',
          location: 'Delhi, India',
          avatarUrl: 'https://i.pravatar.cc/150?img=8',
          imageUrl: 'https://picsum.photos/seed/fitness7/600/600',
          likeCount: 1567,
          caption: 'Morning run done 🏃‍♂️💪 No excuses! #fitness #motivation',
          comments: ['Inspiring!', 'Keep it up!', 'Goals 🔥'],
          timeAgo: '10 hours ago',
        ),
        InstaPostModel(
          id: '8',
          username: 'travel_nina',
          location: 'Ladakh, J&K',
          avatarUrl: 'https://i.pravatar.cc/150?img=3',
          imageUrl: 'https://picsum.photos/seed/ladakh8/600/600',
          likeCount: 7823,
          caption: 'Sky so blue, roads so free 🚗 #ladakh #roadtrip #adventure',
          comments: ['Dream destination!', 'On my bucket list!'],
          timeAgo: '12 hours ago',
        ),
        InstaPostModel(
          id: '9',
          username: 'luna_vibes',
          location: 'Pondicherry, Tamil Nadu',
          avatarUrl: 'https://i.pravatar.cc/150?img=9',
          imageUrl: 'https://picsum.photos/seed/cafe9/600/600',
          likeCount: 3089,
          caption: 'French Quarter mornings ☀️ #pondicherry #cafe #aesthetic',
          comments: ['Such a vibe!', 'Love Pondi!'],
          timeAgo: '1 day ago',
        ),
        InstaPostModel(
          id: '10',
          username: 'nature_kev',
          location: 'Coorg, Karnataka',
          avatarUrl: 'https://i.pravatar.cc/150?img=7',
          imageUrl: 'https://picsum.photos/seed/coffee10/600/600',
          likeCount: 2234,
          caption: 'Coffee estates and misty mornings ☕🌿 #coorg #nature',
          comments: ['So peaceful 🍃'],
          timeAgo: '1 day ago',
        ),
      ];
}
