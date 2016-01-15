part of Trigon420;

class CanvasRenderer {
  GameCanvas __game;
  CanvasRenderingContext2D __render;
  ImageData d, s;

  CanvasRenderer(this.__game) {
    this.__render = this.__game.context2d;
    this.d = this.__render.createImageData(this.__game.gameWidth, this.__game.gameHeight);
  }

  void flip() {
    this.__render.clearRect(
        0, 0, this.__game.canvasWidth, this.__game.canvasHeight);
    this.d.data.setAll(0, this.__game.__bitmap.pixels);
    this.__render.putImageData(this.d, 0, 0);
  }
}