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
  String? gender;
  String? location;
  String? website;
  Map<String, dynamic>? socialLinks; // Instagram, Twitter, etc.
  bool isVerified;
  bool isPrivate;

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
    this.gender,
    this.location,
    this.website,
    this.socialLinks,
    this.isVerified = false,
    this.isPrivate = false,
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

  // Get display name (preferred over username)
  String get displayName {
    if (fullName.isNotEmpty && fullName != username) {
      return fullName;
    }
    return username;
  }

  // Get initials for avatar
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    } else if (firstName != null) {
      return firstName![0].toUpperCase();
    } else if (lastName != null) {
      return lastName![0].toUpperCase();
    }
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }

  // Check if user has complete profile
  bool get hasCompleteProfile {
    return firstName != null && 
           lastName != null && 
           bio.isNotEmpty && 
           profileImageUrl.isNotEmpty;
  }

  // Get profile completion percentage
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 6; // id, username, email, firstName, lastName, bio, profileImageUrl
    
    if (firstName != null && firstName!.isNotEmpty) completedFields++;
    if (lastName != null && lastName!.isNotEmpty) completedFields++;
    if (bio.isNotEmpty) completedFields++;
    if (profileImageUrl.isNotEmpty && profileImageUrl != 'https://i.pravatar.cc/150?u=$id') completedFields++;
    if (email.isNotEmpty) completedFields++;
    if (username.isNotEmpty) completedFields++;
    
    return completedFields / totalFields;
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
    String? gender,
    String? location,
    String? website,
    Map<String, dynamic>? socialLinks,
    bool? isVerified,
    bool? isPrivate,
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
      gender: gender ?? this.gender,
      location: location ?? this.location,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'postCount': postCount,
      'followers': followers,
      'following': following,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'authProvider': authProvider,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'gender': gender,
      'location': location,
      'website': website,
      'socialLinks': socialLinks,
      'isVerified': isVerified,
      'isPrivate': isPrivate,
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      bio: json['bio'] ?? '',
      postCount: json['postCount'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      authProvider: json['authProvider'] ?? 'email',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      gender: json['gender'],
      location: json['location'],
      website: json['website'],
      socialLinks: json['socialLinks'] != null ? Map<String, dynamic>.from(json['socialLinks']) : null,
      isVerified: json['isVerified'] ?? false,
      isPrivate: json['isPrivate'] ?? false,
    );
  }
} 