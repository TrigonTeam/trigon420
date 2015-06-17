part of Trigon420;

class Bitmap {
  int __width, __height;
  bool __backsImageData;

  List<int> pixels;

  int get width => this.__width;

  int get height => this.__height;

  set width(int val) {
    this.__width = val;
    this.pixels = new List<int>(this.__width * this.__height * (this.__backsImageData ? 4 : 1));
  }

  set height(int val) {
    this.__height = val;
    this.pixels = new List<int>(this.__width * this.__height * (this.__backsImageData ? 4 : 1));
  }

  Bitmap(this.__width, this.__height, [this.__backsImageData = true]) {
    this.pixels = new List<int>(this.__width * this.__height * (this.__backsImageData ? 4 : 1));
  }

  int getPixel(int x, int y) {
    if (this.__backsImageData) {
      int r = this.pixels[4 * (y * this.__width + x)];
      int g = this.pixels[4 * (y * this.__width + x) + 1];
      int b = this.pixels[4 * (y * this.__width + x) + 2];
      int a = this.pixels[4 * (y * this.__width + x) + 3];

      return ((r & 0x0ff) << 24) | ((g & 0x0ff) << 16) | ((b & 0x0ff) << 8) | (a & 0x0ff);
    } else {
      return this.pixels[4 * (y * this.__width + x)];
    }
  }

  void setPixel(int x, int y, int color, [bool blend = true]) {
    if (this.__backsImageData) {
      if (blend && (color & 0x000000FF != 255)) {

        double alpha = ((color & 0x000000FF) / 255.0);

        this.pixels[4 * (y * this.__width + x)] =
        (alpha * ((color >> 24) & 0x000000FF) + (1 - alpha) * this.pixels[4 * (y * this.__width + x)]).toInt();

        this.pixels[4 * (y * this.__width + x) + 1] =
        (alpha * ((color >> 16) & 0x000000FF) + (1 - alpha) * this.pixels[4 * (y * this.__width + x) + 1]).toInt();

        this.pixels[4 * (y * this.__width + x) + 2] =
        (alpha * ((color >> 8) & 0x000000FF) + (1 - alpha) * this.pixels[4 * (y * this.__width + x) + 2]).toInt();

        this.pixels[4 * (y * this.__width + x) + 3] = 255;

      } else {
        this.pixels[4 * (y * this.__width + x)] = ((color >> 24) & 0x000000FF);
        this.pixels[4 * (y * this.__width + x) + 1] = ((color >> 16) & 0x000000FF);
        this.pixels[4 * (y * this.__width + x) + 2] = ((color >> 8) & 0x000000FF);
        this.pixels[4 * (y * this.__width + x) + 3] = (color & 0x000000FF);
      }
    } else {
      //TODO: blending
      this.pixels[y * this.__width + x] = color;
    }
  }
}