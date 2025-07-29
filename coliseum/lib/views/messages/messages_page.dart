import 'package:coliseum/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:coliseum/widgets/common/search_bar.dart';
import 'package:coliseum/widgets/navigation/bottom_navigation_bar.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  static final List<Map<String, dynamic>> conversations = [
    {
      'name': 'Chimbala',
      'message': 'Klk tigre, tengo un apartamento',
      'time': '2m',
      'avatar': 'assets/images/profiles/chimbala.jpg',
      'unread': true,
    },
    {
      'name': 'Rochy RD',
      'message': 'Esa propiedad está brutal',
      'time': '1h',
      'avatar': 'assets/images/profiles/rochyrd.jpg',
      'unread': false,
    },
    {
      'name': 'Yailin',
      'message': 'Cuánto por el penthouse?',
      'time': '3h',
      'avatar': 'assets/images/profiles/yailin.jpg',
      'unread': false,
    },
    {
      'name': 'Tokischa',
      'message': 'Me interesa esa casa',
      'time': '1d',
      'avatar': 'assets/images/profiles/tokisha.png',
      'unread': true,
    },
    {
      'name': 'El Alfa',
      'message': '¿Está disponible para grabar un video?',
      'time': '2d',
      'avatar': 'assets/images/profiles/elalfa.jpg',
      'unread': false,
    },
  ];

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredConversations {
    if (_search.isEmpty) return MessagesPage.conversations;
    final query = _search.toLowerCase();
    return MessagesPage.conversations.where((c) {
      return (c['name'] as String).toLowerCase().contains(query) ||
             (c['message'] as String).toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        title: Text(
          'Mensajes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white 
                : Colors.black,
            fontSize: 22,
            fontFamily: 'SF Pro Display',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square, color: Colors.white),
            onPressed: () {
              context.push('/new-message');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CustomSearchBar(
              controller: _searchController,
              hintText: 'Buscar',
            ),
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: Future.delayed(const Duration(milliseconds: 800)), // Simula carga
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[900]!,
                    highlightColor: Colors.grey[800]!,
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (_, __) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[900],
                          radius: 24,
                        ),
                        title: Container(
                          height: 14,
                          width: 80,
                          color: Colors.grey[900],
                        ),
                        subtitle: Container(
                          height: 12,
                          width: 120,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  );
                }
                final conversations = _filteredConversations;
                if (conversations.isEmpty) {
                  return const Center(
                    child: Text('No hay conversaciones', style: TextStyle(color: Colors.white54)),
                  );
                }
                return ListView.separated(
                  itemCount: conversations.length,
                  separatorBuilder: (_, __) => const Divider(color: Color(0xFF262626), height: 1),
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[900],
                        radius: 24,
                        backgroundImage: (conversation['avatar'] as String).startsWith('assets/')
                            ? AssetImage(conversation['avatar'] as String) as ImageProvider
                            : NetworkImage(conversation['avatar'] as String),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        conversation['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      subtitle: Text(
                        conversation['message'] as String,
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 14,
                          fontFamily: 'SF Pro Text',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            conversation['time'] as String,
                            style: const TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 12,
                              fontFamily: 'SF Pro Text',
                            ),
                          ),
                          if ((conversation['unread'] as bool) == true) ...[
                            const SizedBox(height: 4),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Color(0xFF0095F6),
                              child: const Text(
                                '1',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        context.push('/chat', extra: {
                          'name': conversation['name'],
                          'avatar': conversation['avatar'],
                          'message': conversation['message'],
                          'unread': conversation['unread'],
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createPost),
        child: const Icon(Icons.add),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
    );
  }
} 