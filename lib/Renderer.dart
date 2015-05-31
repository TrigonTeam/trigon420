part of Trigon420;

class Renderer {
  GameCanvas canvas;
  int color;

  Renderer(this.canvas);

  void clear(int color) {
    int back = this.color;
    this.color = color;
    this.fillRect(0, 0, this.canvas.__width, this.canvas.__height);
    this.color = back;
  }

  void drawPixel(int x, int y) {
    this.canvas.__pixels[y * this.canvas.__width + x] = this.color;
  }

  void drawPixelVec(Vector2 pos) => this.drawPixel(pos.x, pos.y);

  void fillRect(int x0, int y0, int x1, int y1) {
    for(int x = x0; x <= x1; x++) {
      for(int y = y0; y <= y1; y++) {
        this.drawPixel(x, y);
      }
    }
  }

  void fillRectVec(Vector2 pos0, Vector2 pos1) => this.fillRect(pos0.x, pos0.y, pos1.x, pos1.y);

  void drawRect(int x0, int y0, int x1, int y1) {
    this.__drawVLine(y0, y1, x0);
    this.__drawVLine(y0, y1, x1);
    this.__drawHLine(x0, x1, y0);
    this.__drawHLine(x0, x1, y1);
  }

  void drawRectVec(Vector2 pos0, Vector2 pos1) => this.drawRect(pos0.x, pos0.y, pos1.x, pos1.y);

  void drawLine(int x0, int y0, int x1, int y1) {
    if(x0 == x1 && y0 == y1)
      this.drawPixel(x0, y0);
    else if(x0 == x1)
      __drawVLine(y0, y1, x0);
    else if(y0 == y1)
      __drawHLine(x0, x1, y0);
    else
      __drawOtherLine(x0, y0, x1, y1);
  }

  void __drawHLine(int x0, int x1, int y) {
    for(int i = x0; i <= x1; i++) {
      this.drawPixel(i, y);
    }
  }

  void __drawVLine(int y0, int y1, int x) {
    for(int i = y0; i <= y1; i++) {
      this.drawPixel(x, i);
    }
  }

  void __drawOtherLine(int x0, int y0, int x1, int y1) {
    num deltaX = x1 - x0;
    num deltaY = y1 - y0;
    num error = 0;
    num deltaE = (deltaY / deltaX).abs();
    int y = y0;
    for(int x = x0; x <= x1; x++) {
      this.drawPixel(x, y);
      error += deltaE;
      while(error >= 0.5) {
        this.drawPixel(x, y);
        y += (y1 - y0);
        error -= 1.0;
      }
    }
  }


}