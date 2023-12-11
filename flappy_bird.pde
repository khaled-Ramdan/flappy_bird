// general 
int where;

// backgrounds
// 1
PImage backgroundImage1;
// 2
PImage[] backgound2Frame = new PImage[5];
PImage[] numbers = new PImage[10];
// 3
PImage sky, land1, land2;
float xLand1, xLand2;
int whichBackground;
//mod
int score=0,level = 0;

// pipes
PImage pipe, pipe_inverse;
int speed,speed2, counter, frameCountAtLastObject, interval;
int[] pipeX = { 100, 100, 300, 300, 500, 500 };
int[] pipeS = { 1, 0, 1, 0, 1, 0 };
float[] pipeScaleY = { 1,1 , 0.5, 1.5, 0.3, 1.7}; // 4.4  => empty [1, 2.4] 

// bird
PImage[] birdFrame = new PImage[3];
float birdX, birdY, speedY, gravity,speedY2;
int currentFrame;
boolean dead,paused=false;//////////////////////////

// start
PImage flappyBirdFont, play, settings,pause,continue_playing;/////////////////////////////
float cnt = 0, f = 0;

// get started
PImage getReady, taptap;
boolean started;


void setup() {
  size(394, 700);
  noStroke();
  
  // general
  where = 0;
  
  // backgrounds
  // 1
  backgroundImage1 = loadImage("images/background.png");
  backgroundImage1.resize(width, height);
  // 2
  for(int i = 0; i < backgound2Frame.length; ++i) {
    backgound2Frame[i] = loadImage("images/layer_" + i + ".png");
  }
  // 3
  sky = loadImage("images/sky.png");
  land1 = loadImage("images/land.png");
  land2 = loadImage("images/land.png");
  xLand1 = 0;
  xLand2 = width;
  whichBackground = 3;
  // start 
  flappyBirdFont = loadImage("images/flappy.png");
  play = loadImage("images/start.png");
  settings = loadImage("images/settings.png");
  pause=loadImage("images/pause.png");//////////////////////////
  continue_playing=loadImage("images/continue.png");
  // get started
  getReady = loadImage("images/getready.png");
  taptap = loadImage("images/taptap.png");
  started = false;
  
  // pipes
  pipe = loadImage("images/pipe.png");
  pipe_inverse = loadImage("images/pipe-inverse.png");
  speed = 2; 
  speed2=speed;
  counter = 0;
  frameCountAtLastObject = 0;
  interval = 50;
  
  // bird movement
  for(int i = 0; i < birdFrame.length; ++i) {
    birdFrame[i] = loadImage("images/bird_frame_" + i + ".png");
  }
  for(int i=0;i<10;i++)
  {
    numbers[i]=loadImage("images/" + i + ".png");
  }
  currentFrame = 0;
  birdX = width / 8;
  birdY = height / 2 - 25;
  speedY = 0;
  gravity = 0.5;
  dead = false;
  paused=false;
}

void draw() {
  drawBackground(whichBackground);
  if (where == 0) {
    startGame();
  }
  else if (where == 1) {

   
      if (started == false) {
        getStarted();
      }
      else {
        pipes();
      }
      if(paused==false){
    image(pause, 10, 10);
    }
   else {     
     image(continue_playing,10,10);
   }
    draw_score(width/2+35,40,score);
moveBird(); 
score_effect(score);
}
  
   
}
void draw_score(int posx,int posy,int number){
  int num2=number,num3=0;
  int sz=0,sz2=0;
  while(num2>0)
  {
    num3*=10;
    num3+=num2%10;
    num2/=10;
    sz++;
  }
  sz=max(sz,1);
  sz2=sz;
  int sposx=posx;
  if(sz%2==1)sposx-=13;
  sz/=2;
  while(sz>0){
  sposx-=25;
  sz--;
  }
  while(sz2>0)
  {
    image(numbers[num3%10],sposx,posy-18);
    sposx+=25;
    sz2--;
    num3/=10;
  }
}
void getStarted() {
   image(getReady, width / 2 - 100, height / 2 - 100);
   image(taptap, width / 2 - 65, height / 2 - 25);
   gravity = 0.4;
   speedY = 0;
}

void moveBird() {
  if(frameCount % 4 == 0&&paused==false) {
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
   else if (which == 2) drawBackground2();
   else drawBackground3();
}

void drawBackground1() {
  image(backgroundImage1, 0, 0);
}

void drawBackground2() {
  for(int i = 0; i < backgound2Frame.length; ++i) {
    image(backgound2Frame[i], 0, 0);
  }
}

void drawBackground3() {
  image(sky, 0, 0);
  image(land1, xLand1, height - 75);
  image(land2, xLand2, height - 75);
  xLand1 -= speed;
  xLand2 -= speed;
  if (xLand1 <= -width)xLand1 = width;
  if (xLand2 <= -width)xLand2 = width;
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
        if(pipeS[i] == 1)
          score++;
         if(i % 2 == 0){
          float empty_space = 2.4 - 0.48 * level;
          float max_height = 4.4 - empty_space;
          float up_pipe = random(0.5, max_height - 0.5);
          float dowm_pipe = 4.4 - up_pipe - empty_space;
          pipeScaleY[i] = up_pipe;
          pipeScaleY[i+1] = dowm_pipe;
      }
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
  if (where == 0) {
    if (mouseX > width / 2 - 60 && mouseX < width / 2 + 50 && mouseY > height / 2 - 31 + 220 && mouseY < height / 2 + 5 + 220) {
       where = 1;
    }
  }
  else if (where == 1) {
    if(mouseX>=10&&mouseX<=67&&mouseY>=10&&mouseY<=70)
    {
      paused=!paused;
      if(paused){
        gravity=0;
        speedY2=speedY;
        speedY=0;
      speed=0;
      }
      else
      {
        gravity=0.4;
        speedY=speedY2;
        speed=speed2; 
      }
    }
    else if(paused==false){
      if (started == false) {
        started = true;
      }
      speedY = -10;
    }
  }
}

void startGame() {
  image(flappyBirdFont, (width / 2 - 90) - 20, (height / 2 - 100 + cnt));
  image(birdFrame[currentFrame], (width / 2 + 100) - 20, (height / 2 - 93 + cnt));
   if(frameCount % 7 == 0) {
    currentFrame = (currentFrame + 1) % birdFrame.length;
  }
  float  buttonScale = 1;
  if (mouseX > width / 2 - 60 && mouseX < width / 2 + 50 && mouseY > height / 2 - 31 + 220 && mouseY < height / 2 + 5 + 220) {
    buttonScale = 1.05;  // Increase the scale when hovering
  } else {
    buttonScale = 1.0;  // Reset the scale when not hovering
  }
  image(play, width / 2 - 52, height / 2 - 31 + 220, 104 * buttonScale, 36 * buttonScale);
  //image(settings, (width / 2 - 52) + 80 , (height / 2 - 31) + 200);
  if (f == 0)cnt += 0.4;
  else cnt -= 0.4;
  if (cnt >= 10 || cnt <= -10)f = 1 - f;
}
