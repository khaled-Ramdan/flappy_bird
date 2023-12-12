// general 
int where; // 0 = start, 1 = play, 2 = info

// info
PFont flappyFont;
PImage infoImage, ok;

// backgrounds
// 1
PImage backgroundImage1;
// 2
PImage[] backgound2Frame = new PImage[5];
PImage[] numbers = new PImage[10];
PImage[] numbers_s = new PImage[10];

// 3
PImage sky, land1, land2;
float xLand1, xLand2;
int whichBackground;

//score
int score=0,level = 0, bestScore = 0;

// gameOver
PImage gameOver, scoreBoard, restart, exit, New, silver_medal, gold_medal, platinum_medal;

// pipes
PImage pipe, pipe_inverse;
int speed,speed2, counter, frameCountAtLastObject, interval;
int[] pipeX = { 100 + 500,  500 + 100, 500 + 300, 500 +  300, 500 + 500, 500 + 500 };
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
  
  // info
  flappyFont = createFont("fonts/light_pixel-7.ttf", 20); 
  textFont(flappyFont);
  infoImage = loadImage("images/info.png");
  ok = loadImage("images/ok.png");
  
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
  for(int i=0;i<10;i++)
  {
    numbers_s[i]=loadImage("images/" + i + "s.png");
  }
  currentFrame = 0;
  birdX = width / 8;
  birdY = height / 2 - 25;
  speedY = 0;
  gravity = 0.5;
  dead = false;
  paused=false;
  
   // gameOver
  gameOver = loadImage("images/gameover.png");
  scoreBoard = loadImage("images/scoreboard.png");
  restart = loadImage("images/restart.png");
  exit = loadImage("images/exit.png");
  New = loadImage("images/new.png");
  platinum_medal = loadImage("images/platinum_medal.png");
  silver_medal = loadImage("images/silver_medal.png");
  gold_medal = loadImage("images/gold_medal.png");
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
    image(pause, 20, 20);
    }
   else {     
     image(continue_playing,20,20);
   }
   draw_score(width/2,80,score, true);
   moveBird(); 
   if (dead == false)score_effect(score);
  }
  else {
    info();
  } 
   
}

void init() {
  xLand1 = 0;
  xLand2 = width;
  started = false;
  speed = 2; 
  speed2=speed;
  counter = 0;
  frameCountAtLastObject = 0;
  interval = 50;
  currentFrame = 0;
  birdX = width / 8;
  birdY = height / 2 - 25;
  speedY = 0;
  gravity = 0.5;
  dead = false;
  paused=false;
  int f = 100;
  for (int i = 0; i < 6; i += 2, f += 200) {
     pipeX[i] = pipeX[i + 1] = f + 500;
  }
  cnt = 0;
  f = 0;
  bestScore = max(bestScore, score);   
  level = 0;
  score = 0;
}

void draw_score(int posx,int posy,int number, boolean sOb){
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
    if (sOb == true)image(numbers[num3%10],sposx,posy-18);
    else image(numbers_s[num3%10],sposx,posy-18);
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
      draw_pipe(pipe_inverse, pipeX[i], 0,3, pipeScaleY[i], false);
     else 
      draw_pipe(pipe, pipeX[i],  height - pipe.height * pipeScaleY[i], 3,pipeScaleY[i], true);
    
    pipeX[i]-= speed;
    
    if(pipeX[i] <  -75){
        pipeX[i] = width + 75;
        if(pipeS[i] == 1)
          score++;
         if(i % 2 == 0){
          float empty_space = max(2.4 - 0.48 * level, 2.4 - 0.48 * 3);
          float max_height = 4.4 - empty_space;
          float up_pipe = random(0.5, max_height - 0.5);
          float dowm_pipe = 4.4 - up_pipe - empty_space;
          pipeScaleY[i] = up_pipe;
          pipeScaleY[i+1] = dowm_pipe;
      }
    }
  }
}

void draw_pipe(PImage pipe,int x, float y, float scaleX, float scaleY, boolean uOd){
   pushMatrix();
   if (uOd == false)translate(x, y);
   else translate(x, y - 75);
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
         ((birdY <= pipe.height * pipeScaleY[i] && pipeS[i] == 0) || (birdY >= height - pipe.height * pipeScaleY[i] && pipeS[i] == 1))
           || (birdY >= height - 75)) {
            dead = true;
            break;
       }
    }
    
    if(dead) {
      gameOver();
    }
}

