import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'package:dash_sparky/core/world.dart';
import 'package:dash_sparky/core/managers/managers.dart';
import 'package:dash_sparky/core/sprites/sprites.dart';

enum Character { dash, sparky }

// + DashSparkyGame herda FlameGame também herda Component e Game
class DashSparkyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  // + super.children - representa os componentes que podem ser adicionados
  // * podem ser adicionados pelo constructor ou de qualquer outro lugar com
  // * os métodos add / addAll
  // * para remover existe o remove / removeAll
  DashSparkyGame({super.children});

  final World _world = World();
  final GameManager gameManager = GameManager();
  final LevelManager levelManager = LevelManager();
  ObjectManager objectManager = ObjectManager();
  // + intância de um player
  late Player player;
  final screenBufferSpace = 300;

  // + onLoad - carrega o jogo
  @override
  Future<void> onLoad() async {
    // + add é um método que existe na class Component
    await add(_world);
    await add(gameManager);
    // + overlays é uma propriedade que existe na class Game
    overlays.add('gameOverlay');
    // + DoodleDash herda FlameGame também herda Component e Game
    await add(levelManager);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.isGameOver) return;

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameManager.isPlaying) {
      checkLevelUp();

      final Rect worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace,
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
      camera.worldBounds = worldBounds;

      if (player.isMovingDown) {
        camera.worldBounds = worldBounds;
      }

      var isInTopHalfOfScreen = player.position.y <= (_world.size.y / 2);
      if (!player.isMovingDown && isInTopHalfOfScreen) {
        camera.followComponent(player);
      }

      if (player.position.y >
          camera.position.y +
              _world.size.y +
              player.size.y +
              screenBufferSpace) {
        onLose();
      }
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void initializeGameStart() {
    setCharacter();

    gameManager.reset();

    if (children.contains(objectManager)) objectManager.removeFromParent();

    levelManager.reset();

    player.reset();

    camera.worldBounds = Rect.fromLTRB(
      0,
      -_world.size.y,
      camera.gameSize.x,
      _world.size.y + screenBufferSpace,
    );
    camera.followComponent(player);

    player.resetPosition();

    objectManager = ObjectManager(
        minVerticalDistanceToNextPlatform: levelManager.minDistance,
        maxVerticalDistanceToNextPlatform: levelManager.maxDistance);

    add(objectManager);

    objectManager.configure(levelManager.level, levelManager.difficulty);
  }

  void setCharacter() {
    player = Player(
        character: gameManager.character,
        jumpSpeed: levelManager.startingJumpSpeed);
    add(player);
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void checkLevelUp() {
    if (levelManager.shouldLevelUp(gameManager.score.value)) {
      levelManager.increaseLevel();

      objectManager.configure(levelManager.level, levelManager.difficulty);

      player.setJumpSpeed(levelManager.jumpSpeed);
    }
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    overlays.add('gameOverOverlay');
  }
}
