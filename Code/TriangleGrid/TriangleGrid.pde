
//Images
OPC opc;
PImage dot;
PImage leftArrow;  //Left Turn Arrow
PImage rightArrow;  //Right Turn Arrow
PImage bothArrow;    //Both?
  
import processing.serial.*; // add the serial library
Serial myPort; // the serial port to monitor
boolean isSerial = false;

// Backpack Geometry

//Number of Rows and Columns (Should be Even for Mapping to work well)
int nRow = 6;  
int nCol = 6;

// dotGame Variables
int xPos = 0;
int yPos = 0;
int xPlus = 0;
int yPlus = 0;
int turnState = 1;
// polarGradient 
int r;
float theta;
int radius = 5;

// gradientFlow Animation
int[] posX  = {width/3, width*2/3, width/2};
int[] posY = {height*2/3, height*2/3, height/3};
int[] plusX = {5,-7,-3};
int[] plusY = {-5,-10,7};
int[] gSize = {100,200,100};
int[] gGrow = {7,10,5};
color[] gColor = {color(255,170,0,100),color(0,255,255,100),color(200,0,255,100)};

void setup() {
    
  dot = loadImage("color-dot.png");
  leftArrow = loadImage("left.png");
  rightArrow = loadImage("right.png");
  bothArrow = loadImage("leftright.png");
  size(600, 600);
  
  //Open Pixel Control Object
  opc = new OPC(this, "127.0.0.1", 7890);
  
  //Serial Port Initialization
  
  if(isSerial==true){
    printArray(Serial.list()); // list all available serial ports
    myPort = new Serial(this, Serial.list()[0], 9600); // define input port
    myPort.clear(); // clear the port of any initial junk
  }
  
  mapLED();  // Map out LED's on Backpack Geometry to Screen
  pixelTest();  //Wipes and Light's Individual Pixels
  
  background(0);
  println("Start");
  
}

void draw()
{
  gradientFlow();
  //paint();
  //dotGame();
  //turnSignals();
  //pixelTest();
  //boxTest();  
  //twistedLines();
  //polarGradient(int(millis()%5000));
  //topGradient();
  //left();
}


void mapLED() {
  int a=0;
  for(int i=0;i<nCol/2;i++){  
    for(int j=0;j<nRow;j++){
     opc.led(i*2*64+j,int(width/nCol*(2*i+.33)),int(height/nCol*(j+.33*(1+a))));
     opc.led(i*2*64+11-j,int(width/nCol*(2*i+.66)),int(height/nCol*(j+.33*(1+(a^1)))));

     opc.led((1+i*2)*64+j,int(width/nCol*((1+2*i)+.33)),int(height/nCol*(j+.33*(1+(a^1)))));
     opc.led((1+i*2)*64+11-j,int(width/nCol*((1+2*i)+.66)),int(height/nCol*(j+.33*(1+a)))); 
   a^=1;  
  } 
  
 }
  background(0);
  opc.setColorCorrection(2.5,1,1,1);
  opc.showLocations(true); 
}

void paint(){
  background(0);
  // Draw the image, centered at the mouse location
  float dotSize = width * 0.75;
  image(dot, mouseX - dotSize/2, mouseY - dotSize/2, dotSize, dotSize);
  opc.writePixels();
}


void gradientFlow() {
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
void turnSignals(){
  
  //background(0);
  if (myPort.available () > 0) { // make sure port is open
    
    String inString = myPort.readStringUntil('\n'); // read input string
    
    if (inString != null) { // ignore null strings
      inString = trim(inString); // trim off any whitespace
      String[] xyRaw = splitTokens(inString, ","); // extract x & y into an array
      
      if (xyRaw.length == 1) {
        int value = int(xyRaw[0]);
        println(value);
        
        switch(value){
          case 0: turnState = 0;
                  break;
          case 1: turnState = 1;
                  break;
          case 2: turnState = 2;
                  break;
        } 
        println(turnState);
      }
    }
    
    myPort.clear();
  }
  switch(turnState){
          case 0: left();
                  break;
          case 1: background(0);
                  break;
          case 2: right();
                  break;
  }
}


void dotGame(){
    
  //delay(1);
  background(0);
  opc.writePixels();
  if (myPort.available () > 0) { // make sure port is open
    
    String inString = myPort.readStringUntil('\n'); // read input string
    
    if (inString != null) { // ignore null strings
      inString = trim(inString); // trim off any whitespace
      String[] xyRaw = splitTokens(inString, ","); // extract x & y into an array
      
      if (xyRaw.length == 3) {
        
        int ax = int(xyRaw[0]);
        int ay = int(xyRaw[1]);
        int az = int(xyRaw[2]);
        
        ax+=75;
        
        println(ax+","+ay+","+az);
        
        xPlus += int(ax/10);
        yPlus -= int(ay/10);
        
        if(xPlus>10){
          xPlus = 10;
        }
        if(xPlus<-10){
          xPlus = -10;
        }
        if(yPlus>10){
          yPlus = 10;
        }
        if(yPlus<-10){
          yPlus = -10;
        }

        xPos +=xPlus;
        yPos +=yPlus;
        
         if(xPos>width-radius){
          xPos = width-radius;
        }
        if(xPos<0){
          xPos = 0;
        }
        if(yPos>height-radius){
          yPos = height-radius;
        }
        if(yPos<radius){
          yPos = radius;
        }
       // background(0);
        fill(0,255,0);
        //ellipse(xPos,yPos,2*radius,2*radius);
        rect(xPos,0,width/6,height);
        opc.writePixels();
        /*
        To-Do:
          Turn Data based on accelerometer
          Turn Signal Data Input
          Speakers
                
        
*/         
      }
    }
  }
   myPort.clear(); 
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

void boxTest(){
  background(0);
  fill(0,0,255);
  rect(xPos,yPos,width/6,height/6);
  yPos+=height/6;
  if(yPos>height){
    yPos =0;
    xPos+=width/6;
    if(xPos>width){
      xPos=0;
    }
  }
  delay(500);
} 

void twistedLines() {

  background(0);
  blendMode(SCREEN);
  noFill();
  strokeWeight(20);
  for(int i = 0; i < 3; i++) {
    stroke(255-75*i,0,75*i);
    beginShape();
    for(int w = -20; w < width + 20; w += 5) {
      int h = height / 2;
      h += 300 * sin(w * 0.03 + frameCount * 0.07 + i * TWO_PI / 3) * pow(abs(sin(w * 0.001 + frameCount * 0.02)), 5);
      curveVertex(w, h);
    }    
    endShape();
  }
}


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






  
  