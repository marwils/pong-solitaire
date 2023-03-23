static final int PADDLE_WIDTH = 10, PADDLE_HEIGHT = 50, PADDLE_OFFSET = 10;
static final float SWITCH_CHANCE = .25;
static final int DARK = 60, LIGHT = 180;

Paddle[] paddles = new Paddle[2];

PaddleMovement upDown = () -> mouseY;
PaddleMovement leftRight = () -> mouseX;

PVector ballPos, ballVel;
int ballRadius = 5;

int score = 0;
int highScore = 0;

boolean controlsSwitched = false;
float targetBgColor = DARK;
float targetPaddleColor = LIGHT;

boolean running;

void setup() {
  size(600, 600);
  noStroke();

  initPaddles();
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

  displayScore();

  // ball movement
  if (running) {

    // left/right wall collision
    if (ballPos.x - ballRadius < 0 || ballPos.x + ballRadius >= width) {
      reset();
    }
    // top/bottom wall collision
    if (ballPos.y - ballRadius <= 0 || ballPos.y + ballRadius >= height) {
      ballVel.y *= -1;
    }

    // paddle collision
    boolean paddleHit = false;
    if (ballPos.x - ballRadius <= paddles[0].x + PADDLE_WIDTH / 2 && ballPos.y >= paddles[0].y - PADDLE_HEIGHT / 2 && ballPos.y < paddles[0].y + PADDLE_HEIGHT / 2) {
      ballVel.x = abs(ballVel.x);
      paddleHit = true;
    }
    if (ballPos.x + ballRadius >= paddles[1].x - PADDLE_WIDTH / 2 && ballPos.y >= paddles[1].y - PADDLE_HEIGHT / 2 && ballPos.y < paddles[1].y + PADDLE_HEIGHT / 2) {
      ballVel.x = -abs(ballVel.x);
      paddleHit = true;
    }
    if (paddleHit) {
      score++;

      // increase spead
      ballVel.mult(1.02);

      // toggle controls
      if (random(1) < SWITCH_CHANCE) {
        switchControls();
      }
    }

    // move ball
    ballPos.add(ballVel);
  } else { // if not running
    textSize(24);
    text("Click!", width / 2, 100);
  }

  // draw ball
  fill(#A02020);
  ellipse(ballPos.x, ballPos.y, ballRadius * 2, ballRadius * 2);
}

void mousePressed() {
  reset();
  run();
}

void initPaddles() {
  paddles[0] = new Paddle(        PADDLE_OFFSET + PADDLE_WIDTH / 2, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
  paddles[1] = new Paddle(width - PADDLE_OFFSET - PADDLE_WIDTH / 2, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
}

void reset() {
  running = false;
  updateMovement();
  ballPos = new PVector(width / 2, height / 2);
  if (score > highScore) {
    highScore = score;
  }
  score = 0;
}

void run() {
  ballVel = new PVector(2 * (random(1f) < .5 ? -1 : 1), random(1f) < .5 ? -1 : 1);
  running = true;
}

void switchControls() {
  controlsSwitched = !controlsSwitched;
  updateMovement();
}

void updateMovement() {
  paddles[0].movement = controlsSwitched ? leftRight : upDown;
  paddles[1].movement = controlsSwitched ? upDown : leftRight;
}

void displayScore() {
  fill(#FFFFFF);
  textSize(14);
  textAlign(CENTER);
  text(score + " | " + highScore, width / 2, 20);
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
