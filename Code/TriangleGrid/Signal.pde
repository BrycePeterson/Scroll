class Signal {
 private PImage leftArrow;
 private PImage rightArrow;
 private int on;
 private int time;
 
 Signal() {
   leftArrow = loadImage("left.png");
   rightArrow= loadImage("right.png");
   on = 0;
   time = 0;
 }
 
 
 void rightTurn() {
   
   background(0);
   
   if(millis()-time > 1000){
     time = millis();
     on^=1;
   }
   
   if(on == 1){
     image(rightArrow,0,0,width,height);
     println("Right Turn");
   }
   else {
     background(0);
   }   
  }

 void leftTurn(){
   background(0);
   if(millis()-time > 1000){
     time = millis();
     on^=1;
   }
   
   if(on == 1){
     image(leftArrow,0,0,width,height);
     println("Left Turn");
   }
   else {
     background(0);
   }   
  }
 
} //End of Class