import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/widgets/post/post_actions_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:coliseum/views/booking/booking_calendar_page.dart';

class PropertyDetailPage extends StatelessWidget {
  final Post post;

  const PropertyDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0.5,
        title: Text(
          post.user.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SF Pro Display',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Implement more options
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFF0095F6),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[900],
                      backgroundImage: post.user.profileImageUrl.startsWith('assets/')
                          ? AssetImage(post.user.profileImageUrl) as ImageProvider
                          : NetworkImage(post.user.profileImageUrl),
                      onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      post.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Image
            Hero(
              tag: 'post_${post.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: post.imageUrl.startsWith('assets/')
                    ? Image.asset(
                        post.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width,
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 50),
                            ),
                          );
                        },
                      )
                    : Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width,
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 50),
                            ),
                          );
                        },
                      ),
              ),
            ),
            // Action Bar
            PostActionsBar(post: post),
            // Caption and details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'SF Pro Text'),
                      children: [
                        TextSpan(
                          text: '${post.user.username} ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextSpan(text: post.caption),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (post.location != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        post.location!,
                        style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13, fontFamily: 'SF Pro Text'),
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (post.postedAt != null)
                    Text(
                      'Publicado el ${DateFormat('d MMM y').format(post.postedAt!)}',
                      style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12, fontFamily: 'SF Pro Text'),
                    ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF262626)),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Precio de Reserva', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'SF Pro Display')),
                  Text(
                    '\$${post.likes} USD / Noche',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0095F6), fontFamily: 'SF Pro Display'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookingCalendarPage(propertyId: post.id),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF0095F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'SF Pro Display'),
                ),
                child: const Text('Reservar Ahora'),
              ),
            )
          ],
        ),
      ),
    );
  }
} 