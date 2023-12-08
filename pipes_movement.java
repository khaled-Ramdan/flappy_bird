


int speed = 10, counter = 0, frameCountAtLastObject = 0, interval = 50;

int []pipeX = {width, width + 200, width + 400, width + 800, width + 1000, width + 1100};
int []pipeS = {1,0,1,0,1, 0};
float []pipeW = {5, 7 ,6, 3 , 2, 3};
float[]pipeH = {5, 1.4, 1, 1, 5, 2};


void draw(){
  fill(0);
  background(backgroundImage);
  
  
  for(int i=0;i<pipeX.length; i++){
    
    if(pipeS[i] == 0)
      draw_pipe_inverse(pipeX[i], 0, pipeW[i], pipeH[i]);
     else 
      draw_pipe(pipeX[i], height - pipe.height, pipeW[i],pipeH[i]);
    pipeX[i]-= speed;
    
    if(pipeX[i] < 0){
        pipeX[i] = width + floor(random(100,1000));
        //pipeS[i] = floor(random(2));
        pipeW[i] = random(2,8);
        pipeH[i] = random(2, 4);
        println(pipeS[i]);
    }
  }
}
