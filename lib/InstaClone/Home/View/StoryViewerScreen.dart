import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Model/StoryModel.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    required this.initialIndex,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _goNext();
      })
      ..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _goNext() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
        _progressController
          ..reset()
          ..forward();
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _goPrev() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _progressController
          ..reset()
          ..forward();
      });
    } else {
      _progressController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final safeTop = MediaQuery.of(context).padding.top;
    // Tap zones start below: safe area top + progress bar row + user info row ≈ 90dp
    final tapZoneTop = safeTop + 90.h;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Story image with crossfade transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Image.network(
              story.storyImageUrl,
              key: ValueKey(story.id),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[850],
                child: const Center(
                  child: Icon(Icons.image_not_supported,
                      color: Colors.white54, size: 48),
                ),
              ),
            ),
          ),

          // Top gradient for header readability
          Container(
            height: tapZoneTop + 20,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),

          // Bottom gradient for future use
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80.h,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black38, Colors.transparent],
                ),
              ),
            ),
          ),

          // Left tap zone — goes to previous story (below header)
          Positioned(
            top: tapZoneTop,
            left: 0,
            bottom: 0,
            width: screenWidth / 2,
            child: GestureDetector(
              onTap: _goPrev,
              onLongPressStart: (_) => _progressController.stop(),
              onLongPressEnd: (_) => _progressController.forward(),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),

          // Right tap zone — goes to next story (below header)
          Positioned(
            top: tapZoneTop,
            right: 0,
            bottom: 0,
            width: screenWidth / 2,
            child: GestureDetector(
              onTap: _goNext,
              onLongPressStart: (_) => _progressController.stop(),
              onLongPressEnd: (_) => _progressController.forward(),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),

          // Header: progress bars + user info (topmost layer)
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bars
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (_, __) => Row(
                      children: List.generate(widget.stories.length, (i) {
                        final double value = i < _currentIndex
                            ? 1.0
                            : i == _currentIndex
                                ? _progressController.value
                                : 0.0;
                        return Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 1.5.w),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white38,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              minHeight: 2.5.h,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // User info row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 17.r,
                          backgroundImage: NetworkImage(story.avatarUrl),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        story.username,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '1h',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12.sp),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 26),
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
