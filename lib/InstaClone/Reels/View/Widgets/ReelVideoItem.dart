import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../Model/ReelModel.dart';
import 'CommentBottomSheet.dart';

class ReelVideoItem extends StatefulWidget {
  final ReelModel reel;
  final VideoPlayerController controller;
  final bool isActive;
  final String currentUserId;
  final String currentUsername;
  final void Function() onLikeTap;
  final void Function(String text) onComment;

  const ReelVideoItem({
    super.key,
    required this.reel,
    required this.controller,
    required this.isActive,
    required this.currentUserId,
    required this.currentUsername,
    required this.onLikeTap,
    required this.onComment,
  });

  @override
  State<ReelVideoItem> createState() => _ReelVideoItemState();
}

class _ReelVideoItemState extends State<ReelVideoItem> {
  bool _showPlayPause = false;

  @override
  void didUpdateWidget(covariant ReelVideoItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      widget.controller.play();
    } else if (!widget.isActive && old.isActive) {
      widget.controller.pause();
    }
  }

  void _togglePlayPause() {
    setState(() => _showPlayPause = true);
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showPlayPause = false);
    });
  }

  bool get _isLiked => widget.reel.likedBy.contains(widget.currentUserId);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildVideo(),
        _buildGradient(),
        _buildPlayPauseOverlay(),
        _buildRightActions(),
        _buildBottomInfo(),
      ],
    );
  }

  Widget _buildVideo() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: widget.controller.value.isInitialized
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: widget.controller.value.size.width,
                height: widget.controller.value.size.height,
                child: VideoPlayer(widget.controller),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
    );
  }

  Widget _buildGradient() {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.3),
              Colors.black.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.5, 0.8, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseOverlay() {
    if (!_showPlayPause) return const SizedBox();
    return Center(
      child: AnimatedOpacity(
        opacity: _showPlayPause ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.controller.value.isPlaying ? Icons.play_arrow : Icons.pause,
            color: Colors.white,
            size: 36.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildRightActions() {
    return Positioned(
      right: 12.w,
      bottom: 100.h,
      child: Column(
        children: [
          _actionButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.white,
            label: _formatCount(widget.reel.likeCount),
            onTap: widget.onLikeTap,
          ),
          SizedBox(height: 20.h),
          _actionButton(
            icon: Icons.chat_bubble_outline,
            color: Colors.white,
            label: _formatCount(widget.reel.comments.length),
            onTap: () => _showComments(context),
          ),
          SizedBox(height: 20.h),
          _actionButton(
            icon: Icons.send_outlined,
            color: Colors.white,
            label: 'Share',
            onTap: () => Share.share(
              '🎬 Check out this reel on InstaClone!\n"${widget.reel.caption}"',
            ),
          ),
          SizedBox(height: 20.h),
          _buildMusicDisc(),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicDisc() {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white54, width: 2),
        image: DecorationImage(
          image: NetworkImage(widget.reel.avatarUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      left: 12.w,
      right: 60.w,
      bottom: 40.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundImage: NetworkImage(widget.reel.avatarUrl),
              ),
              SizedBox(width: 8.w),
              Text(
                widget.reel.username,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
              SizedBox(width: 8.w),
              _followButton(),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            widget.reel.caption,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _followButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'Follow',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentBottomSheet(
        comments: widget.reel.comments,
        onSend: widget.onComment,
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