void mousePressed() {
  if (dead == true) {
    // restart
    if (mouseX > width / 2 - 125 && mouseX < width / 2 - 125 + 102 && mouseY > height / 2 + 110 && mouseY < height / 2 + 110 + 39) {
      where = 1;
      init();
    }
    // exit
    else if (mouseX > width / 2 + 17 && mouseX < width / 2 + 10 + 113 && mouseY > height / 2 + 110 && mouseY < height / 2 + 110 + 39) {
       where = 0;
       init();
    }
  }
  else if (where == 0) {
    if (mouseX > width / 2 - 60 && mouseX < width / 2 + 50 && mouseY > height / 2 - 31 + 220 && mouseY < height / 2 + 5 + 220) {
       where = 1;
    }
    else if(mouseX >= width - 70 && mouseY >= 10 && mouseY <= 70) {
      where = 2;
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
   else {
    if (mouseX > width / 2 - 52 && mouseX < width / 2 + 52 && mouseY > height / 2 - 31 + 220 && mouseY < height / 2 + 5 + 220) {
      where = 0;
    }
  }
}

void startGame() {
  image(flappyBirdFont, (width / 2 - 90) - 20, (height / 2 - 100 + cnt));
  image(birdFrame[currentFrame], (width / 2 + 100) - 20, (height / 2 - 93 + cnt));
   if(frameCount % 7 == 0) {
    currentFrame = (currentFrame + 1) % birdFrame.length;
  }
   float playButtonScale = 1, infoButtonScale = 1;
  if (mouseX > width / 2 - 60 && mouseX < width / 2 + 50 && mouseY > height / 2 - 31 + 220 && mouseY < height / 2 + 5 + 220){
    playButtonScale = 1.05;  // Increase the scale when hovering
  } else {
    playButtonScale = 1.0;  // Reset the scale when not hovering
  }
  image(play, width / 2 - 52, height / 2 - 31 + 220, 104 * playButtonScale, 36 * playButtonScale);
  if (mouseX >= width - 70 && mouseY >= 10 && mouseY <= 70){
    infoButtonScale = 1.05;  // Increase the scale when hovering
  } else {
    infoButtonScale = 1.0;  // Reset the scale when not hovering
  }
  image(infoImage, width - 70, 10, 60 * infoButtonScale, 60 * infoButtonScale);
  //image(settings, (width / 2 - 52) + 80 , (height / 2 - 31) + 200);
  if (f == 0)cnt += 0.4;
  else cnt -= 0.4;
  if (cnt >= 10 || cnt <= -10)f = 1 - f;
}

void gameOver() {
  speed = 0;
  speedY = 25;
  
  image(gameOver, width / 2 - 96, height / 2 - 200);
  image(scoreBoard, width / 2 - 150, height / 2 - 100);
  float  buttonScaleR = 1;
  if (mouseX > width / 2 - 125 && mouseX < width / 2 - 125 + 102 && mouseY > height / 2 + 110 && mouseY < height / 2 + 110 + 39) {
    buttonScaleR = 1.05;
   }
  image(restart, width / 2 - 125, height / 2 + 110, 104 * buttonScaleR, 39 * buttonScaleR);
  float  buttonScaleE = 1;
  if (mouseX > width / 2 + 17 && mouseX < width / 2 + 10 + 113 && mouseY > height / 2 + 110 && mouseY < height / 2 + 110 + 39) {
    buttonScaleE = 1.05;
   }
  image(exit, width / 2 + 10, height / 2 + 110, 121 * buttonScaleE, 39 * buttonScaleE);
  if (score > bestScore)image(New, width / 2 + 35, height / 2 - 20);
  draw_score(width / 2 + 100, height / 2 - 37, score, false);
  draw_score(width / 2 + 100, height / 2 + 20, max(bestScore, score), false);
  if (score > 10 && score <= 20) {
    image(platinum_medal, width / 2-114, height / 2 - 42);
  }
  else if (score > 20 && score <= 30) {
    image(silver_medal, width / 2-114, height / 2 - 42);
  }
  else if (score > 30){
    image(gold_medal, width / 2-114, height / 2 - 42);
  }
}

void score_effect(int score){  
      if(score >= 100){
          speed = 10;
          level = 4;
      }
      else if(score >= 50) {
          speed = 8;
          level = 3;
      }
      else if(score >= 30) {
        speed = 6;
        level = 2;
      }
      else if(score >= 10){
        speed = 4;
        level = 1;
      }  
}

/*
The objective is to guide the bird through a series of pipes without hitting them.
Your goal is to score as many points as possible by successfully passing through the gaps between the pipes.
*/

void info() {
  text("Flappy Bird", width / 2 - 75, 50);
  text("The objective is to guide", 15, 110);
  text("the bird through a series", 15, 150);
  text("of pipes without hitting", 15, 190);
  text("them.", 15, 230);
  text("Your goal is to score as", 15, 290);
  text("many points as possible by", 15, 330);
  text("successfully passing through", 15, 370);
  text("the gaps between the pipes.", 15, 410);
  
  float buttonScale = 1;
  if (mouseX > width / 2 - 52 && mouseX < width / 2 + 52 && mouseY > height / 2 - 31 + 220 && mouseY < height / 2 + 5 + 220) {
    buttonScale = 1.05;  // Increase the scale when hovering
  } else {
    buttonScale = 1.0;  // Reset the scale when not hovering
  }
  image(ok, width / 2 - 52, height / 2 - 31 + 220, 104 * buttonScale, 36 * buttonScale);
}
