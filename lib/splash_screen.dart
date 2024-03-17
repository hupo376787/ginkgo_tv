import 'package:flutter/material.dart';
import './helper/splash_screen_helper.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;
  final player = Player();

  @override
  void initState() {
    super.initState();

    playSound();
  }

  void playSound() async {
    await player.open(Media('assets/sound/Netflix.wav'));
  }

  @override
  void dispose() {
    //player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenHelper(
      splashType: SplashType.lottieAnimation,
    );
  }
}
