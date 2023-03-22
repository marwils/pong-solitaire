Paddle[] paddles = new Paddle[2];
static final int PADDLE_WIDTH = 10, PADDLE_HEIGHT = 50, PADDLE_OFFSET = 10;

PaddleMovement upDown = () -> mouseY;
PaddleMovement leftRight = () -> mouseX;

boolean controlsSwitched = false;

void setup() {
  size(600, 600);
  reset();
}

void draw() {
  background(60);
  for (Paddle p : paddles) {
    p.update();
  }
}

// This is just for testing
void mousePressed() {
  controlsSwitched = !controlsSwitched;
  updateMovement();
}

void reset() {
  paddles[0] = new Paddle(        PADDLE_OFFSET + PADDLE_WIDTH / 2, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
  paddles[1] = new Paddle(width - PADDLE_OFFSET - PADDLE_WIDTH / 2, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
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
    y = constrain(input, h / 2, height - h / 2);

    push();
    translate(x, y);
    rect(-w/2f, -h/2f, w, h);
    pop();
  }
}
