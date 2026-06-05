import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

import 'src/widgets/anitrack_scaffold.dart';

void main() {
  runApp(const ProviderScope(child: AniTrackApp()));
}

class AniTrackApp extends StatelessWidget {
  const AniTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AniTrack',
      debugShowCheckedModeBanner: false,
      theme: AniTrackTheme.darkTheme(),
      home: const AniTrackScaffold(),
    );
  }
}
