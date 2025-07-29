import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/widgets/common/search_bar.dart';
import 'package:coliseum/widgets/navigation/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  static final List<String> localImages = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        title: CustomSearchBar(
          onSearch: (query) {
            // Aquí puedes filtrar resultados o mostrar un mensaje
            debugPrint('Búsqueda válida: $query');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune, 
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black
            ),
            onPressed: () {
              // TODO: Implement filter action
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: Future.delayed(const Duration(milliseconds: 800)), // Simula carga
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[800]!,
              child: MasonryGridView.builder(
                itemCount: 8,
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final height = (index % 3 + 2) * 100;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey[900],
                        height: height.toDouble(),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return MasonryGridView.builder(
            itemCount: 20,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final height = (index % 3 + 2) * 100;
              final imagePath = localImages[index % localImages.length];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    height: height.toDouble(),
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createPost),
        child: const Icon(Icons.add),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
    );
  }
} 