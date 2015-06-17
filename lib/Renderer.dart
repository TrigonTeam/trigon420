part of Trigon420;

class Renderer {
  GameCanvas canvas;

  Bitmap bitmap;

  int color;

  int get colorR => (this.color >> 24) & 0x000000FF;

  int get colorG => (this.color >> 16) & 0x000000FF;

  int get colorB => (this.color >> 8) & 0x000000FF;

  int get colorA => (this.color) & 0x000000FF;

  Renderer(this.canvas) {
    this.useScreen();
  }

  void useScreen() {
    this.bitmap = this.canvas.__bitmap;
  }

  void clear(int color) {
    int back = this.color;
    this.color = color;
    this.fillRectXy(0, 0, this.canvas.__width - 1, this.canvas.__height - 1);
    this.color = back;
  }

  void drawPixel(num x, num y, [int color = -1]) {
    x = x.toInt();
    y = y.toInt();
    
    if (x >= 0 && x < this.bitmap.width && y >= 0 && y < this.bitmap.height) {
      this.bitmap.setPixel(x, y, color == -1 ? this.color : color, true);
    }
  }

  void drawBitmap(int x, int y, Bitmap bitmap) {
    for (int bx = 0; bx < bitmap.width; bx++) {
      for (int by = 0; by < bitmap.height; by++) {

        int px = bitmap.getPixel(bx, by);

        if ((px & 0xFF) != 0) {

          this.drawPixel(bx + x, by + y, bitmap.getPixel(bx, by));
        }
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

  void fillRectVec(Vector2 pos0, Vector2 pos1) => this.fillRectXy(pos0.x, pos0.y, pos1.x, pos1.y);

  void drawRectXy(num x0, num y0, num x1, num y1) {
    this.__drawVLine(y0, y1, x0);
    this.__drawVLine(y0, y1, x1);
    this.__drawHLine(x0, x1, y0);
    this.__drawHLine(x0, x1, y1);
  }

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
    x0 = x0.toInt();
    x1 = x1.toInt();
    y0 = y0.toInt();
    y1 = y1.toInt();

    int d = 0;

    int dy = (y1 - y0).abs();
    int dx = (x1 - x0).abs();

    int dy2 = (dy << 1); // slope scaling factors to avoid floating
    int dx2 = (dx << 1); // point

    int ix = x0 < x1 ? 1 : -1; // increment direction
    int iy = y0 < y1 ? 1 : -1;

    if (dy <= dx) {
      for (;;) {
        this.drawPixel(x0, y0);
        if (x0 == x1)
          break;
        x0 += ix;
        d += dy2;
        if (d > dx) {
          y0 += iy;
          d -= dx2;
        }
      }
    } else {
      for (;;) {
        this.drawPixel(x1, y1);
        if (y0 == y1)
          break;
        y0 += iy;
        d += dx2;
        if (d > dy) {
          x0 += ix;
          d -= dy2;
        }
      }
    }
  }


}