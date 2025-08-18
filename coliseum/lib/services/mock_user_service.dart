import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/user_service.dart';

class MockUserService implements UserService {
  final User _mockUser = User(
    id: 'el_alfa',
    username: 'elalfaeljefe',
    email: 'elalfa@elJefe.com',
    profileImageUrl: 'assets/images/profiles/elalfa.jpg',
    bio: 'El Jefe del Dembow. Inmobiliaria El Jefe Records.',
    followers: 7800000,
    following: 15,
    postCount: 15,
  );

  final List<User> _mockFollowers = [
    User(
      id: 'rochyrd',
      username: 'rochyrd',
      email: 'rochy@dembow.com',
      profileImageUrl: 'assets/images/profiles/rochyrd.jpg',
      bio: 'Rochy RD, el wawa.',
      followers: 3500000,
      following: 10,
      postCount: 8,
    ),
    User(
      id: 'chimbala',
      username: 'chimbala',
      email: 'chimbala@dembow.com',
      profileImageUrl: 'assets/images/profiles/chimbala.jpg',
      bio: 'Chimbala, el que no falla.',
      followers: 2100000,
      following: 12,
      postCount: 10,
    ),
    User(
      id: 'tokisha',
      username: 'tokisha',
      email: 'tokisha@dembow.com',
      profileImageUrl: 'assets/images/profiles/tokisha.png',
      bio: 'Tokischa, la más perversa.',
      followers: 1800000,
      following: 8,
      postCount: 7,
    ),
    User(
      id: 'yailin',
      username: 'yailinlamasviral',
      email: 'yailin@dembow.com',
      profileImageUrl: 'assets/images/profiles/yailin.jpg',
      bio: 'Yailin La Más Viral.',
      followers: 1200000,
      following: 5,
      postCount: 5,
    ),
  ];

  // Usuarios registrados en la sesión (mock)
  final List<User> _sessionUsers = [];

  // Buscar usuario por email (mock + sesión)
  User? findUserByEmail(String email) {
    final lower = email.trim().toLowerCase();
    if (_mockUser.email.toLowerCase() == lower) return _mockUser;
    for (final u in _mockFollowers) {
      if (u.email.toLowerCase() == lower) return u;
    }
    for (final u in _sessionUsers) {
      if (u.email.toLowerCase() == lower) return u;
    }
    return null;
  }

  // Buscar usuario por username (mock + sesión)
  User? findUserByUsername(String username) {
    final lower = username.trim().toLowerCase();
    if (_mockUser.username.toLowerCase() == lower) return _mockUser;
    for (final u in _mockFollowers) {
      if (u.username.toLowerCase() == lower) return u;
    }
    for (final u in _sessionUsers) {
      if (u.username.toLowerCase() == lower) return u;
    }
    return null;
  }

