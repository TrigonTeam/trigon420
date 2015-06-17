library Trigon420.example;

import 'package:Trigon420/Trigon420.dart';
import 'dart:math';

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
  
  List<Rectangle> snow = new List<Rectangle>();
  Random rnd = new Random();
  double speed = 2.0;

  @override
  void tick(int ticks) {
    for (int i = 0; i < 2; i++) {
      int w = 6 + rnd.nextInt(2);
      Rectangle r = Rectangle.xywh(rnd.nextInt(canvas.gameWidth), -w * 2, w, w);
      this.snow.add(r);
    }

    for (int i = 0; i < 4; i++) {
      int w = 4 + rnd.nextInt(2);
      Rectangle r = Rectangle.xywh(rnd.nextInt(canvas.gameWidth), -w * 2, w, w);
      this.snow.add(r);
    }

    for (int i = 0; i < 8 + rnd.nextInt(12); i++) {
      int w = 2 + rnd.nextInt(2);
      Rectangle r = Rectangle.xywh(rnd.nextInt(canvas.gameWidth), -w * 2, w, w);
      this.snow.add(r);
    }

    for (int i = 0; i < 18 + rnd.nextInt(12); i++) {
      int w = 1 + rnd.nextInt(2);
      Rectangle r = Rectangle.xywh(rnd.nextInt(canvas.gameWidth), -w * 2, w, w);
      this.snow.add(r);
    }

    var list = [];

    this.snow.forEach((r) {
      num size = r.size.x;
      Rectangle nr = Rectangle.xywh(r.pos1.x, r.pos1.y + this.speed + size * 0.5, size, size);

      if(nr.pos2.y < canvas.gameHeight) {
        list.add(nr);
      }
    });

    this.snow = list;
  }

  @override
  void renderTick(double ptt) {
    this.canvas.renderer.clear(0xB0B0B0FF);
    this.canvas.renderer.color = 0xFFFFFFFF;

    this.snow.forEach((r) {
      double cY = (this.speed + r.size.x * 0.5) * ptt;
      this.canvas.renderer.fillRectXy(r.pos1.x, r.pos1.y + cY, r.pos2.x, r.pos2.y + cY);
    });

  }
}