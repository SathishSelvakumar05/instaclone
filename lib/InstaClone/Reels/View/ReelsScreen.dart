import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../Auth/Model/InstaUserModel.dart';
import '../Cubit/ReelCubit.dart';
import '../Cubit/ReelState.dart';
import '../Model/ReelModel.dart';
import 'Widgets/ReelVideoItem.dart';

class ReelsScreen extends StatefulWidget {
  final InstaUserModel currentUser;

  const ReelsScreen({super.key, required this.currentUser});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final _pageController = PageController();
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    context.read<ReelCubit>().loadReels();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    for (final c in _controllers.values) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<VideoPlayerController> _initController(String url, int index) async {
    if (_controllers.containsKey(index)) return _controllers[index]!;
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controllers[index] = controller;
    await controller.initialize();
    controller.setLooping(true);
    if (index == _currentPage) controller.play();
    return controller;
  }

  void _onPageChanged(int index, List<ReelModel> reels) {
    _controllers[_currentPage]?.pause();
    setState(() => _currentPage = index);
    _controllers[index]?.play();

    final next = index + 1;
    if (next < reels.length && !_controllers.containsKey(next)) {
      _initController(reels[next].videoUrl, next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<ReelCubit, ReelState>(
        builder: (context, state) {
          if (state is ReelLoading || state is ReelInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is ReelFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message,
                      style: const TextStyle(color: Colors.white)),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<ReelCubit>().loadReels(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final reels = state is ReelLoaded
              ? state.reels
              : (state as ReelActionInProgress).reels;

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: reels.length,
                onPageChanged: (i) => _onPageChanged(i, reels),
                itemBuilder: (_, i) {
                  return FutureBuilder<VideoPlayerController>(
                    future: _initController(reels[i].videoUrl, i),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      return ReelVideoItem(
                        reel: reels[i],
                        controller: snapshot.data!,
                        isActive: i == _currentPage,
                        currentUserId: widget.currentUser.uid,
                        currentUsername: widget.currentUser.username,
                        onLikeTap: () => context.read<ReelCubit>().toggleLike(
                              reels[i].id,
                              widget.currentUser.uid,
                            ),
                        onComment: (text) => context.read<ReelCubit>().addComment(
                              reelId: reels[i].id,
                              userId: widget.currentUser.uid,
                              username: widget.currentUser.username,
                              text: text,
                            ),
                      );
                    },
                  );
                },
              ),
              _buildTopBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              ),
              SizedBox(width: 16.w),
              Text(
                'Reels',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              const Spacer(),
              Icon(Icons.camera_alt_outlined, color: Colors.white, size: 26.sp),
            ],
          ),
        ),
      ),
    );
  }
}
