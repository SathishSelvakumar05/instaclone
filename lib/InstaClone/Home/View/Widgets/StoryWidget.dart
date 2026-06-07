import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Home/Model/StoryModel.dart';

class StoryWidget extends StatelessWidget {
  final StoryModel story;
  final VoidCallback? onTap;

  const StoryWidget({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.w,
        margin: EdgeInsets.only(right: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(),
            SizedBox(height: 4.h),
            Text(
              story.username,
              style: TextStyle(fontSize: 11.sp, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (story.isOwn) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(story.avatarUrl),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                color: Color(0xFF0095F6),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 14.sp),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.all(2.5.w),
      decoration: story.hasNewStory
          ? const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFf09433),
                  Color(0xFFe6683c),
                  Color(0xFFdc2743),
                  Color(0xFFcc2366),
                  Color(0xFFbc1888),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )
          : BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: 27.r,
          backgroundImage: NetworkImage(story.avatarUrl),
        ),
      ),
    );
  }
}
