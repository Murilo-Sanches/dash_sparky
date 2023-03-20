import 'package:dash_sparky/core/dash_sparky_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

abstract class PowerUp extends SpriteComponent
    with HasGameRef<DashSparkyGame>, CollisionCallbacks {
  PowerUp({super.position}) : super(size: Vector2.all(50), priority: 2);

  final hitbox = RectangleHitbox();
  double get jumpSpeedMultiplier;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitbox);
  }
}

class Rocket extends PowerUp {
  Rocket({super.position});

  @override
  double get jumpSpeedMultiplier => 3.5;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/rocket_1.png');
    size = Vector2(50, 70);
  }
}

class NooglerHat extends PowerUp {
  NooglerHat({super.position});

  @override
  double get jumpSpeedMultiplier => 2.5;

  final int activeLengthInMS = 5000;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/noogler_hat.png');
    size = Vector2(75, 50);
  }
}
