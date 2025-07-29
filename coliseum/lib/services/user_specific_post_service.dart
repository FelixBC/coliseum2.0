import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/post_service.dart';

class UserSpecificPostService implements PostService {
  final PostService _basePostService;
  
  UserSpecificPostService(this._basePostService);
  
  @override
  Future<List<Post>> getFeedPosts() async {
    // This will be called with the current user context
    // For now, we'll return different posts based on a simulated user check
    return _getPostsForCurrentUser();
  }
  
  // These methods are not in the PostService interface, so we'll implement them directly
  Future<List<Post>> getPostsByUser(String userId) async {
    // For now, return empty list. In a real app, this would filter posts by user
    return [];
  }
  
  Future<Post?> getPostById(String postId) async {
    // For now, return null. In a real app, this would find the specific post
    return null;
  }
  
  List<Post> _getPostsForCurrentUser() {
    // Create users for posts
    final felixUser = User(
      id: 'google_felix_blanco',
      username: 'felixaurio17',
      email: 'felixaurio17@gmail.com',
      profileImageUrl: 'https://i.pravatar.cc/150?u=felixaurio17@gmail.com',
    );
    
    final elAlfa = User(
      id: 'el_alfa',
      username: 'elalfaeljefe',
      email: 'elalfa@eljefe.com',
      profileImageUrl: 'assets/images/profiles/elalfa.jpg',
    );
    
    final rochyRD = User(
      id: 'rochy_rd',
      username: 'rochyrd',
      email: 'rochy@rd.com',
      profileImageUrl: 'assets/images/profiles/rochyrd.jpg',
    );
    
    final chimbala = User(
      id: 'chimbala',
      username: 'chimbalaofficial',
      email: 'chimbala@official.com',
      profileImageUrl: 'assets/images/profiles/chimbala.jpg',
    );
    
    final yailin = User(
      id: 'yailin_lamasviral',
      username: 'yailinlamasviral',
      email: 'yailin@viral.com',
      profileImageUrl: 'assets/images/profiles/yailin.jpg',
    );
    
    final tokischa = User(
      id: 'tokischa',
      username: 'tokischa.popola',
      email: 'tokischa@popola.com',
      profileImageUrl: 'assets/images/profiles/tokisha.png',
    );
    
    // Felix's personal properties (only 3 as requested)
    final felixProperties = [
      Post(
        id: 'felix_prop_1',
        user: felixUser,
        imageUrl: 'assets/images/properties/airbnb.jpg',
        caption: 'Penthouse de Lujo en Santo Domingo - Hermoso penthouse con vista al mar, 3 habitaciones, 2 baños, cocina gourmet y terraza privada. Precio: \$850,000',
        likes: 45,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        location: 'Santo Domingo, República Dominicana',
      ),
      Post(
        id: 'felix_prop_2',
        user: felixUser,
        imageUrl: 'assets/images/properties/airbnb2.jpg',
        caption: 'Casa Moderna en Santiago - Casa contemporánea con diseño minimalista, perfecta para familias modernas. 4 habitaciones, 3 baños. Precio: \$650,000',
        likes: 32,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        location: 'Santiago, República Dominicana',
      ),
      Post(
        id: 'felix_prop_3',
        user: felixUser,
        imageUrl: 'assets/images/properties/airbnb3.jpg',
        caption: 'Apartamento en Zona Colonial - Encantador apartamento restaurado en el corazón histórico de Santo Domingo. 2 habitaciones, 1 baño. Precio: \$420,000',
        likes: 28,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        location: 'Zona Colonial, Santo Domingo',
      ),
    ];
    
    // Test user properties (all the original ones)
    final testUserProperties = [
      Post(
        id: 'test_prop_1',
        user: elAlfa,
        imageUrl: 'assets/images/properties/airbnb4.jpg',
        caption: 'Luxury Villa with Ocean View - Stunning villa with panoramic ocean views, private pool, and modern amenities. 5 bedrooms, 4 bathrooms. Price: \$1,200,000',
        likes: 89,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        location: 'Punta Cana, Dominican Republic',
      ),
      Post(
        id: 'test_prop_2',
        user: rochyRD,
        imageUrl: 'assets/images/properties/airbnb5.jpg',
        caption: 'Modern Penthouse in City Center - Contemporary penthouse with city skyline views and luxury finishes. 3 bedrooms, 2 bathrooms. Price: \$950,000',
        likes: 67,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        location: 'Santo Domingo, Dominican Republic',
      ),
      Post(
        id: 'test_prop_3',
        user: chimbala,
        imageUrl: 'assets/images/properties/airbnb7.jpeg',
        caption: 'Beachfront Condo - Beautiful beachfront condo with direct access to the beach. 2 bedrooms, 2 bathrooms. Price: \$750,000',
        likes: 54,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        location: 'Bávaro, Dominican Republic',
      ),
      Post(
        id: 'test_prop_4',
        user: yailin,
        imageUrl: 'assets/images/properties/airbnb10.jpeg',
        caption: 'Mountain Retreat - Peaceful mountain retreat with stunning valley views. 4 bedrooms, 3 bathrooms. Price: \$680,000',
        likes: 43,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        location: 'Jarabacoa, Dominican Republic',
      ),
      Post(
        id: 'test_prop_5',
        user: tokischa,
        imageUrl: 'assets/images/properties/airbnb11.jpg',
        caption: 'Urban Loft - Modern urban loft in the heart of the city. 1 bedroom, 1 bathroom. Price: \$520,000',
        likes: 38,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        location: 'Santo Domingo, Dominican Republic',
      ),
    ];
    
    // For demonstration, we'll simulate different user types
    // In a real app, this would check the actual current user
    final userType = _getSimulatedUserType();
    
    switch (userType) {
      case 'felix':
        return felixProperties;
      case 'test':
        return testUserProperties;
      default:
        // For other Google users, return a mix
        return [...felixProperties.take(2), ...testUserProperties.take(3)];
    }
  }
  
  String _getSimulatedUserType() {
    // Use the same logic as ProductionAuthService for consistency
    final now = DateTime.now();
    final minute = now.minute;
    
    // Felix's login will be detected in specific minutes for easy testing
    // Minutes 0-9: Felix's login (10% chance)
    // Minutes 10-19: Test user login (10% chance)  
    // Minutes 20-59: Other users (40% chance)
    
    if (minute < 10) return 'felix';        // Felix's login
    if (minute < 20) return 'test';         // Test user login
    return 'other';                         // Other users
  }
} 