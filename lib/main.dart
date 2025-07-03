import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Untuk Android, tambahkan ini di AndroidManifest.xml:
// <uses-permission android:name="android.permission.INTERNET" />

void main() {
  runApp(const LaravelBrowserApp());
}

class LaravelBrowserApp extends StatelessWidget {
  const LaravelBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laravel Project Browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LaravelBrowserScreen(),
    );
  }
}

class LaravelBrowserScreen extends StatefulWidget {
  const LaravelBrowserScreen({super.key});

  @override
  State<LaravelBrowserScreen> createState() => _LaravelBrowserScreenState();
}

class _LaravelBrowserScreenState extends State<LaravelBrowserScreen> {
  late final WebViewController _controller;
  final TextEditingController _urlController =
      TextEditingController(text: 'http://192.168.38.152:8000');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Handle error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${error.description}')),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse('http://192.168.38.152:8000'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laravel Project Browser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    _controller.loadRequest(Uri.parse(_urlController.text));
                  },
                ),
              ),
              onSubmitted: (value) {
                _controller.loadRequest(Uri.parse(value));
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
