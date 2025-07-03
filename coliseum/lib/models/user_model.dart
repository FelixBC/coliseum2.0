class User {
  final String id;
  String username;
  String email;
  String profileImageUrl;
  String bio;
  final int postCount;
  final int followers;
  final int following;

  // Model representing a user in the application.
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    this.bio = '',
    this.postCount = 0,
    this.followers = 0,
    this.following = 0,
  });
} 