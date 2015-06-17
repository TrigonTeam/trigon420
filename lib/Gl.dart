part of Trigon420;

class Gl {
  GameCanvas game;
  RenderingContext gl;
  GlRenderer glr;
  Shader vs, fs;
  Program prog;
  Texture tex;
  Int32List l;
  
  HashMap<String, UniformLocation> uniforms =
      new HashMap<String, UniformLocation>();
  HashMap<String, int> attribs = new HashMap<String, int>();

  Gl(this.game) {
    this.gl = this.game.context;
    this.l = new Int32List(this.game.__width * this.game.__height);
  }

  List<Shader> loadShaders(String vs, String fs) {
    Shader vso, fso;
    
    vso = this.gl.createShader(VERTEX_SHADER);
    fso = this.gl.createShader(FRAGMENT_SHADER);
    this.gl.shaderSource(vso, vs);
    this.gl.shaderSource(fso, fs);
    this.gl.compileShader(vso);
    this.gl.compileShader(fso);

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
    var shaders = loadShaders('''
attribute vec2 in_vertex;
attribute vec4 in_color;
attribute vec2 in_tex;

varying vec4 color;
varying vec2 tex;

void main()
{
    gl_Position = vec4(in_vertex, 0.0, 1.0);

    color = in_color;
    tex = in_tex;
}
    ''', '''
varying vec4 color;
varying vec2 tex;
uniform sampler2D sampler;

void main(void)
{
    gl_FragColor = color * texture(sampler, tex);
}
    ''');

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

  void uniform1f(String name, double d) {
    this.gl.uniform1f(this.uniforms[name], d);
  }

  void uniform2f(String name, Vector2 v) {
    this.gl.uniform2f(this.uniforms[name], v.x, v.y);
  }

  void bindVertexData(String name, int length, int offs, int floatsPerVertex) {
    if (attribs.containsKey(name)) {
      int location = this.attribs[name];
      gl.enableVertexAttribArray(location);
      gl.vertexAttribPointer(location, length, FLOAT, false,
          floatsPerVertex * GlRenderer.BYTES_PER_FLOAT,
          offs * GlRenderer.BYTES_PER_FLOAT);
    }
  }

  void init() {
    this.loadDefaultShader();
    this.gl.viewport(0, 0, this.game.__width, this.game.__height);
    this.glr = new GlRenderer(this);
    this.glr.bindShaderAttribs();
    this.glr.staticDraw = true;
    this.createTexture();
  }

  void createTexture() {
    this.tex = this.gl.createTexture();
    this.gl.bindTexture(TEXTURE_2D, this.tex);
    this.gl.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, NEAREST);
    this.gl.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, NEAREST);
    /*this.gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_S, NONE);
    this.gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_T, NONE);*/
  }
  
  void flushTexture() {
    //l = new Int32List(this.game.__width * this.game.__height);
    l.setAll(0, this.game.__bitmap.pixels);
    //this.gl.texImage2D(TEXTURE_2D, 0, RGBA, RGBA, UNSIGNED_BYTE, l);
    this.gl.texImage2DTyped(TEXTURE_2D, 0, RGBA, this.game.__width, this.game.__height, 0, RGBA, UNSIGNED_BYTE, this.l);
  }
}
