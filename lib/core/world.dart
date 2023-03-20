import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import 'package:dash_sparky/core/dash_sparky_game.dart';
import 'package:flutter/material.dart';

// + o <T> do ParallaxComponent vai ser referenciado em gameRef
class World extends ParallaxComponent<DashSparkyGame> {
  // + onLoad vai carregar o background
  @override
  Future<void> onLoad() async {
    // * gameRef referencia ao jogo passado no génerico do ParallaxComponent
    // * loadParallax recebe um array com imagens para criar o parallax
    parallax = await gameRef.loadParallax([
      ParallaxImageData('game/background/06_Background_Solid.png'),
      ParallaxImageData('game/background/05_Background_Small_Stars.png'),
      ParallaxImageData('game/background/04_Background_Big_Stars.png'),
      ParallaxImageData('game/background/02_Background_Orbs.png'),
      ParallaxImageData('game/background/03_Background_Block_Shapes.png'),
      ParallaxImageData('game/background/01_Background_Squiggles.png'),
    ],
        // + preencher a largura dinâmicamente de acordo com a tela
        fill: LayerFill.width,
        // + igual css
        repeat: ImageRepeat.repeat,
        // * velocidade base do parallax
        // * -5 vai pra cima e 5 vai pra baixo os eixos do plano são invertidos
        baseVelocity: Vector2(0, -5),
        // + delta (variação) que multiplica a velocidade base
        velocityMultiplierDelta: Vector2(0, 1.2));
  }
}
