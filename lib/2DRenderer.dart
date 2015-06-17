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
    this.d.data.setAll(0, this.__game.__pixels);

    if (this.__scale) {
      this.scaleImageData();
      this.__render.putImageData(this.s, 0, 0);
    } else {
      this.__render.putImageData(this.d, 0, 0);
    }
  }

  void scaleImageData() {
    var scale = this.__game.__scale;

    for (int row = 0; row < this.d.height; row++) {
      for (int col = 0; col < this.d.width; col++) {
        var sourcePixel = [
          this.d.data[(row * this.d.width + col) * 4 + 0],
          this.d.data[(row * this.d.width + col) * 4 + 1],
          this.d.data[(row * this.d.width + col) * 4 + 2],
          this.d.data[(row * this.d.width + col) * 4 + 3]
        ];

        for (var y = 0; y < scale; y++) {
          var destRow = row * scale + y;
          for (var x = 0; x < scale; x++) {
            var destCol = col * scale + x;
            for (var i = 0; i < 4; i++) {
              this.s.data[(destRow * this.s.width + destCol) * 4 + i] =
              sourcePixel[i];
            }
          }
        }
      }
    }
  }
}