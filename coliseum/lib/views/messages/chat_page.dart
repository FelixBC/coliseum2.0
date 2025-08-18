import 'package:coliseum/constants/routes.dart';
import 'package:coliseum/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final String name = args?['name'] ?? 'Usuario';
    final String avatar = args?['avatar'] ?? '';
    final String lastMessage = args?['message'] ?? '';

    // Conversaciones realistas por contacto
    List<Map<String, dynamic>> messages;
    if (name.toLowerCase().contains('chimbala')) {
      messages = [
        {'fromMe': true, 'text': 'Hola Chimbala, vi tu apartamento publicado.', 'time': '10:00'},
        {'fromMe': false, 'text': 'Klk tigre, tengo un apartamento', 'time': '10:01'},
        {'fromMe': true, 'text': '¿Cuánto cuesta la renta mensual?', 'time': '10:02'},
        {'fromMe': false, 'text': 'Depende del tiempo, ¿cuánto piensas quedarte?', 'time': '10:03'},
        {'fromMe': true, 'text': 'Unos 3 meses, ¿tienes fotos?', 'time': '10:04'},
        {'fromMe': false, 'text': 'Claro, te las paso por aquí.', 'time': '10:05'},
        {'fromMe': false, 'text': lastMessage, 'time': '10:06'},
      ];
    } else if (name.toLowerCase().contains('rochy')) {
      messages = [
        {'fromMe': true, 'text': 'Hola Rochy, ¿aún está disponible la propiedad?', 'time': '11:00'},
        {'fromMe': false, 'text': 'Esa propiedad está brutal', 'time': '11:01'},
        {'fromMe': true, 'text': '¿Te gustaría agendar una visita?', 'time': '11:02'},
        {'fromMe': false, 'text': 'Claro, dime cuándo puedes.', 'time': '11:03'},
        {'fromMe': true, 'text': '¿Este fin de semana te va bien?', 'time': '11:04'},
        {'fromMe': false, 'text': 'Perfecto, sábado a las 3pm.', 'time': '11:05'},
        {'fromMe': false, 'text': lastMessage, 'time': '11:06'},
      ];
    } else if (name.toLowerCase().contains('yailin')) {
      messages = [
        {'fromMe': true, 'text': 'Hola Yailin, me interesa el penthouse.', 'time': '12:00'},
        {'fromMe': false, 'text': 'Cuánto por el penthouse?', 'time': '12:01'},
        {'fromMe': true, 'text': 'Te paso el precio por privado.', 'time': '12:02'},
        {'fromMe': false, 'text': 'Perfecto, espero tu mensaje.', 'time': '12:03'},
        {'fromMe': true, 'text': '¿Quieres agendar una visita?', 'time': '12:04'},
        {'fromMe': false, 'text': 'Sí, ¿cuándo puedes?', 'time': '12:05'},
        {'fromMe': false, 'text': lastMessage, 'time': '12:06'},
      ];
    } else if (name.toLowerCase().contains('el alfa')) {
      messages = [
        {'fromMe': true, 'text': 'Hola El Alfa, vi tu anuncio.', 'time': '13:00'},
        {'fromMe': false, 'text': 'Dime a ver, ¿qué buscas?', 'time': '13:01'},
        {'fromMe': true, 'text': 'Un apartamento céntrico.', 'time': '13:02'},
        {'fromMe': false, 'text': 'Tengo uno en Naco, full amueblado.', 'time': '13:03'},
        {'fromMe': true, 'text': '¿Cuánto la renta?', 'time': '13:04'},
        {'fromMe': false, 'text': '1200 dólares al mes.', 'time': '13:05'},
        {'fromMe': false, 'text': lastMessage, 'time': '13:06'},
      ];
    } else if (name.toLowerCase().contains('tokisha')) {
      messages = [
        {'fromMe': true, 'text': 'Hola Tokisha, ¿tienes propiedades disponibles?', 'time': '14:00'},
        {'fromMe': false, 'text': 'Sí, tengo varias en la zona colonial.', 'time': '14:01'},
        {'fromMe': true, 'text': '¿Me puedes enviar fotos?', 'time': '14:02'},
        {'fromMe': false, 'text': 'Claro, te las mando ahora.', 'time': '14:03'},
        {'fromMe': true, 'text': 'Gracias, ¿cuánto la renta?', 'time': '14:04'},
        {'fromMe': false, 'text': 'Desde 900 dólares.', 'time': '14:05'},
        {'fromMe': false, 'text': lastMessage, 'time': '14:06'},
      ];
    } else {
      messages = [
        {'fromMe': true, 'text': 'Hola $name, ¿cómo estás?', 'time': '15:00'},
        {'fromMe': false, 'text': lastMessage, 'time': '15:01'},
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundImage: getImageProvider(avatar),
            radius: 20,
          ),
        ),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ChatBubble(
                  text: msg['text'] ?? '',
                  fromMe: msg['fromMe'] ?? false,
                  time: msg['time'] ?? '',
                );
              },
            ),
          ),
          Container(
            color: const Color(0xFF121212),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF262626),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0095F6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to determine if an image is a local asset
  bool isLocalAsset(String url) {
    return url.startsWith('assets/') || url.startsWith('file://');
  }

  // Helper function to get the correct image provider
  ImageProvider getImageProvider(String url) {
    if (url.isEmpty) return const AssetImage('assets/images/logo/whitelogo.png');
    if (isLocalAsset(url)) {
      return AssetImage(url);
    } else {
      return NetworkImage(url);
    }
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool fromMe;
  final String time;
  const ChatBubble({
    Key? key,
    required this.text,
    required this.fromMe,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = fromMe ? const Color(0xFF0095F6) : const Color(0xFF262626);
    final align = fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = fromMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: fromMe ? 48 : 0,
            right: fromMe ? 0 : 48,
            bottom: 4,
            top: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: fromMe ? Colors.white : Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: fromMe ? 0 : 16,
            right: fromMe ? 16 : 0,
            bottom: 2,
          ),
          child: Text(
            time,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
} 