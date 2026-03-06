import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flame/game.dart';
import 'game/rocket_game.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final WebViewController controller;
  String? playerName;
  Color? favoriteColor;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterGame',
        onMessageReceived: (message) {
          final parts = message.message.split('|');
          if (parts.length != 2) return;
          final name = parts[0];
          final colorHex = parts[1];
          final color = _hexToColor(colorHex);
          setState(() {
            playerName = name;
            favoriteColor = color;
          });
        },
      )
      ..loadRequest(Uri.parse('https://hello-sbre.onrender.com'));
  }

  Color _hexToColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    // GAME SCREEN
    if (playerName != null && favoriteColor != null) {
      return Scaffold(
        backgroundColor: favoriteColor,
        body: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Welcome Commander $playerName',
              style: const TextStyle(fontSize: 22),
            ),
            Expanded(
              child: GameWidget(
                game: RocketGame(
                  playerName: playerName!,
                  favoriteColor: favoriteColor!,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  playerName = null;
                  favoriteColor = null;
                });
              },
              child: const Text("Back to Web App"),
            ),
          ],
        ),
      );
    }
    
    // WEB APP SCREEN
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome App")),
      body: WebViewWidget(controller: controller),
    );
  }
}
 