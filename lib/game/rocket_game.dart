import 'dart:convert';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RocketGame extends FlameGame with DragCallbacks, HasCollisionDetection {
  RocketGame({
    required this.playerName,
    required this.favoriteColor,
  });

  final String playerName;
  final Color favoriteColor;

  late final SpriteComponent background;
  late final SpriteComponent stars;
  late final SpriteComponent ground;
  late final Rocket rocket;
  late final TextComponent scoreText;

  final Random random = Random();

  double obstacleTimer = 0;
  double score = 0;
  bool isLaunched = false;
  bool isGameOver = false;
  bool isSavingScore = false;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'background.png',
      'stars.png',
      'ground.png',
      'rocket_white.png',
      'planet1.png',
      'planet2.png',
      'moon.png',
      'ui_box.png',
    ]);

    background = SpriteComponent(
      sprite: Sprite(images.fromCache('background.png')),
      size: size,
      position: Vector2.zero(),
    );
    add(background);

    stars = SpriteComponent(
      sprite: Sprite(images.fromCache('stars.png')),
      size: size,
      position: Vector2.zero(),
    );
    add(stars);

    ground = SpriteComponent(
      sprite: Sprite(images.fromCache('ground.png')),
      size: Vector2(size.x, size.y * 0.18),
      position: Vector2(0, size.y - (size.y * 0.18)),
    );
    add(ground);

    rocket = Rocket(
      sprite: Sprite(images.fromCache('rocket_white.png')),
      tintColor: favoriteColor,
    )
      ..size = Vector2(96, 96)
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y - (ground.size.y + 70));

    add(rocket);

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(16, 16),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) return;

    if (isLaunched) {
      score += dt * 10;
      scoreText.text = 'Score: ${score.toInt()}';

      obstacleTimer += dt;

      if (obstacleTimer > 1.2) {
        spawnObstacle();
        obstacleTimer = 0;
      }
    }
  }

  void spawnObstacle() {
    final obstacleImages = ['planet1.png', 'planet2.png', 'moon.png'];
    final imageName = obstacleImages[random.nextInt(obstacleImages.length)];

    final obstacle = FallingObstacle(
      sprite: Sprite(images.fromCache(imageName)),
    )
      ..size = Vector2(72, 72)
      ..position = Vector2(
        random.nextDouble() * (size.x - 72),
        -80,
      );

    add(obstacle);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isGameOver) return;

    rocket.position.x += event.localDelta.x;

    rocket.position.x = rocket.position.x.clamp(
      rocket.size.x / 2,
      size.x - rocket.size.x / 2,
    );

    if (!isLaunched) {
      isLaunched = true;
      ground.removeFromParent();
    }
  }

  Future<void> saveScoreToDjango(int finalScore) async {
    if (isSavingScore) return;
    isSavingScore = true;

    const String url = 'http://10.0.2.2:8000/save-test-score/';

    final payload = {
      'player_name': playerName,
      'rocket_color': '#${favoriteColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
      'score': finalScore,
    };

    try {
      debugPrint('Sending score to Django...');
      debugPrint('POST $url');
      debugPrint('Payload: $payload');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      debugPrint('Save response status: ${response.statusCode}');
      debugPrint('Save response body: ${response.body}');
    } catch (e) {
      debugPrint('Error saving score: $e');
    } finally {
      isSavingScore = false;
    }
  }

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    final int finalScore = score.toInt();

    saveScoreToDjango(finalScore);

    add(
      GameOverPanel(
        finalScore: finalScore,
        onRestart: resetGame,
      )
        ..position = Vector2(size.x / 2, size.y / 2)
        ..anchor = Anchor.center,
    );
  }

  void resetGame() {
    isGameOver = false;
    isLaunched = false;
    score = 0;
    obstacleTimer = 0;
    scoreText.text = 'Score: 0';

    children.whereType<FallingObstacle>().toList().forEach((o) => o.removeFromParent());
    children.whereType<GameOverPanel>().toList().forEach((p) => p.removeFromParent());

    if (ground.parent == null) {
      add(ground);
    }

    rocket.position = Vector2(size.x / 2, size.y - (ground.size.y + 70));
  }
}

class Rocket extends SpriteComponent with CollisionCallbacks {
  Rocket({
    required super.sprite,
    required this.tintColor,
  });

  final Color tintColor;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(tintColor, BlendMode.srcIn);

    sprite?.render(
      canvas,
      size: size,
      overridePaint: paint,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is FallingObstacle) {
      final game = findGame() as RocketGame?;
      game?.gameOver();
    }
  }
}

class FallingObstacle extends SpriteComponent with CollisionCallbacks {
  FallingObstacle({
    required super.sprite,
  });

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    final game = findGame() as RocketGame?;
    if (game == null) return;
    if (game.isGameOver) return;

    position.y += 220 * dt;

    if (position.y > game.size.y + 100) {
      removeFromParent();
    }
  }
}

class GameOverPanel extends PositionComponent with TapCallbacks {
  GameOverPanel({
    required this.finalScore,
    required this.onRestart,
  });

  final int finalScore;
  final VoidCallback onRestart;

  late final SpriteComponent panelBox;

  @override
  Future<void> onLoad() async {
    final game = findGame() as RocketGame;

    size = Vector2(280, 220);

    panelBox = SpriteComponent(
      sprite: Sprite(game.images.fromCache('ui_box.png')),
      size: size,
      position: Vector2.zero(),
    );
    add(panelBox);

    add(
      TextComponent(
        text: 'GAME OVER',
        position: Vector2(size.x / 2, 50),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.red,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    add(
      TextComponent(
        text: 'Final Score: $finalScore',
        position: Vector2(size.x / 2, 95),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    add(
      RestartButton(onPressed: onRestart)
        ..position = Vector2(size.x / 2, 155)
        ..anchor = Anchor.center,
    );
  }
}

class RestartButton extends PositionComponent with TapCallbacks {
  RestartButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Future<void> onLoad() async {
    size = Vector2(140, 44);

    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.blueAccent,
      ),
    );

    add(
      TextComponent(
        text: 'Restart',
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
    removeFromParent();
  }
}