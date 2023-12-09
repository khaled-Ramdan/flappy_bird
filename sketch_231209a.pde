// 
PImage backgroundImage1;
PImage[] backgound2Frame = new PImage[5];

// pipes
PImage pipe, pipe_inverse;
int speed, counter, frameCountAtLastObject, interval;
int[] pipeX = { 1000, 1200, 1400, 1600, 1800, 2000 };
int[] pipeS = { 1, 0, 1, 0, 1, 0 };
float[] pipeScaleY = { 1, 0.2, 0.5, 0.8, 1.2, 1.4};
float[] pipeScaleX = { 1.5, 0.5, 2.8, 1.6, 1.2, 0.9};

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
  pipe_inverse = loadImage("images/pipe-inverse.png");
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
      draw_pipe(pipe_inverse, pipeX[i], 0,3, pipeScaleY[i]);
     else 
      draw_pipe(pipe, pipeX[i],  height - pipe.height * pipeScaleY[i], 3,pipeScaleY[i]);
    
    pipeX[i]-= speed;
    
    if(pipeX[i] <  -75){
        pipeX[i] = width + 75;
        pipeS[i] = floor(random(2));
        //pipeW[i] = random(2,8);
        //pipeH[i] = random(2, 4);
        //println(pipeS[i]);
        pipeScaleY[i] = floor(random(1.5));
        //pipeScaleX[i] = floor(random(3));
    }
  }
}

void draw_pipe(PImage pipe,int x, float y, float scaleX, float scaleY){
   pushMatrix();
   translate(x, y);
   scale(scaleX, scaleY);
   rectMode(CORNER);
   image(pipe,0,0);
   popMatrix();
}


void collision(int scaleY) {
  int pipeW = pipe.width * 3;
  //int pipeH = pipe.height * 1;
    for(int i = 0; i < pipeX.length; ++i) {
      if(birdX + 15 >= pipeX[i] &&
         birdX <= pipeX[i] + pipeW  &&
         ((birdY <= pipe.height * pipeScaleY[i] && pipeS[i] == 0) || (birdY >= height - pipe.height * pipeScaleY[i] && pipeS[i] == 1))) {
            dead = true;
            break;
       }
    }
    
    if(dead) {
      collisionEffect();
    }
}

void collisionEffect() {
  speed = 0;
  speedY = 25;
  
}

void mousePressed() {
  speedY = -10;
}
