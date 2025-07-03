import 'package:coliseum/viewmodels/saved_view_model.dart';
import 'package:coliseum/widgets/common/error_display.dart';
import 'package:coliseum/widgets/common/post_list_shimmer.dart';
import 'package:coliseum/widgets/profile/post_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    super.initState();
    // Use a post frame callback to fetch data after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedViewModel>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardados'),
      ),
      body: Consumer<SavedViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.state) {
            case SavedState.loading:
            case SavedState.idle:
              // Use a shimmer effect for loading state
              return const PostListShimmer();
            case SavedState.error:
              return ErrorDisplay(
                message: viewModel.errorMessage ?? 'Ocurrió un error al cargar tus favoritos.',
                onRetry: () => viewModel.fetchPosts(),
              );
            case SavedState.success:
              if (viewModel.savedPosts.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aún no has guardado nada',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                       SizedBox(height: 8),
                      Text(
                        'Guarda las propiedades que te interesan para verlas aquí.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              // Display the grid of saved posts
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: PostGrid(posts: viewModel.savedPosts),
                ),
              );
          }
        },
      ),
    );
  }
} 