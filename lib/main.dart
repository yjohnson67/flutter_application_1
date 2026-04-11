import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

const String baseUrl = 'http://10.0.2.2:8000';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome App',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController controller;
  String pageStatus = 'Loading page...';

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('PAGE STARTED: $url');
            setState(() {
              pageStatus = 'Loading: $url';
            });
          },
          onPageFinished: (url) {
            debugPrint('PAGE FINISHED: $url');
            setState(() {
              pageStatus = 'Loaded: $url';
            });
          },
          onWebResourceError: (error) {
            debugPrint('WEBVIEW ERROR: ${error.description}');
            setState(() {
              pageStatus = 'Error: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('$baseUrl/'));
  }

  Future<void> sendScoreToDjango({
    required String playerName,
    required String rocketColor,
    required int score,
  }) async {
    final url = Uri.parse('$baseUrl/save-test-score/');

    final payload = {
      'player_name': playerName,
      'rocket_color': rocketColor,
      'score': score,
    };

    try {
      debugPrint('Sending score to Django...');
      debugPrint('POST $url');
      debugPrint('Payload: $payload');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      debugPrint('Save response status: ${response.statusCode}');
      debugPrint('Save response body: ${response.body}');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Score saved! Status: ${response.statusCode}'),
        ),
      );
    } catch (e) {
      debugPrint('SAVE ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save score: $e'),
        ),
      );
    }
  }

  void openLeaderboard() {
    controller.loadRequest(Uri.parse('$baseUrl/leaderboard/'));
  }

  void openDashboard() {
    controller.loadRequest(Uri.parse('$baseUrl/dashboard/'));
  }

  void openHome() {
    controller.loadRequest(Uri.parse('$baseUrl/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome App'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.black12,
            child: Text(
              pageStatus,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: openHome,
                  child: const Text('Home'),
                ),
                ElevatedButton(
                  onPressed: openLeaderboard,
                  child: const Text('Leaderboard'),
                ),
                ElevatedButton(
                  onPressed: openDashboard,
                  child: const Text('Dashboard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendScoreToDjango(
                      playerName: 'Archie',
                      rocketColor: '#FFA500',
                      score: 122,
                    );
                  },
                  child: const Text('Send Test Score'),
                ),
              ],
            ),
          ),
          Expanded(
            child: WebViewWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}