  // Registrar usuario en sesión
  User registerUser({required String username, required String email, required String password}) {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: email,
      profileImageUrl: 'https://i.pravatar.cc/150?u=$username',
      bio: '',
      followers: 0,
      following: 0,
      postCount: 0,
    );
    _sessionUsers.add(user);
    return user;
  }

  @override
  Future<User> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Handle different user IDs based on authentication method
    if (userId.contains('google_felix_blanco')) {
      // Felix's profile for Google login
      return User(
        id: 'google_felix_blanco',
        username: 'felix.blanco',
        email: 'felixaurio17@gmail.com',
        profileImageUrl: 'assets/images/profiles/felix.blanco_profile_photo.jpg',
        bio: 'Desarrollador Flutter y entusiasta de la tecnología inmobiliaria | @felix.blanco',
        postCount: 1,
        followers: 127,
        following: 89,
        firstName: 'Felix',
        lastName: 'Blanco Cabrera',
        phoneNumber: '+1 809-555-0123',
        dateOfBirth: DateTime(1995, 6, 15),
        authProvider: 'google',
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastLoginAt: DateTime.now(),
      );
    } else if (userId.contains('el_alfa_user')) {
      // El Alfa's profile for test login
      return User(
        id: 'el_alfa_user',
        username: 'elalfaeljefe',
        email: 'test@coliseum.com',
        profileImageUrl: 'assets/images/profiles/elalfa.jpg',
        bio: 'El Jefe del Dembow 🎵 | Inmobiliaria El Jefe Records | @felix.blanco',
        postCount: 15,
        followers: 7800000,
        following: 15,
        firstName: 'El Alfa',
        lastName: 'El Jefe',
        phoneNumber: '+1 809-555-0001',
        dateOfBirth: DateTime(1990, 12, 4),
        authProvider: 'email',
        createdAt: DateTime.now().subtract(const Duration(days: 730)),
        lastLoginAt: DateTime.now(),
      );
    } else {
      // Default profile for other users
      return _mockUser;
    }
  }

  @override
  Future<List<Post>> getUserPosts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Handle different user IDs based on authentication method
    User userToUse;
    int postCount;
    
    if (userId.contains('google_felix_blanco')) {
      // Felix's profile - only 1 property as requested
      userToUse = User(
        id: 'google_felix_blanco',
        username: 'felix.blanco',
        email: 'felixaurio17@gmail.com',
        profileImageUrl: 'assets/images/profiles/felix.blanco_profile_photo.jpg',
        bio: 'Desarrollador Flutter y entusiasta de la tecnología inmobiliaria | @felix.blanco',
        postCount: 1,
        followers: 127,
        following: 89,
        firstName: 'Felix',
        lastName: 'Blanco Cabrera',
        phoneNumber: '+1 809-555-0123',
        dateOfBirth: DateTime(1995, 6, 15),
        authProvider: 'google',
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastLoginAt: DateTime.now(),
      );
      postCount = 1; // Only 1 property for Felix
    } else if (userId.contains('el_alfa_user')) {
      // El Alfa's profile - 15 properties
      userToUse = User(
        id: 'el_alfa_user',
        username: 'elalfaeljefe',
        email: 'test@coliseum.com',
        profileImageUrl: 'assets/images/profiles/elalfa.jpg',
        bio: 'El Jefe del Dembow 🎵 | Inmobiliaria El Jefe Records | @felix.blanco',
        postCount: 15,
        followers: 7800000,
        following: 15,
        firstName: 'El Alfa',
        lastName: 'El Jefe',
        phoneNumber: '+1 809-555-0001',
        dateOfBirth: DateTime(1990, 12, 4),
        authProvider: 'email',
        createdAt: DateTime.now().subtract(const Duration(days: 730)),
        lastLoginAt: DateTime.now(),
      );
      postCount = 15; // 15 properties for El Alfa
    } else {
      // Default profile
      userToUse = _mockUser;
      postCount = 15;
    }
    
    final assetImages = [
      'assets/images/properties/airbnb.jpg',
      'assets/images/properties/airbnb2.jpg',
      'assets/images/properties/airbnb3.jpg',
      'assets/images/properties/airbnb4.jpg',
      'assets/images/properties/airbnb5.jpg',
      'assets/images/properties/airbnb7.jpeg',
      'assets/images/properties/airbnb10.jpeg',
      'assets/images/properties/airbnb11.jpg',
      'assets/images/properties/airbnb12.jpeg',
      'assets/images/properties/airbnb13.jpg',
      'assets/images/properties/airbnb15.jpg',
      'assets/images/properties/airbnb16.jpeg',
      'assets/images/properties/airbnb24.jpg',
      'assets/images/properties/airbnb27.jpg',
    ];
    
    return List.generate(
      postCount,
      (index) => Post(
        id: 'userpost$index',
        user: userToUse,
        imageUrl: assetImages[index % assetImages.length],
        caption: 'Apartamento en Santo Domingo #${index + 1} 🏠',
        likes: 1000 + (index * 50),
        comments: [],
        createdAt: DateTime.now().subtract(Duration(days: index)),
      ),
    );
  }

  @override
  Future<User> updateUserProfile(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simula la actualización del usuario principal
    // (en una app real, aquí se actualizaría en base de datos o API)
    return user;
  }

  List<User> getFollowers() => _mockFollowers;
} 