import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

// Component to create a dialog when leveling up, to be shown in the Result screen
class LevelUpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    playSound();
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0.00),
      elevation: 3.5,
      content: Image.asset('assets/level_up.png'),
      shape: CircleBorder(),
    );
  }

  // This will play a sound when level up
  void playSound() {
    print('Clicked');
    final player = AudioCache();
    player.play('level_up.wav');
  }
}
