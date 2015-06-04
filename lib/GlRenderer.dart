part of Trigon420;

class GlRenderer {

  static const int MAX_TRIANGLES = 4096;
  static const int MAX_VERTICES = MAX_TRIANGLES*3;
  static const int FLOATS_PER_VERTEX = 9;
  static const int BYTES_PER_VERTEX = FLOATS_PER_VERTEX*4;
  static const int BYTES_PER_FLOAT = 4;

  RenderingContext gl;
  Gl glu;

  Buffer defaultVertexBuffer;

  Buffer vertexBuffer;
  Buffer indexBuffer;

  bool staticDraw = false;

  Float32List vertexData;

  double colorR = 0.0;
  double colorG = 0.0;
  double colorB = 0.0;
  double colorA = 0.0;
  double texCoordS = 0.0;
  double texCoordT = 0.0;

  int bufferPos = 0;
  int vertexCount = 0;

  HashMap<Buffer, int> vertexCounts = new HashMap<Buffer, int>();

  GlRenderer(this.glu) {
    this.gl = this.glu.gl;
    vertexData = new Float32List(MAX_VERTICES*FLOATS_PER_VERTEX);

    Int16List indexData = new Int16List(MAX_VERTICES);

    for(int i = 0; i < MAX_TRIANGLES; i += 3) {
      indexData[i] = i;
      indexData[i+1] = i+1;
      indexData[i+2] = i+2;
    }

    vertexBuffer = defaultVertexBuffer = gl.createBuffer();
    indexBuffer = gl.createBuffer();

    gl.bindBuffer(ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferDataTyped(ELEMENT_ARRAY_BUFFER, indexData, STATIC_DRAW);
    gl.bindBuffer(ARRAY_BUFFER, vertexBuffer);
  }

  void defaultVBO() {
    setVBO(this.defaultVertexBuffer);
  }

  void setVBO(Buffer b) {
    this.vertexBuffer = b;
    this.gl.bindBuffer(ARRAY_BUFFER, b);
  }

  void bindShaderAttribs() {
    this.glu.bindVertexData("in_vertex", 2, 0, FLOATS_PER_VERTEX);
    this.glu.bindVertexData("in_color", 4, 2, FLOATS_PER_VERTEX);
    this.glu.bindVertexData("in_tex", 2, 6, FLOATS_PER_VERTEX);
  }

  void upload() {
    gl.bufferDataTyped(ARRAY_BUFFER, vertexData, staticDraw ? STATIC_DRAW : STREAM_DRAW);
    vertexCounts[this.vertexBuffer] = this.vertexCount;
  }

  void render() {
    gl.drawElements(TRIANGLES, vertexCounts[this.vertexBuffer], UNSIGNED_SHORT, 0);
  }

  void clear() {
    this.bufferPos = 0;
    this.vertexCount = 0;
  }

  void vertex(double x, double y) {
    this.vertexData[bufferPos++] = x;
    this.vertexData[bufferPos++] = y;
    this.vertexData[bufferPos++] = colorR;
    this.vertexData[bufferPos++] = colorG;
    this.vertexData[bufferPos++] = colorB;
    this.vertexData[bufferPos++] = colorA;
    this.vertexData[bufferPos++] = texCoordS;
    this.vertexData[bufferPos++] = texCoordT;
    this.vertexCount++;
  }

  void color(double r, double g, double b, double a) {
    this.colorR = r;
    this.colorG = g;
    this.colorB = b;
    this.colorA = a;
  }

  void texCoord(double s, double t) {
    this.texCoordS = s;
    this.texCoordT = t;
  }

}