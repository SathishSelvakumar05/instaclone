import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Model/ReelModel.dart';

class CommentBottomSheet extends StatefulWidget {
  final List<ReelComment> comments;
  final void Function(String text) onSend;

  const CommentBottomSheet({
    super.key,
    required this.comments,
    required this.onSend,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _controller = TextEditingController();
  bool _canSend = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildTitle(),
              const Divider(height: 1),
              Expanded(
                child: widget.comments.isEmpty
                    ? Center(
                        child: Text(
                          'No comments yet.\nBe the first to comment!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: widget.comments.length,
                        separatorBuilder: (_, __) => SizedBox(height: 4.h),
                        itemBuilder: (_, i) => _buildCommentTile(widget.comments[i]),
                      ),
              ),
              _buildInputBar(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() => Center(
        child: Container(
          width: 36.w,
          height: 4.h,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      );

  Widget _buildTitle() => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          'Comments',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      );

  Widget _buildCommentTile(ReelComment comment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=${comment.userId}',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                    children: [
                      TextSpan(
                        text: '${comment.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: comment.text),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _formatTime(comment.timestamp),
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=10'),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (v) => setState(() => _canSend = v.trim().isNotEmpty),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: TextStyle(fontSize: 13.sp),
                maxLines: null,
              ),
            ),
            TextButton(
              onPressed: _canSend
                  ? () {
                      widget.onSend(_controller.text.trim());
                      _controller.clear();
                      setState(() => _canSend = false);
                    }
                  : null,
              child: Text(
                'Post',
                style: TextStyle(
                  color: _canSend ? const Color(0xFF0095F6) : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays}d';
    } catch (_) {
      return '';
    }
  }
}
