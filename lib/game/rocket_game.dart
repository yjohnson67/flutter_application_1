import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class RocketGame extends FlameGame with DragCallbacks {
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

  bool isLaunched = false;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'background.png',
      'stars.png',
      'ground.png',
      'rocket_white.png',
    ]);

    // Background (fills screen)
    background = SpriteComponent(
      sprite: Sprite(images.fromCache('background.png')),
      size: size,
      position: Vector2.zero(),
    );
    add(background);

    // Stars overlay (fills screen)
    stars = SpriteComponent(
      sprite: Sprite(images.fromCache('stars.png')),
      size: size,
      position: Vector2.zero(),
    );
    add(stars);

    // Ground (bottom strip)
    ground = SpriteComponent(
      sprite: Sprite(images.fromCache('ground.png')),
      size: Vector2(size.x, size.y * 0.18),
      position: Vector2(0, size.y - (size.y * 0.18)),
    );
    add(ground);

    // Rocket
    rocket = Rocket(
      sprite: Sprite(images.fromCache('rocket_white.png')),
      tintColor: favoriteColor,
    )
      ..size = Vector2(96, 96)
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y - (ground.size.y + 70));

    add(rocket);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Drag rocket left/right (simple)
    rocket.position.x += event.localDelta.x;

    // Keep it inside screen
    rocket.position.x = rocket.position.x.clamp(rocket.size.x / 2, size.x - rocket.size.x / 2);

    // Launch behavior (first time user moves)
    if (!isLaunched) {
      isLaunched = true;
      ground.removeFromParent(); // remove the ground once game starts
    }
  }
}

class Rocket extends SpriteComponent {
  Rocket({
    required super.sprite,
    required this.tintColor,
  });

  final Color tintColor;

  @override
  void render(Canvas canvas) {
    // Tint the rocket using a color filter so you can keep the rocket asset white
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(tintColor, BlendMode.srcIn);

    sprite?.render(
      canvas,
      size: size,
      overridePaint: paint,
    );
  }
}

