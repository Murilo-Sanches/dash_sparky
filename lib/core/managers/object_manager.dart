import 'dart:math';
import 'package:dash_sparky/core/sprites/powerup.dart';
import 'package:flame/components.dart';

import 'package:dash_sparky/core/dash_sparky_game.dart';
import 'package:dash_sparky/core/utilities/utilities.dart';
import 'package:dash_sparky/core/sprites/platform.dart';
import 'package:dash_sparky/core/managers/managers.dart';

final Random _rand = Random();

class ObjectManager extends Component with HasGameRef<DashSparkyGame> {
  ObjectManager(
      {this.minVerticalDistanceToNextPlatform = 200,
      this.maxVerticalDistanceToNextPlatform = 300});

  double minVerticalDistanceToNextPlatform;
  double maxVerticalDistanceToNextPlatform;

  final probabilityGenerator = ProbabilityGenerator();
  final double _tallestPlatformHeight = 50;
  final List<Platform> _platforms = [];

  final Map<String, bool> specialPlatforms = {
    'spring': true, // + level 1
    'broken': false, // + level 2
    'noogler': false, // + level 3
    'rocket': false, // + level 4
    'enemy': false, // + level 5
  };

  @override
  void update(double dt) {
    final topOfLowestPlatform =
        _platforms.first.position.y + _tallestPlatformHeight;

    final screenBotton = gameRef.player.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    if (topOfLowestPlatform > screenBotton) {
      var newPlatY = _generateNextY();
      var newPlatX = _generateNextX(100);
      final nextPlat = _semiRandomPlatform(Vector2(newPlatX, newPlatY));

      add(nextPlat);

      _platforms.add(nextPlat);
      gameRef.gameManager.increaseScore();

      _cleanupPlatforms();
      _maybeAddPowerUp();
      _maybeAddEnemy();
    }

    super.update(dt);
  }

  @override
  void onMount() {
    super.onMount();

    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;
    var currentY =
        gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 3) - 50;

    for (var i = 0; i < 9; i++) {
      if (i != 0) {
        currentX = _generateNextX(100);
        currentY = _generateNextY();
      }

      _platforms.add(_semiRandomPlatform(Vector2(currentX, currentY)));
      add(_platforms[i]);
    }
  }

  void _cleanupPlatforms() {
    final lowestPlat = _platforms.removeAt(0);

    // + removeFromParent - remove o componente do seu pai no próximo tick
    lowestPlat.removeFromParent();
  }

  void enableSpecialty(String specialty) {
    specialPlatforms[specialty] = true;
  }

  void enableLevelSpecialty(int level) {
    switch (level) {
      case 1:
        enableSpecialty('spring');
        break;
      case 2:
        enableSpecialty('broken');
        break;
      case 3:
        enableSpecialty('noogler');
        break;
      case 4:
        enableSpecialty('rocket');
        break;
      case 5:
        enableSpecialty('enemy');
        break;

      default:
    }
  }

  void resetSpecialties() {
    for (var key in specialPlatforms.keys) {
      specialPlatforms[key] = false;
    }
  }

  void configure(int nextLevel, Difficulty config) {
    minVerticalDistanceToNextPlatform = gameRef.levelManager.minDistance;
    maxVerticalDistanceToNextPlatform = gameRef.levelManager.maxDistance;

    for (int i = 1; i <= nextLevel; i++) {
      enableLevelSpecialty(i);
    }
  }

  double _generateNextX(int platformWidth) {
    final previousPlatformXRange = Range(
        _platforms.last.position.x, _platforms.last.position.x + platformWidth);

    double nextPlatformAnchorX;

    do {
      nextPlatformAnchorX =
          _rand.nextInt(gameRef.size.x.floor() - platformWidth).toDouble();
    } while (previousPlatformXRange.overlaps(
        Range(nextPlatformAnchorX, nextPlatformAnchorX + platformWidth)));

    return nextPlatformAnchorX;
  }

  double _generateNextY() {
    final currentHighestPlatformY =
        _platforms.last.center.y + _tallestPlatformHeight;

    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        _rand
            .nextInt((maxVerticalDistanceToNextPlatform -
                    minVerticalDistanceToNextPlatform)
                .floor())
            .toDouble();

    return currentHighestPlatformY - distanceToNextY;
  }

  Platform _semiRandomPlatform(Vector2 position) {
    if (specialPlatforms['spring'] == true &&
        probabilityGenerator.generateWithProbability(15)) {
      return SpringBoard(position: position);
    }

    if (specialPlatforms['broken'] == true &&
        probabilityGenerator.generateWithProbability(10)) {
      return BrokenPlatform(position: position);
    }

    return NormalPlatform(position: position);
  }

  final List<EnemyPlatform> _enemies = [];
  void _maybeAddEnemy() {
    if (specialPlatforms['enemy'] != true) return;

    if (probabilityGenerator.generateWithProbability(20)) {
      var enemy = EnemyPlatform(
        position: Vector2(_generateNextX(100), _generateNextY()),
      );
      add(enemy);
      _enemies.add(enemy);
      _cleanupEnemies();
    }
  }

  void _cleanupEnemies() {
    final screenBottom = gameRef.player.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    while (_enemies.isNotEmpty && _enemies.first.position.y > screenBottom) {
      remove(_enemies.first);
      _enemies.removeAt(0);
    }
  }

  final List<PowerUp> _powerUps = [];
  void _maybeAddPowerUp() {
    if (specialPlatforms['noogler'] == true &&
        probabilityGenerator.generateWithProbability(20)) {
      var nooglerHat = NooglerHat(
        position: Vector2(_generateNextX(75), _generateNextY()),
      );
      add(nooglerHat);
      _powerUps.add(nooglerHat);
    } else if (specialPlatforms['rocket'] == true &&
        probabilityGenerator.generateWithProbability(50)) {
      var rocket = Rocket(
        position: Vector2(_generateNextX(50), _generateNextY()),
      );
      add(rocket);
      _powerUps.add(rocket);
    }

    _cleanupPowerUps();
  }

  void _cleanupPowerUps() {
    final screenBottom = gameRef.player.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    while (_powerUps.isNotEmpty && _powerUps.first.position.y > screenBottom) {
      if (_powerUps.first.parent != null) {
        remove(_powerUps.first);
      }
      _powerUps.removeAt(0);
    }
  }
}
