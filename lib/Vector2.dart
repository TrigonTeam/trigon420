part of Trigon420;

class Vector2 {
  final num x;
  final num y;

  const Vector2(this.x, this.y);
  Vector2.from(Vector2 vec) : this(vec.x, vec.y);

  Vector2 setX(num x) => new Vector2(x, this.y);
  Vector2 setY(num y) => new Vector2(this.x, y);

  num getDistance(Vector2 other) {
    if(other == this)
      return 0;

    if(other.x == this.x)
      return (other.x - this.x).abs();

    if(other.y == this.y)
      return (other.y - this.y).abs();

    return sqrt(pow(other.x - this.x, 2) + pow(this.y - other.y, 2));
  }

  bool operator ==(v) {
    if(v is! Vector2) return false;
    return v.x == this.x && v.y == this.y;
  }

  Vector2 operator +(Vector2 v) {
    return new Vector2(v.x + this.x, v.y + this.y);
  }

  Vector2 operator -(Vector2 v) {
    return new Vector2(v.x - this.x, v.y - this.y);
  }

  Vector2 operator *(Vector2 v) {
    return new Vector2(v.x * this.x, v.y * this.y);
  }

  Vector2 operator /(Vector2 v) {
    return new Vector2(v.x / this.x, v.y / this.y);
  }

  @override
  int get hashCode {
    return this.x.hashCode ^ this.y.hashCode;
  }

}