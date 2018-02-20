class GradientBounce {
  
  private int[] posX  = {width/3, width*2/3, width/2};
  private int[] posY = {height*2/3, height*2/3, height/3};
  private int[] plusX = {5,-7,-3};
  private int[] plusY = {-5,-10,7};
  private int[] gSize = {100,200,100};
  private int[] gGrow = {7,10,5};
  private color[] gColor = {color(255,170,0,100),color(0,255,255,100),color(200,0,255,100)};


  
  GradientBounce() {
    //Empty Constructor
  }
  
  void step() {
    println("Bounce");
    background(0);
    noStroke();
    for(int i=0;i<3;i++){
      posX[i]+=plusX[i]; 
      if(posX[i]>width){
         plusX[i] = -plusX[i];
      }
        if(posX[i]<0){
        plusX[i] = -plusX[i];
      }
       
      posY[i]+=plusY[i];
      if(posY[i]>height){
        plusY[i] = -plusY[i];
      }
      if(posY[i]<0){
        plusY[i] = -plusY[i];
      }
      gSize[i] += gGrow[i];
      if(gSize[i]>height){
        gGrow[i] = -gGrow[i];
      }
      if(gSize[i]<100){
        gGrow[i] = -gGrow[i];
      }
      fill(gColor[i]);
      ellipse(posX[i],posY[i],gSize[i],gSize[i]); 
    }
  }
}