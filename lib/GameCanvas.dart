part of Trigon420;

class GameCanvas {
  CanvasElement __canvasHtml;
  bool __crashed = false;
  int __tps = 30;
  int __width, __height;
  double __tickTime = 1000000 / 30;
  List<int> __pixels;
  Input __input;
  Renderer __render;

  RenderingContext context;

  Function output;
  Renderable renderable;

  Renderer get renderer => this.__render;
  Input get input => this.__input;

  bool get isCrashed => this.__crashed;

  int get tps => this.__tps;

  set tps(i) {
    this.__tps = i;
    this.__tickTime = 1000000 / i;
  }


  GameCanvas(String canvasName, int width, int height) {
    this.__canvasHtml = querySelector("#${canvasName}");
    this.__canvasHtml.setAttribute("width", "${width}px");
    this.__canvasHtml.setAttribute("height", "${height}px");
    this.__width = width;
    this.__height = height;

    this.__pixels = [];
    this.context = this.__canvasHtml.getContext3d();
    if (this.context == null) {
      this.crash("WebGL error", message: "NoWebGL4u");
    }

    this.__input = new Input();
    this.__render = new Renderer(this);
  }

  void loop() {
    Stopwatch w = new Stopwatch();
    w.start();

    var time = w.elapsedMicroseconds;
    var lastTime = time;
    int ticks = 0;

    while(!window.closed) {
      time = w.elapsedMicroseconds;

      while(time - lastTime >= this.__tickTime) {
        this.tick(ticks++);
        lastTime += this.__tickTime;
      }

      this.__clearBuffer();
      this.renderTick((time - lastTime) / this.__tickTime);
      this.__flipBuffer();
    }
  }

  void tick(int ticks) {
    if(this.renderable != null)
      this.renderable.tick(ticks);
  }

  void renderTick(double ptt) {
    if(this.renderable != null)
      this.renderable.renderTick(ptt);
  }

  void __clearBuffer() {
    this.__render.clear(0xFFFFFF);
  }

  void __flipBuffer() {
    print("flip");
    //TODO
  }

  void crash(String title, {String message, String stackTrace: "No stacktrace"}) {
    String err = "Error - ${title}\n${message}\n" + (stackTrace == null ? "" : stackTrace);

    if (this.output == null) {
      window.alert(err);
    } else {
      Function.apply(this.output, [err]);
    }

    this.__crashed = true;
  }
}