library Trigon420.example;

import 'package:Trigon420/Trigon420.dart';

main() {
  GameCanvas c = new GameCanvas("game", 500, 500);
  c.renderable = new CustomRenderable(c);
  c.loop();
}

class CustomRenderable extends Renderable {
  GameCanvas canvas;

  CustomRenderable(this.canvas);

  @override
  void tick(int ticks) {

  }

  @override
  void renderTick(double ptt) {
    this.canvas.renderer.color = 0xABCDEF;
    this.canvas.renderer.drawRect(100, 100, 200, 200);
  }
}