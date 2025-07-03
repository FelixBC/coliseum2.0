import 'package:coliseum/models/comment_model.dart';
import 'package:coliseum/models/post_model.dart';
import 'package:coliseum/models/user_model.dart';
import 'package:coliseum/services/post_service.dart';

class MockPostService implements PostService {
  @override
  Future<List<Post>> getFeedPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final rochyRD = User(
      id: 'rochy_rd',
      username: 'rochyrd',
      email: 'rochy@rd.com',
      profileImageUrl: 'assets/images/profiles/rochyrd.jpg',
    );
    final yailin = User(
      id: 'yailin_lamasviral',
      username: 'yailinlamasviral',
      email: 'yailin@viral.com',
      profileImageUrl: 'assets/images/profiles/yailin.jpg',
    );
    final chimbala = User(
      id: 'chimbala',
      username: 'chimbalaofficial',
      email: 'chimbala@official.com',
      profileImageUrl: 'assets/images/profiles/chimbala.jpg',
    );
    final elAlfa = User(
      id: 'el_alfa',
      username: 'elalfaeljefe',
      email: 'elalfa@eljefe.com',
      profileImageUrl: 'assets/images/profiles/elalfa.jpg',
    );
    final tokischa = User(
      id: 'tokischa',
      username: 'tokischa.popola',
      email: 'tokischa@popola.com',
      profileImageUrl: 'assets/images/profiles/tokisha.png',
    );

    final propertyImages = [
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

    return [
      Post(
        id: '1',
        user: elAlfa,
        imageUrl: propertyImages[0],
        caption: '¡En venta! Lujoso apartamento con vista al mar en Cap Cana.',
        likes: 1250,
        comments: [
          Comment(id: 'c1', user: yailin, text: '¡Qué chulo! ¿Cuál es el precio?', createdAt: DateTime.now().subtract(const Duration(minutes: 5))),
          Comment(id: 'c2', user: chimbala, text: 'Me interesa, te escribo al DM.', createdAt: DateTime.now().subtract(const Duration(minutes: 2))),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        location: 'Cap Cana, Punta Cana',
        postedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Post(
        id: '2',
        user: tokischa,
        imageUrl: propertyImages[1],
        caption: 'Penthouse disponible en Naco. Acabados de primera.',
        likes: 3480,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        location: 'Naco, Santo Domingo',
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Post(
        id: '3',
        user: chimbala,
        imageUrl: propertyImages[2],
        caption: 'Proyecto de torres en Piantini. Separa el tuyo con un 10%.',
        likes: 890,
        comments: [
            Comment(id: 'c3', user: rochyRD, text: '¡Durísimo! Allá nos vemos.', createdAt: DateTime.now().subtract(const Duration(hours: 3))),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        location: 'Piantini, Santo Domingo',
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
       Post(
        id: '4',
        user: rochyRD,
        imageUrl: propertyImages[3],
        caption: 'Apartamento minimalista en el centro de la ciudad. Ideal para solteros.',
        likes: 950,
        comments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        location: 'Serralles, Santo Domingo',
        postedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
} 