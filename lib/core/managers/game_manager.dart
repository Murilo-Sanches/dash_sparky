import 'package:flame/components.dart';

import 'package:dash_sparky/core/dash_sparky_game.dart';
import 'package:flutter/material.dart';

enum GameState { intro, playing, gameOver }

class GameManager extends Component with HasGameRef<DashSparkyGame> {
  GameManager();

  Character character = Character.dash;
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;

  bool get isIntro => state == GameState.intro;
  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;

  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;
  }

  void selectCharacter(Character selectedCharacter) {
    character = selectedCharacter;
  }
}
