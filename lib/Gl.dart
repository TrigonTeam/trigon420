part of Trigon420;

class Gl {
  GameCanvas game;
  RenderingContext gl;

  Shader vs, fs;
  Program prog;
  Texture tex;

  Float32List vertList;
  Int32List indicesList;
  Uint8List l;

  Buffer vbo, ebo;
  HashMap<String, UniformLocation> uniforms =
  new HashMap<String, UniformLocation>();
  HashMap<String, int> attribs = new HashMap<String, int>();

  Gl(this.game) {
    this.gl = this.game.context;
    this.l = new Uint8List(this.game.__width * this.game.__height);
  }

  void init() {
    this.gl.viewport(0, 0, this.game.canvasWidth, this.game.canvasHeight);

    this.vertList = new Float32List.fromList([-1.0, -1.0, 0.0, 0.0, // Bottom left
    1.0, -1.0, 1.0, 0.0, // Bottom right
    1.0, 1.0, 1.0, 1.0 // Top right
        -1.0, 1.0, 0.0, 1.0 // Top left
    ]);

    this.indicesList = new Int32List.fromList([0, 1, 3, 3, 1, 2]);

    this.vbo = this.gl.createBuffer();
    this.ebo = this.gl.createBuffer();

    this.gl.bindBuffer(ARRAY_BUFFER, this.vbo);
    this.gl.bufferDataTyped(ARRAY_BUFFER, this.vertList, STATIC_DRAW);
    this.gl.bindBuffer(ELEMENT_ARRAY_BUFFER, this.ebo);
    this.gl.bufferDataTyped(ELEMENT_ARRAY_BUFFER, this.indicesList, STATIC_DRAW);
    this.gl.bindBuffer(ARRAY_BUFFER, null);
    this.gl.bindBuffer(ELEMENT_ARRAY_BUFFER, null);

    this.loadDefaultShader();
  }

  List<Shader> loadShaders(String vs, String fs) {
    Shader vso, fso;

    vso = this.gl.createShader(VERTEX_SHADER);
    fso = this.gl.createShader(FRAGMENT_SHADER);
    this.gl.shaderSource(vso, vs);
    this.gl.shaderSource(fso, fs);
    this.gl.compileShader(vso);
    this.gl.compileShader(fso);
    print(this.gl.getShaderInfoLog(vso));
    print(this.gl.getShaderInfoLog(fso));

    return [vso, fso];
  }

  Program createProgram(Shader vso, Shader fso) {
    Program prog;
    prog = this.gl.createProgram();
    this.gl.attachShader(prog, this.vs);
    this.gl.attachShader(prog, this.fs);
    return prog;
  }

  void loadDefaultShader() {
    var shaders = loadShaders(
        '''precision mediump float;
attribute vec2 in_vertex;
attribute vec2 in_tex;
varying vec4 color;
varying vec2 tex;
void main()
{
    gl_Position = vec4(in_vertex, 0.0, 1.0);
    color = vec4(1.0, 1.0, 1.0, 1.0);
    tex = in_tex;
}''', '''precision mediump float;
varying vec4 color;
varying vec2 tex;
uniform sampler2D sampler;
void main(void)
{
    gl_FragColor = color * texture2D(sampler, tex);
}''');

    this.vs = shaders[0];
    this.fs = shaders[1];

    this.prog = createProgram(this.vs, this.fs);
    this.gl.linkProgram(this.prog);
    this.gl.useProgram(this.prog);
    this.loadUniforms();
    this.loadAttribs();
  }

  void loadUniforms() {
    final int numUniforms = this.gl.getProgramParameter(
        this.prog, RenderingContext.ACTIVE_UNIFORMS);
    for (var i = 0; i < numUniforms; i++) {
      var uniform = this.gl.getActiveUniform(this.prog, i);
      String name = uniform.name;
      this.uniforms[name] = this.gl.getUniformLocation(this.prog, name);
    }
  }

  void loadAttribs() {
    final int numAttributes = this.gl.getProgramParameter(
        this.prog, RenderingContext.ACTIVE_ATTRIBUTES);
    for (var i = 0; i < numAttributes; i++) {
      var attribute = this.gl.getActiveAttrib(this.prog, i);
      this.attribs[attribute.name] = i;
    }
  }

  void createTexture() {
    this.tex = this.gl.createTexture();
    this.gl.bindTexture(TEXTURE_2D, this.tex);
    this.gl.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, NEAREST_MIPMAP_NEAREST);
    this.gl.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, NEAREST);
    this.gl.bindTexture(TEXTURE_2D, null);
  }
  
  void flushTexture() {
    l.setAll(0, this.game.__bitmap.pixels);
    this.gl.texImage2DTyped(TEXTURE_2D, 0, RGBA, this.game.__width, this.game.__height, 0, RGBA, UNSIGNED_BYTE, this.l);
  }

  void draw() {
    this.gl.clear(COLOR_BUFFER_BIT);

    this.gl.bindBuffer(ARRAY_BUFFER, this.vbo);
    this.gl.vertexAttribPointer(this.attribs["in_vertex"], 2, FLOAT, false, 8, 0);
    this.gl.enableVertexAttribArray(this.attribs["in_vertex"]);
    this.gl.vertexAttribPointer(this.attribs["in_tex"], 2, FLOAT, false, 8, 8);
    this.gl.enableVertexAttribArray(this.attribs["in_tex"]);

    this.gl.useProgram(this.prog);
    this.gl.activeTexture(TEXTURE0);
    this.gl.bindTexture(TEXTURE_2D, this.tex);
    this.gl.uniform1i(this.uniforms["sampler"], 0);

    this.gl.bindBuffer(ELEMENT_ARRAY_BUFFER, this.ebo);
    this.gl.drawElements(TRIANGLES, 6, UNSIGNED_INT, 0);
    this.gl.flush();
  }
}
