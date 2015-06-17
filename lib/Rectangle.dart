part of Trigon420;

class Rectangle {
  final Vector2 pos1, pos2;
  Vector2 get size => new Vector2(pos2.x - pos1.x, pos2.y - pos1.y);

  const Rectangle(this.pos1, this.pos2);

  static xyxy(num x0, num y0, num x1, num y1) {
    return new Rectangle(new Vector2(x0, y0), new Vector2(x1, y1));
  }

  static xywh(num x, num y, num width, num height) {
    return new Rectangle(new Vector2(x, y), new Vector2(x + width, y + height));
  }

  Rectangle setX0(num x) => Rectangle.xyxy(x, this.pos1.y, this.pos2.x, this.pos2.y);
  Rectangle setX1(num x) => Rectangle.xyxy(this.pos1.x, this.pos1.y, x, this.pos2.y);
  Rectangle setY0(num y) => Rectangle.xyxy(this.pos1.x, y, this.pos2.x, this.pos2.y);
  Rectangle setY1(num y) => Rectangle.xyxy(this.pos1.x, this.pos1.y, this.pos2.x, y);


}

