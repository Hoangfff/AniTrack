import 'dart:convert';
import 'package:flutter/material.dart';

// Thư viện đặc thù dành cho môi trường Web
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MegaPlay Iframe Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IframeTestScreen(),
    );
  }
}

class IframeTestScreen extends StatefulWidget {
  const IframeTestScreen({Key? key}) : super(key: key);

  @override
  State<IframeTestScreen> createState() => _IframeTestScreenState();
}

class _IframeTestScreenState extends State<IframeTestScreen> {
  final String viewType = 'megaplay-iframe';
  
  @override
  void initState() {
    super.initState();
    
    // Đăng ký thẻ Iframe (Chỉ chạy được trên Web)
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = 'https://megaplay.buzz/stream/mal/20/1/sub' // Naruto tập 1
        ..style.border = 'none'
        ..allowFullscreen = true;
      return iframe;
    });

    // Lắng nghe sự kiện postMessage từ MegaPlay
    html.window.onMessage.listen((html.MessageEvent event) {
      try {
        if (event.data is String) {
          final data = jsonDecode(event.data);
          print("Iframe Message Received: \$data");
          if (data['event'] == 'complete') {
            _showCompletionDialog();
          }
        }
      } catch (e) {
        // Bỏ qua các message không phải JSON
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Chúc mừng'),
        content: const Text('Bạn đã xem xong tập phim (Nhận được sự kiện "complete" từ MegaPlay).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MegaPlay Iframe POC')),
      body: Center(
        child: SizedBox(
          width: 800,
          height: 450, // Tỉ lệ khung hình 16:9
          child: HtmlElementView(viewType: viewType),
        ),
      ),
    );
  }
}
