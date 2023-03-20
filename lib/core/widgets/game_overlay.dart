// + show - retorna apenas a parte da library especificada
import 'dart:io' show Platform;
// + hide - importa tudo menos a parte da library especificada
// - import 'dart:io' hide Platform;
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:dash_sparky/core/widgets/overlays.dart';
import 'package:dash_sparky/core/dash_sparky_game.dart';

class GameOverlay extends StatefulWidget {
  // * no main.dart (overlayBuilderMap) GameOverlay recebe o game como argumento
  // * GameOverlay(<Game>game), isso acontece porque o constructor aceita this.game
  // * o que fica dentro de {} é opcional (null se não passado) e deve ficar no final
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  // + váriavel para controlar o estado do botão de pausa
  bool isPaused = false;

  final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      // + Stack can Overlap widgets but columns can't overlap widgets
      child: Stack(
        children: [
          // + Positioned - parecido com position no CSS, onde a Stack é relativa
          Positioned(
            top: 30,
            left: 30,
            child: ScoreDisplay(game: widget.game),
          ),
          // + botão de pause com o ícone mudando dinâmicamente
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
              child: isPaused
                  ? const Icon(Icons.play_arrow, size: 48)
                  : const Icon(Icons.pause, size: 48),
              onPressed: () {
                // * em um StatefulWidget para acessar as propriedades passadas
                // * como argumento no constructor na hora de criar o mesmo, usa-se
                // * widget.<propriedade>
                // * nesse caso, widget.game = final Game game;
                // * const GameOverlay(this.game, {super.key});
                // * final Game game;
                (widget.game as DashSparkyGame).togglePauseState();
                setState(
                  () {
                    isPaused = !isPaused;
                  },
                );
              },
            ),
          ),
          if (isMobile) // Add lines from here...
            Positioned(
              bottom: MediaQuery.of(context).size.height / 4,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: GestureDetector(
                        onTapDown: (details) {
                          (widget.game as DashSparkyGame).player.moveLeft();
                        },
                        onTapUp: (details) {
                          (widget.game as DashSparkyGame)
                              .player
                              .resetDirection();
                        },
                        child: Material(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shadowColor: Theme.of(context).colorScheme.background,
                          child: const Icon(Icons.arrow_left, size: 64),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: GestureDetector(
                        onTapDown: (details) {
                          (widget.game as DashSparkyGame).player.moveRight();
                        },
                        onTapUp: (details) {
                          (widget.game as DashSparkyGame)
                              .player
                              .resetDirection();
                        },
                        child: Material(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shadowColor: Theme.of(context).colorScheme.background,
                          child: const Icon(Icons.arrow_right, size: 64),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isPaused)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 72.0,
              right: MediaQuery.of(context).size.width / 2 - 72.0,
              child: const Icon(
                Icons.pause_circle,
                size: 144.0,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}
