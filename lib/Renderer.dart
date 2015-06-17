part of Trigon420;

class Renderer {
  GameCanvas canvas;

  int color;

  int get colorR => (this.color >> 24) & 0x000000FF;

  int get colorG => (this.color >> 16) & 0x000000FF;

  int get colorB => (this.color >> 8) & 0x000000FF;

  int get colorA => (this.color) & 0x000000FF;

  Renderer(this.canvas);

  void clear(int color) {
    int back = this.color;
    this.color = color;
    this.fillRectXy(0, 0, this.canvas.__width - 1, this.canvas.__height - 1);
    this.color = back;
  }

  void drawPixel(num x, num y) {
    x = x.toInt();
    y = y.toInt();
    
    if (x >= 0 && x < this.canvas.gameWidth && y >= 0 && y < this.canvas.gameHeight) {
      
      if (this.canvas.isWebgl) {
        this.canvas.__pixels[y * this.canvas.__width + x] = this.color;
      } else {
        this.canvas.__pixels[4 * (y * this.canvas.__width + x)] = this.colorR;
        this.canvas.__pixels[4 * (y * this.canvas.__width + x) + 1] = this.colorG;
        this.canvas.__pixels[4 * (y * this.canvas.__width + x) + 2] = this.colorB;
        this.canvas.__pixels[4 * (y * this.canvas.__width + x) + 3] = this.colorA;
      }
    }
  }

  void drawPixelVec(Vector2 pos) => this.drawPixel(pos.x, pos.y);

  void fillRectXy(num x0, num y0, num x1, num y1) {
    for (num x = x0; x <= x1; x++) {
      for (num y = y0; y <= y1; y++) {
        this.drawPixel(x, y);
      }
    }
  }

  void fillRect(Rectangle rect) => this.fillRectVec(rect.pos1, rect.pos2);

  void fillRectVec(Vector2 pos0, Vector2 pos1) => this.fillRectXy(pos0.x, pos0.y, pos1.x, pos1.y);

  void drawRectXy(num x0, num y0, num x1, num y1) {
    this.__drawVLine(y0, y1, x0);
    this.__drawVLine(y0, y1, x1);
    this.__drawHLine(x0, x1, y0);
    this.__drawHLine(x0, x1, y1);
  }

  void drawRect(Rectangle rect) => this.drawRectVec(rect.pos1, rect.pos2);

  void drawRectVec(Vector2 pos0, Vector2 pos1) => this.drawRectXy(pos0.x, pos0.y, pos1.x, pos1.y);

  void drawLine(num x0, num y0, num x1, num y1) {
    if (x0 == x1 && y0 == y1)
      this.drawPixel(x0, y0);
    else if (x0 == x1)
      __drawVLine(y0, y1, x0);
    else if (y0 == y1)
      __drawHLine(x0, x1, y0);
    else
      __drawOtherLine(x0, y0, x1, y1);
  }

  void __drawHLine(num x0, num x1, num y) {
    for (num i = x0; i <= x1; i++) {
      this.drawPixel(i, y);
    }
  }

  void __drawVLine(num y0, num y1, num x) {
    for (num i = y0; i <= y1; i++) {
      this.drawPixel(x, i);
    }
  }

  void __drawOtherLine(num x0, num y0, num x1, num y1) {
    num deltaX = x1 - x0;
    num deltaY = y1 - y0;
    num error = 0;
    num deltaE = (deltaY / deltaX).abs();
    num y = y0;
    for (num x = x0; x <= x1; x++) {
      this.drawPixel(x, y);
      error += deltaE;
      while (error >= 0.5) {
        this.drawPixel(x, y);
        y += (y1 - y0);
        error -= 1.0;
      }
    }
  }


}