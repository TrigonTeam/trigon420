part of Trigon420;

class Input {
  List<bool> keysDown;
  List<bool> mouseDown;

  int __wheelX = 0;
  int __wheelY = 0;
  int __mouseX = 0;
  int __mouseY = 0;

  int get wheelDeltaX => __wheelX;
  int get wheelDeltaY => __wheelY;
  int get mouseX => __mouseX;
  int get mouseY => __mouseY;

  Vector2 get wheelDelta => new Vector2(__wheelX.toDouble(), __wheelY.toDouble());
  Vector2 get mouse => new Vector2(__mouseX.toDouble(), __mouseY.toDouble());

  Input() {/*
    this.keysDown = []; //new List<bool>();
    this.mouseDown = []; //new List<bool>();

    window.onKeyDown.listen((e) => this.keysDown[e.keyCode] = true);
    window.onKeyUp.listen((e) => this.keysDown[e.keyCode] = false);
    window.onMouseDown.listen((e) => this.mouseDown[e] = true);
    window.onMouseUp.listen((e) => this.mouseDown[e] = false);
    window.onMouseWheel.listen((e) {
      __wheelX = e.deltaX;
      __wheelY = e.deltaY;
    });
    window.onMouseMove.listen((e) {
      __mouseX = e.movement.x;
      __mouseY = e.movement.y;
    });*/
  }
}