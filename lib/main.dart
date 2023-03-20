import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dash_sparky/core/utilities/utilities.dart';
import 'package:dash_sparky/core/dash_sparky_game.dart';
import 'package:dash_sparky/core/widgets/overlays.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dash Sparky',
      themeMode: ThemeMode.dark,
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
          textTheme:
              // + audiowideTextTheme é uma fonte do google fonts!
              // * da para acessar a merriweather também
              GoogleFonts.audiowideTextTheme(ThemeData.dark().textTheme)),
      home: const GameContainer(title: 'Dash Sparky'),
    );
  }
}

class GameContainer extends StatefulWidget {
  const GameContainer({super.key, required this.title});
  final String title;

  @override
  State<GameContainer> createState() => _GameContainerState();
}

class _GameContainerState extends State<GameContainer> {
  late final Game _gameContainer;

  @override
  void initState() {
    _gameContainer = DashSparkyGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        // + LayoutBuilder - controla o tamanho do layout com constraints
        child: LayoutBuilder(builder: (context, constraints) {
          // * Container - box genérico, seu tamanho vai ficar alinhado com o
          // * LayoutBuilder (BoxConstraints())
          return Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
              minWidth: 550,
            ),
            // + Renders a [game] in a flutter widget tree.
            child: GameWidget(
              game: _gameContainer,
              // + mostra os overlays do game
              // * recebe um map de string (key) e Widget Function(BuildContext, Game)
              // * Widget Function(BuildContext, Game) - função que recebe
              // * context e game e retorna um Widget
              // * 'generic': (context, game) => Widget(game)
              overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
                'gameOverlay': (context, game) => GameOverlay(game),
                'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
                'gameOverOverlay': (context, game) => GameOverOverlay(game),
              },
            ),
          );
        }),
      ),
    );
  }
}
