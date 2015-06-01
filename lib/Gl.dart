part of Trigon420;

class Gl {
  GameCanvas game;
  RenderingContext gl;
  Shader vs, fs;
  Program prog;

  Gl(this.game) {
    this.gl = this.game.context;
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
    var shaders =
    loadShaders(
    '''
in vec2 in_vertex;
in vec4 in_color;
in vec2 in_tex;

out vec4 color;
out vec2 tex;

void main()
{
    gl_Position = vec4(in_vertex, 0.0, 1.0);

    color = in_color;
    tex = in_tex
}
    ''',

    '''
in vec4 color;
in vec2 tex;

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
  }

  void init() {
    this.gl.viewport(0, 0, this.game.__width, this.game.__height);
  }
}