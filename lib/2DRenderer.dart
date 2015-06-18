part of Trigon420;

class CanvasRenderer {
  GameCanvas __game;
  CanvasRenderingContext2D __render;
  ImageData d, s;
  bool __scale;

  CanvasRenderer(this.__game) {
    this.__render = this.__game.context2d;
    this.d = this.__render.createImageData(this.__game.gameWidth, this.__game.gameHeight);
    if (this.__game.__scale > 1) {
      this.s = this.__render.createImageData(this.__game.canvasWidth, this.__game.canvasHeight);
      this.__scale = true;
    } else {
      this.__scale = false;
    }
  }

  void flip() {
    this.__render.clearRect(0, 0, this.__game.canvasWidth, this.__game.canvasHeight);
    this.d.data.setAll(0, this.__game.__bitmap.pixels);

    if (this.__scale) {
      this.scaleImageData();
      this.__render.putImageData(this.s, 0, 0);
    } else {
      this.__render.putImageData(this.d, 0, 0);
    }
  }

  void scaleImageData() {
    for (int i = 0; i < this.__game.canvasHeight; i++) {
      for (int j = 0; j < this.__game.canvasWidth; j++) {
        int y = min((i / this.__game.__scale).round(), this.__game.gameHeight - 1) * this.__game.gameWidth;
        int x = min((j / this.__game.__scale).round(), this.__game.gameWidth - 1);
        int spos = 4 * ((this.__game.canvasWidth * i) + j);
        int dpos = 4 * (y + x);


        this.s.data[spos] = this.d.data[dpos];
        this.s.data[spos + 1] = this.d.data[dpos + 1];
        this.s.data[spos + 2] = this.d.data[dpos + 2];
        this.s.data[spos + 3] = this.d.data[dpos + 3];
      }
    }
  }
}