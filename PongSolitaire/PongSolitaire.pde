static final int PADDLE_WIDTH = 10, PADDLE_HEIGHT = 50, PADDLE_OFFSET = 10;
static final float SWITCH_CHANCE = .25;
static final int DARK = 60, LIGHT = 180;

Paddle[] paddles = new Paddle[2];

PaddleMovement upDown = () -> mouseY;
PaddleMovement leftRight = () -> mouseX;

boolean controlsSwitched = false;
float targetBgColor = DARK;
float targetPaddleColor = LIGHT;

void setup() {
  size(600, 600);
  reset();
}

void draw() {
  targetBgColor += ((controlsSwitched ? LIGHT : DARK) - targetBgColor) * .05;
  background(targetBgColor);

  targetPaddleColor += ((controlsSwitched ? DARK : LIGHT) - targetPaddleColor) * 0.05;
  fill(targetPaddleColor);
  for (Paddle p : paddles) {
    p.update();
  }
}

void mousePressed() {
  // This is just for testing
  switchControls();
}

void reset() {
  paddles[0] = new Paddle(        PADDLE_OFFSET + PADDLE_WIDTH / 2, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
  paddles[1] = new Paddle(width - PADDLE_OFFSET - PADDLE_WIDTH / 2, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
  updateMovement();
}

void switchControls() {
  controlsSwitched = !controlsSwitched;
  updateMovement();
}

void updateMovement() {
  paddles[0].movement = controlsSwitched ? leftRight : upDown;
  paddles[1].movement = controlsSwitched ? upDown : leftRight;
}

interface PaddleMovement {
  float getInput();
}

class Paddle {
  float x, y, w, h;
  PaddleMovement movement;

  Paddle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void update() {
    float input = movement.getInput();
    float targetY = constrain(input, h / 2, height - h / 2);
    y += (targetY - y) * .2;

    push();
    translate(x, y);
    rect(-w/2f, -h/2f, w, h);
    pop();
  }
}
