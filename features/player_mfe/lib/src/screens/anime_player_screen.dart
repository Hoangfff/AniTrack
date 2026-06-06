// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';

// Thư viện đặc thù dành cho môi trường Web
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:shared_core/shared_core.dart';

class AnimePlayerScreen extends StatefulWidget {
  final int malId;
  final int episodeNumber;
  final String language;

  const AnimePlayerScreen({
    super.key,
    required this.malId,
    required this.episodeNumber,
    this.language = 'sub',
  });

  @override
  State<AnimePlayerScreen> createState() => _AnimePlayerScreenState();
}

class _AnimePlayerScreenState extends State<AnimePlayerScreen> {
  late final String viewType;
  late final String embedUrl;

  @override
  void initState() {
    super.initState();
    
    // Tạo ID độc nhất cho mỗi iframe để tránh conflict
    viewType = 'megaplay-iframe-${widget.malId}-${widget.episodeNumber}';
    
    // Sử dụng MegaPlayHelper từ shared_core để sinh link
    embedUrl = MegaPlayHelper.generateEmbedUrl(
      malId: widget.malId,
      episodeNumber: widget.episodeNumber,
      lang: widget.language,
    );

    // Đăng ký thẻ Iframe (Chỉ chạy trên Web)
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = embedUrl
        ..style.border = 'none'
        ..allowFullscreen = true;
      return iframe;
    });

    // Lắng nghe sự kiện postMessage
    html.window.onMessage.listen(_onMessageReceived);
  }

  void _onMessageReceived(html.MessageEvent event) {
    try {
      if (event.data is String) {
        final data = jsonDecode(event.data);
        if (data['event'] == 'complete') {
          // Bắn sự kiện VideoCompletedEvent vào hệ thống EventBus của shared_core
          eventBus.fire(VideoCompletedEvent(widget.malId.toString(), widget.episodeNumber));
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã xem xong tập phim! (Đã bắn tín hiệu đồng bộ)'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Bỏ qua các dữ liệu không phải JSON
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Tập ${widget.episodeNumber}'),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: HtmlElementView(viewType: viewType),
        ),
      ),
    );
  }
}
