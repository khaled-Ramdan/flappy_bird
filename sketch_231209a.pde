// 
PImage backgroundImage1;
PImage[] backgound2Frame = new PImage[5];

// pipes
PImage pipe;
int speed, counter, frameCountAtLastObject, interval;
int[] pipeX = { width, width + 1200, width + 1400, width + 1600, width + 1800, width + 2000 };
int[] pipeS = { 1, 0, 1, 0, 1, 0 };

// bird movement
PImage[] birdFrame = new PImage[4];
float birdX, birdY, speedY, gravity;
int currentFrame;
boolean dead;

void setup() {
  size(1200, 950);
  noStroke();
  
  // background
  backgroundImage1 = loadImage("images/background.png");
  backgroundImage1.resize(width, height);
  for(int i = 0; i < backgound2Frame.length; ++i) {
    backgound2Frame[i] = loadImage("images/layer_" + i + ".png");
  }
  
  // pipes
  pipe = loadImage("images/pipe.png");
  speed = 5; 
  counter = 0;
  frameCountAtLastObject = 0;
  interval = 50;
  
  // bird movement
  for(int i = 0; i < birdFrame.length; ++i) {
    birdFrame[i] = loadImage("images/bird_frame_" + i + ".png");
  }
  currentFrame = 0;
  birdX = width / 8;
  birdY = height / 2;
  speedY = 0;
  gravity = 0.5;
  dead = false;
}

void draw() {
  drawBackground(2);
  
  pipes();
  moveBird();
}

void moveBird() {
  if(frameCount % 4 == 0) {
    currentFrame = (currentFrame + 1) % birdFrame.length;
  }
  image(birdFrame[currentFrame], birdX, birdY);
  
  birdY += speedY;
  speedY += gravity;

  if(birdY >= height - 50) {
    speedY = -5; 
  }
  if(birdY < 0) {
   birdY = 5;
   speedY = 0;
  }
  
  collision(3);
}

void drawBackground(int which) {
   if (which == 1)drawBackground1();
   else drawBackground2();
}

void drawBackground1() {
  image(backgroundImage1, 0, 0);
}

void drawBackground2() {
  for(int i = 0; i < backgound2Frame.length; ++i) {
    image(backgound2Frame[i], 0, 0);
  }
}

void pipes() {
    for(int i=0;i<pipeX.length; i++){
    
    if(pipeS[i] == 0)
      draw_pipe_inverse(pipeX[i], 0, 5, 3);
     else 
      draw_pipe(pipeX[i], height - pipe.height, 5, 3);
    
    pipeX[i]-= speed;
    
    if(pipeX[i] <  -75){
        pipeX[i] = width + 75;
        pipeS[i] = floor(random(2));
        //pipeW[i] = random(2,8);
        //pipeH[i] = random(2, 4);
        //println(pipeS[i]);
    }
  }
}

void draw_pipe(int x, int y, float scaleX, float scaleY){
  translate(x + pipe.width / 2, y + pipe.height / 2);
   scale(scaleX, scaleY);
   imageMode(CENTER);
   image(pipe,0,0);
   imageMode(CORNER);
   resetMatrix();
}

void draw_pipe_inverse(int x, int y, float scaleX, float scaleY){
  translate(x + pipe.width / 2, y + pipe.height / 2);
  scale(scaleX, scaleY);
  rotate(radians(180));
  imageMode(CENTER);
  image(pipe, 0, 0);
  imageMode(CORNER);
  resetMatrix();
}

void collision(int scaleY) {
  int pipeW = 26 * 5;
  int pipeH = 160 * scaleY;
  
    for(int i = 0; i < pipeX.length; ++i) {
      if(birdX + 15 >= pipeX[i] &&
         birdX <= pipeX[i] + pipeW &&
         ((birdY <= pipeH && pipeS[i] == 0) || (birdY >= height - pipeH && pipeS[i] == 1))) {
            dead = true;
            break;
       }
    }
    
    if(dead) {
      collisionEffect();
    }
}

void collisionEffect() {
  //speed = 0;
}

void mousePressed() {
  speedY = -10;
}
