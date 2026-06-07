import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Auth/Model/InstaUserModel.dart';
import '../../Reels/Cubit/ReelCubit.dart';
import '../../Auth/View/InstaLoginScreen.dart';
import '../../Reels/View/ReelsScreen.dart';
import '../Model/InstaPostModel.dart';
import '../Model/StoryModel.dart';
import 'StoryViewerScreen.dart';
import 'Widgets/PostWidget.dart';
import 'Widgets/StoryWidget.dart';

class InstaHomeScreen extends StatefulWidget {
  final InstaUserModel user;

  const InstaHomeScreen({super.key, required this.user});

  @override
  State<InstaHomeScreen> createState() => _InstaHomeScreenState();
}

class _InstaHomeScreenState extends State<InstaHomeScreen> {
  int _selectedIndex = 0;
  final List<StoryModel> _stories = StoryModel.staticStories();
  final List<InstaPostModel> _posts = InstaPostModel.staticPosts();

  void _onNavTap(int index) {
    if (index == 2) {
      _showAddPostDialog();
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ReelCubit>(),
            child: ReelsScreen(currentUser: widget.user),
          ),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void _openStoryViewer(int storyListIndex) {
    final viewable = _stories.where((s) => !s.isOwn).toList();
    final viewerIndex = (storyListIndex - 1).clamp(0, viewable.length - 1);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => StoryViewerScreen(
          stories: viewable,
          initialIndex: viewerIndex,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: const Text('New Post', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogOption(Icons.photo_library_outlined, 'Choose from gallery'),
            _dialogOption(Icons.camera_alt_outlined, 'Take a photo'),
            _dialogOption(Icons.videocam_outlined, 'Record a video'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _dialogOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0095F6)),
      title: Text(label),
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex == 4 ? 2 : _selectedIndex > 3 ? 0 : _selectedIndex,
        children: [
          _buildFeedTab(),
          _buildSearchTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFeedTab() {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Text(
                  'Instagram',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Divider(height: 1.h, color: Colors.grey[200]),
          ),
        ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildStoriesSection()),
          SliverToBoxAdapter(child: Divider(height: 1.h, color: Colors.grey[200])),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => PostWidget(post: _posts[i]),
              childCount: _posts.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return SizedBox(
      height: 104.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        itemCount: _stories.length,
        itemBuilder: (_, i) => StoryWidget(
          story: _stories[i],
          onTap: _stories[i].isOwn
              ? _showAddPostDialog
              : () => _openStoryViewer(i),
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(2.w),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: 30,
        itemBuilder: (_, i) => Image.network(
          'https://picsum.photos/seed/${i + 20}/200/200',
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Container(color: Colors.grey[200]),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.user.username,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.black),
            onPressed: _showAddPostDialog,
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => _showLogoutSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=10'),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statColumn('0', 'Posts'),
                        _statColumn('0', 'Followers'),
                        _statColumn('0', 'Following'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Welcome to InstaClone 👋',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Icon(Icons.person_add_outlined, size: 18.sp, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Divider(height: 1.h, color: Colors.grey[200]),
            SizedBox(height: 60.h),
            Center(
              child: Column(
                children: [
                  Icon(Icons.camera_alt_outlined, size: 48.sp, color: Colors.grey[400]),
                  SizedBox(height: 8.h),
                  Text(
                    'No Posts Yet',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black87,
      backgroundColor: Colors.white,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            size: 28.sp,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _selectedIndex == 1 ? Icons.search : Icons.search,
            size: 28.sp,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined, size: 28.sp),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_collection_outlined, size: 28.sp),
          label: 'Reels',
        ),
        BottomNavigationBarItem(
          icon: _selectedIndex == 4
              ? CircleAvatar(
                  radius: 14.r,
                  backgroundImage:
                      const NetworkImage('https://i.pravatar.cc/150?img=10'),
                )
              : CircleAvatar(
                  radius: 14.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      const NetworkImage('https://i.pravatar.cc/150?img=10'),
                ),
          label: 'Profile',
        ),
      ],
    );
  }

  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const InstaLoginScreen()),
                  (_) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
