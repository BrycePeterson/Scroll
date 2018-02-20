OPC opc;
GradientBounce gBounce = new GradientBounce();

//Number of Rows and Columns (Should be Even for Mapping to work well)
int nRow = 6;  
int nCol = 6;

void setup() {
  size(1500, 1500);
  
  opc = new OPC(this, "127.0.0.1", 7890);
  
  mapLEDBroken();  // Map out LED's on Backpack Geometry to Screen
  boxTest();  //Wipes and Light's Individual Pixels
  
  opc.setColorCorrection(2.5,1,1,1);  //Adjust Balance of RGB or lower all 3 to limit brightness
  opc.showLocations(true);            //Show Pixel Locations on Processing Screen
  
  background(0);
  println("Start");

}

void draw() {
  gBounce.step();
  //pixelTest();
  //boxTest();
}

void mapLED() {
  int a=0;
  for(int i=0;i<nCol/2;i++){  
    for(int j=0;j<nRow;j++){
       opc.led(i*2*64+j,int(width/nCol*(2*i+.33)),int(height/nCol*(j+.33*(1+a)))); //(Led index, Screen X, Screen Y);
       opc.led(i*2*64+11-j,int(width/nCol*(2*i+.66)),int(height/nCol*(j+.33*(1+(a^1)))));

       opc.led((1+i*2)*64+j,int(width/nCol*((1+2*i)+.33)),int(height/nCol*(j+.33*(1+(a^1)))));
       opc.led((1+i*2)*64+11-j,int(width/nCol*((1+2*i)+.66)),int(height/nCol*(j+.33*(1+a)))); 
       a^=1;  
    }
  }
  background(0);
}

void mapLEDBroken() {
  int a=0;
  int skip = 0;
  int noskip=0;
  for(int i=0;i<nCol/2;i++){ 
    if(i==2){
      noskip=0;
    }
    for(int j=0;j<nRow;j++){
      
       opc.led(i*2*64+j+skip-noskip,int(width/nCol*(2*i+.33)),int(height/nCol*(j+.33*(1+a)))); 
       opc.led(i*2*64+11-j+skip-noskip,int(width/nCol*(2*i+.66)),int(height/nCol*(j+.33*(1+(a^1)))));
       if(i==1){
         skip = 64;
         noskip=64;
       }
       opc.led((1+i*2)*64+j+skip,int(width/nCol*((1+2*i)+.33)),int(height/nCol*(j+.33*(1+(a^1)))));
       opc.led((1+i*2)*64+11-j+skip,int(width/nCol*((1+2*i)+.66)),int(height/nCol*(j+.33*(1+a)))); 
       a^=1;
       
       
    }
  }
  background(0);
}

void pixelTest(){
  
  background(0);
  int j=0;
  for(int k=0;k<6;k++){
    
    for(int i=0;i<12;i++){
      opc.setPixel(j+i,color(255,0,0));
      opc.writePixels();
      redraw();
      delay(20);
    }
    j+=64;
  }
}

int xBox=0;
int yBox=0;
void boxTest(){
  background(0);
  fill(0,0,255);
  rect(xBox,yBox,width/6,height/6);
  yBox+=height/6;
  if(yBox>height){
    yBox =0;
    xBox+=width/6;
    if(xBox>width){
      xBox=0;
    }
  }
  delay(100);
} 

/*
void left(){
  background(0);
  image(leftArrow,0,0,width,height);
}

void right(){
  background(0);
  image(rightArrow,0,0,width,height);
}

void leftRight(){
  background(0);
  image(bothArrow,0,0,width,height);
}
*/