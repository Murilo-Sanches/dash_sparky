import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:dash_sparky/core/widgets/overlays.dart';
import 'package:dash_sparky/core/dash_sparky_game.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'GAME OVER',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(),
              ),
              const WhiteSpace(
                height: 50,
              ),
              ScoreDisplay(
                game: game,
                isLight: true,
              ),
              const WhiteSpace(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    (game as DashSparkyGame).resetGame();
                  },
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 75)),
                      textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.titleLarge)),
                  child: const Text('Jogar denovo'))
            ],
          ),
        ),
      ),
    );
  }
}
