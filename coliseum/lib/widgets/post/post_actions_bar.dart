import 'package:coliseum/models/post_model.dart';
import 'package:flutter/material.dart';

class PostActionsBar extends StatefulWidget {
  final Post post;
  const PostActionsBar({super.key, required this.post});

  @override
  State<PostActionsBar> createState() => _PostActionsBarState();
}

class _PostActionsBarState extends State<PostActionsBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  widget.post.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.post.isLiked ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    widget.post.isLiked = !widget.post.isLiked;
                  });
                },
                splashRadius: 22,
              ),
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined, color: Colors.white),
                onPressed: () {
                  // TODO: Handle comment action
                },
                splashRadius: 22,
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {
                  // TODO: Handle send action
                },
                splashRadius: 22,
              ),
            ],
          ),
          IconButton(
            icon: Icon(widget.post.isFavorited
                ? Icons.bookmark
                : Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              setState(() {
                widget.post.isFavorited = !widget.post.isFavorited;
              });
            },
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
} 