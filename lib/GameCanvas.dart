part of Trigon420;

class GameCanvas {
  CanvasElement __canvasHtml;
  bool __crashed = false;
  int __tps = 20;
  int __width, __height, __scale;
  int __widthScaled, __heightScaled;

  double __tickTime = 1000000 / 30;
  Bitmap __bitmap;
  Input __input;
  Renderer __render;

  RenderingContext context;
  CanvasRenderingContext2D context2d;
  Gl glu;
  CanvasRenderer cr;

  Function output;
  Renderable renderable;

  Renderer get renderer => this.__render;

  Input get input => this.__input;

  bool get isCrashed => this.__crashed;

  int get tps => this.__tps;

  int get gameWidth => this.__width;

  int get gameHeight => this.__height;

  int get canvasWidth => this.__widthScaled;

  int get canvasHeight => this.__heightScaled;

  bool get isWebgl => (this.context != null);

  set tps(i) {
    this.__tps = i;
    this.__tickTime = 1000000 / i;
  }

  GameCanvas(String canvasName, int width, int height, int scale, [bool useGl = false]) {
    this.__canvasHtml = querySelector("#${canvasName}");
    this.__canvasHtml.setAttribute("width", "${width * scale}px");
    this.__canvasHtml.setAttribute("height", "${height * scale}px");

    this.__width = width;
    this.__height = height;
    this.__scale = scale;
    this.__widthScaled = width * scale;
    this.__heightScaled = height * scale;

    if (useGl) {
      this.context = this.__canvasHtml.getContext3d();

      if (this.context == null) {
        this.crash("WebGL error", "NoWebGL4u");
      }

      this.glu = new Gl(this);
    }
    else {
      this.context2d = this.__canvasHtml.getContext("2d");
      this.cr = new CanvasRenderer(this);
    }

    this.__bitmap = new Bitmap(width, height, !this.isWebgl);
    
    this.__input = new Input();
    this.__render = new Renderer(this);
  }

  num time, lastTime, ticks, frames = 1, lastInfo;
  Stopwatch w;

  void loop() {
    this.w = new Stopwatch();
    this.w.start();


    this.time = w.elapsedMicroseconds;
    this.lastTime = time;
    this.lastInfo = time;
    this.ticks = 0;

    window.requestAnimationFrame(update);
  }

  num lastTick = 0;
  
  void update(double t) {
    time = w.elapsedMicroseconds;

    while (time - lastTime >= this.__tickTime) {   
      lastTick = w.elapsedMilliseconds;
      this.tick(ticks++);
      print("Update: ${w.elapsedMilliseconds - lastTick} ms");
      lastTime += this.__tickTime;
    }

    this.__clearBuffer();
    lastTick = w.elapsedMilliseconds;
    this.renderTick((time - lastTime) / this.__tickTime);
    print("Render: ${w.elapsedMilliseconds - lastTick} ms");
    lastTick = w.elapsedMilliseconds;
    this.__flipBuffer();
    print("Flip: ${w.elapsedMilliseconds - lastTick} ms");

    if(time - this.lastInfo >= 1000000) {
      print("FPS: $frames");
      this.lastInfo = time;
      this.frames = 0;
    }
    
    window.requestAnimationFrame(update);
    this.frames++;
  }

  void tick(int ticks) {
    if (this.renderable != null) this.renderable.tick(ticks);
  }

  void renderTick(double ptt) {
    if (this.renderable != null) this.renderable.renderTick(ptt);
  }

  void __clearBuffer() {
    this.__render.clear(0xFFFFFFFF);
  }

  void __flipBuffer() {
    this.cr.flip();
  }

  void crash(String title, String message) {
    String err = "Error - ${title}\n${message}";

    if (this.output == null) {
      window.alert(err);
    } else {
      Function.apply(this.output, [err]);
    }

    this.__crashed = true;
  }
}
