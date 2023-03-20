import 'package:flame/components.dart';

import 'package:dash_sparky/core/dash_sparky_game.dart';

class LevelManager extends Component with HasGameRef<DashSparkyGame> {
  LevelManager({this.selectedLevel = 1, this.level = 1});

  // + level que o player seleciona no início
  int selectedLevel;
  // + level atual
  int level;

  // + configurações para diferentes níveis de dificuldade
  // * quanto mais alto o nível, mais longe o personagem pode precisar pular
  // * já que a gravidade é constante, o jumpSpeed precisa acomodar distâncias
  // * maiores. Score define a pontuação necessária pra passar de level
  final Map<int, Difficulty> levelsConfig = {
    1: const Difficulty(
        minDistance: 200, maxDistance: 300, jumpSpeed: 600, score: 0),
    2: const Difficulty(
        minDistance: 200, maxDistance: 400, jumpSpeed: 650, score: 20),
    3: const Difficulty(
        minDistance: 200, maxDistance: 500, jumpSpeed: 700, score: 40),
    4: const Difficulty(
        minDistance: 200, maxDistance: 600, jumpSpeed: 750, score: 80),
    5: const Difficulty(
        minDistance: 200, maxDistance: 700, jumpSpeed: 800, score: 100)
  };

  double get minDistance {
    return levelsConfig[level]!.minDistance;
  }

  double get maxDistance {
    return levelsConfig[level]!.maxDistance;
  }

  double get startingJumpSpeed {
    return levelsConfig[selectedLevel]!.jumpSpeed;
  }

  double get jumpSpeed {
    return levelsConfig[level]!.jumpSpeed;
  }

  Difficulty get difficulty => levelsConfig[level]!;

  bool shouldLevelUp(int score) {
    // + nextLevel é o nível atual mais 1
    int nextLevel = level + 1;

    // + se nas configs não contém o nextLevel, return false (não existe próximo)
    if (!levelsConfig.containsKey(nextLevel)) {
      return false;
    }

    // * caso exista o score do nextLevel vai ser comparado com o score recebido
    // * da função para analisar se o player está apto para alcançar o próximo
    // * level, Ex: Estou no level 2 (nextLevel = 3), level 3 existe nas configs
    // * o score que a função recebeu é igual a 40 ? sim / não
    return levelsConfig[nextLevel]!.score == score;
  }

  List<int> get levels {
    return levelsConfig.keys.toList();
  }

  void increaseLevel() {
    if (level < levelsConfig.keys.length) {
      level++;
    }
  }

  void setLevel(int newLevel) {
    if (levelsConfig.containsKey(newLevel)) {
      level = newLevel;
    }
  }

  void selectLevel(int selectLevel) {
    if (levelsConfig.containsKey(selectLevel)) {
      level = selectLevel;
    }
  }

  void reset() {
    level = selectedLevel;
  }
}

class Difficulty {
  const Difficulty(
      {required this.minDistance,
      required this.maxDistance,
      required this.jumpSpeed,
      required this.score});

  final double minDistance;
  final double maxDistance;
  final double jumpSpeed;
  final int score;
}
