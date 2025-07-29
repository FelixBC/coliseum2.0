class User {
  final String id;
  String username;
  String email;
  String profileImageUrl;
  String bio;
  final int postCount;
  final int followers;
  final int following;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  DateTime? dateOfBirth;
  String? authProvider; // 'email', 'google', 'facebook', 'github'
  DateTime? createdAt;
  DateTime? lastLoginAt;

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
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
    this.authProvider = 'email',
    this.createdAt,
    this.lastLoginAt,
  });

  // Get full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }

  // Copy with method for updating user data
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    String? bio,
    int? postCount,
    int? followers,
    int? following,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? authProvider,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      postCount: postCount ?? this.postCount,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
} 