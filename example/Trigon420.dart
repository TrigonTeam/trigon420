library Trigon420.example;

import 'package:Trigon420/Trigon420.dart';

main() {
  GameCanvas c = new GameCanvas("game", 100, 100, 5);

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

  @override
  void tick(int ticks) {

  }

  @override
  void renderTick(double ptt) {
    this.canvas.renderer.color = 0xFF0000FF;
    this.canvas.renderer.drawRect(19, 19, 79, 79);
    this.canvas.renderer.color = 0x0000FFFF;
    this.canvas.renderer.fillRect(20, 20, 78, 78);
    this.canvas.renderer.color = 0x00FF0088;
    this.canvas.renderer.drawLine(0, 0, 0, 99);
    this.canvas.renderer.drawLine(49, 0, 49, 99);
    this.canvas.renderer.drawLine(99, 0, 99, 99);
  }
}