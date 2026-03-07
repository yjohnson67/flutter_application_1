import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
 
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
  int score = 0;
  bool isLaunched = false;
  bool isGameOver = false;

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
      score += (dt * 10).toInt();
      scoreText.text = 'Score: $score';

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
 
  void gameOver() {

    if (isGameOver) return;

     isGameOver = true;

     add(
      TextComponent(
        text: 'GAME OVER',
        position: Vector2(size.x / 2, size.y / 2 - 40),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.red,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
 
    add(
      TextComponent(
        text: 'Final Score: $score',
        position: Vector2(size.x / 2, size.y / 2 + 10),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
 
 