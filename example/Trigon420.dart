library Trigon420.example;

import 'package:Trigon420/Trigon420.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math' hide Rectangle;
import 'dart:collection';

main() {
  GameCanvas c = new GameCanvas("game", 500, 500, 1);

  //try {
    c.renderable = new CustomRenderable(c);
    c.loop();
  //} catch (e, stack) {
  //  c.crash("Crash", e);
  //}
}

class CustomRenderable extends Renderable {
  GameCanvas canvas;

  CustomRenderable(this.canvas);

  HashMap<Vector2, int> snow = new HashMap<Vector2, int>();
  Random rnd = new Random();
  double speed = 2.0;

  @override
  void tick(int ticks) {
    for (int i = 0; i < 2; i++) {
      int w = 6 + rnd.nextInt(2);
      Vector2 v = new Vector2(rnd.nextInt(canvas.gameWidth).toDouble(), -w * 2.0);
      this.snow[v] = w;
    }

    for (int i = 0; i < 4; i++) {
      int w = 4 + rnd.nextInt(2);
      Vector2 v = new Vector2(rnd.nextInt(canvas.gameWidth).toDouble(), -w * 2.0);
      this.snow[v] = w;
    }

    for (int i = 0; i < 8 + rnd.nextInt(12); i++) {
      int w = 2 + rnd.nextInt(2);
      Vector2 v = new Vector2(rnd.nextInt(canvas.gameWidth).toDouble(), -w * 2.0);
      this.snow[v] = w;
    }

    for (int i = 0; i < 18 + rnd.nextInt(12); i++) {
      int w = 1 + rnd.nextInt(2);
      Vector2 v = new Vector2(rnd.nextInt(canvas.gameWidth).toDouble(), -w * 2.0);
      this.snow[v] = w;
    }

    var list = [];

    this.snow.forEach((k, v) {
      k.setValues(k.x, k.y + this.speed + v * 0.5);

      if(k.y > canvas.gameHeight) {
        list.add(k);
      }
    });

    list.forEach((k) => this.snow.remove(k));
  }

  @override
  void renderTick(double ptt) {
    this.canvas.renderer.clear(0xB0B0B0FF);
    this.canvas.renderer.color = 0xFFFFFFFF;

    this.snow.forEach((k, v) {
      double cY = (this.speed + v * 0.5) * ptt;
      this.canvas.renderer.fillRectXy(k.x, k.y + cY, k.x + v, k.y + cY + v);
    });

  }
}