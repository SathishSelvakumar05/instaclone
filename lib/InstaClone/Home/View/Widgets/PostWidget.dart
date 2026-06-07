import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Home/Model/InstaPostModel.dart';

class PostWidget extends StatefulWidget {
  final InstaPostModel post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  late bool _isLiked;
  late bool _isBookmarked;
  late int _likeCount;
  late AnimationController _heartController;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _isBookmarked = widget.post.isBookmarked;
    _likeCount = widget.post.likeCount;
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _showHeart = false);
          _heartController.reset();
        }
      });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _onDoubleTap() {
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
        _likeCount++;
      });
    }
    setState(() => _showHeart = true);
    _heartController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildImage(),
          _buildActionBar(),
          _buildLikes(),
          _buildCaption(),
          _buildComments(),
          _buildAddComment(),
          Divider(height: 1.h, color: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundImage: CachedNetworkImageProvider(widget.post.avatarUrl),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.username,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                if (widget.post.location.isNotEmpty)
                  Text(
                    widget.post.location,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
              ],
            ),
          ),
          Icon(Icons.more_horiz, size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              height: 300.h,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => Container(
              height: 300.h,
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 48),
            ),
          ),
          if (_showHeart)
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _heartController,
                curve: Curves.elasticOut,
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 100.sp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        children: [
          IconButton(
            onPressed: _toggleLike,
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.black,
              size: 26.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 14.w),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chat_bubble_outline, size: 24.sp),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 14.w),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.send_outlined, size: 24.sp),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(() => _isBookmarked = !_isBookmarked),
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              size: 24.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildLikes() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Text(
        '${_formatCount(_likeCount)} likes',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 13.sp),
          children: [
            TextSpan(
              text: '${widget.post.username} ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: widget.post.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildComments() {
    if (widget.post.comments.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.comments.length > 2)
            GestureDetector(
              onTap: () {},
              child: Text(
                'View all ${widget.post.comments.length} comments',
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              ),
            ),
          ...widget.post.comments.take(2).map(
                (c) => Text(c, style: TextStyle(fontSize: 12.sp)),
              ),
        ],
      ),
    );
  }

  Widget _buildAddComment() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=10'),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Add a comment...',
              style: TextStyle(color: Colors.grey[500], fontSize: 12.sp),
            ),
          ),
          Text(
            widget.post.timeAgo,
            style: TextStyle(color: Colors.grey[400], fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
