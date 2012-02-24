import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import megamu.shapetween.*;
import animata.model.*;
import animata.*;
import gifAnimation.*;
import SimpleOpenNI.*;
import processing.opengl.*;



SimpleOpenNI kinnect;

PVector jointLHand = new PVector(0,0,0);
PVector jointLHandProjected = new PVector(0,0,0);
PVector jointLHandPuppet = new PVector(0,0,0);
PVector jointLHandCompare = new PVector(0,0,0);


PVector jointRHand = new PVector(0,0,0);
PVector jointRHandProjected = new PVector(0,0,0);
PVector jointRHandPuppet = new PVector(0,0,0);
PVector jointRHandCompare = new PVector(0,0,0);

PVector jointHead = new PVector(0,0,0);
PVector jointHeadProjected = new PVector(0,0,0);
PVector jointHeadPuppet = new PVector(0,0,0);

PVector jointTorso = new PVector(0,0,0);
PVector jointTorsoProjected = new PVector(0,0,0);
PVector jointTorsoPuppet = new PVector(0,0,0);

PVector jointLKnee = new PVector(0,0,0);
PVector jointLKneeProjected = new PVector(0,0,0);
PVector jointLKneePuppet = new PVector(0,0,0);

PVector jointRKnee = new PVector(0,0,0);
PVector jointRKneeProjected = new PVector(0,0,0);
PVector jointRKneePuppet = new PVector(0,0,0);

PVector jointRElbow = new PVector(0,0,0);
PVector jointRElbowProjected = new PVector(0,0,0);
PVector jointRElbowPuppet = new PVector(0,0,0);


PVector jointLElbow = new PVector(0,0,0);
PVector jointLElbowProjected = new PVector(0,0,0);
PVector jointLElbowPuppet = new PVector(0,0,0);

PVector jointCOMInitial = new PVector(0,0,0);
PVector jointCOMInitialProjected = new PVector(0,0,0);


PVector  jointCom= new PVector(0,0,0);
PVector jointComProjected = new PVector(0,0,0);


PVector  jointLFoot= new PVector(0,0,0);
PVector jointLFootProjected = new PVector(0,0,0);
PVector  jointLFootPuppet= new PVector(0,0,0);

PVector  jointRFoot= new PVector(0,0,0);
PVector jointRFootProjected = new PVector(0,0,0);
PVector  jointRFootPuppet= new PVector(0,0,0);

int StarCount=13;

PVector PersonXY = new PVector(0,0,0);
PVector[] rand1 = new PVector[StarCount];

PImage calib, backgroundImage,story;
boolean CALIBRATED, NEWUSER, GAMESTART;
int userCount;
int personX=500, personY=500;
int[] HIT= new int[StarCount];
boolean[] SCORE= new boolean[StarCount];
boolean ENDJitter=true;
boolean GOINGDOWN=false;
int Score= 0;
Gif star1, star2, star3, star4 ;
AnimataP5 puppet;
Tween[] ani = new Tween[StarCount];
Timer timer = new Timer(5000);
PVector[] pos = new PVector[StarCount];
int[] sizeX = new int[StarCount];
int[] sizeY = new int[StarCount];
int starsLeft=StarCount;
boolean GAMEOVER=false;


Minim minim;
AudioPlayer song;
AudioInput input;

void setup() {
  
  
  
  size(1600, 960, OPENGL);
  background(255); 
  kinnect = new SimpleOpenNI(this);
 
 // textMode(SCREEN);
  // smooth();
   
   
  kinnect.setMirror(true);
  kinnect.enableDepth();
  kinnect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinnect.enableRGB(350, 256,30);
  
  minim = new Minim(this);
 
  song = minim.loadFile("stolen star.mp3");
  calib = loadImage("calib4.png");
  
  
  for(int i=0; i<StarCount; i++) {
    
       ani[i] = new Tween(this, 60, Tween.FRAMES);
       rand1[i] = new PVector(0,0,0);
       rand1[i].x = (int) random(350+60, 1600 - 60);
       rand1[i].y = (int) random(350, 450);
       pos[i] = new PVector(0,0,0);
       HIT[i]=0;
       SCORE[i]=false;
       pos[i].x= rand1[i].x;
       pos[i].y= rand1[i].y;
       sizeX[i] = 50;
       sizeY[i] = 50;
       ani[i].pause();
   }
   
    CALIBRATED=false;
    NEWUSER=false;
    GAMESTART=false;


   backgroundImage= loadImage("background10.png");


   story= loadImage("story.png");
   puppet = new AnimataP5(this,"body5.nmt");
   star1 = new Gif(this, "star5b.gif");
   star2 = new Gif(this, "star5b.gif");
   star3 = new Gif(this, "star5b.gif");
   star1.play();
   star2.play();
   star3.play();
   
}




void draw() {
 
    background(57,56,59);
    image(backgroundImage, 350, 0);
    
    kinnect.update();
    image(kinnect.rgbImage(), 0,0, 350, 256);
      
    for( int i=1; i<7; i++) {
        if(kinnect.isTrackingSkeleton(i)){
            getSkeleton(i);           
         }
    }
    
    userCount = kinnect.getNumberOfUsers();
   if(GAMESTART==true) {
         for(int i=0; i<(int)(StarCount); i++) {
            if(HIT[i]==1) {
                sizeX[i] = 20; sizeY[i]=20;
     		pos[i].x= lerp(rand1[i].x,  rand1[i].x +random(5, 10) , (float) ani[i].position());
		pos[i].y= lerp( rand1[i].y,height, (float)ani[i].position());
		ani[i].resume();
     	   } 
           if(HIT[i]==2) {
                sizeX[i] = 20; sizeY[i]=20;
     		pos[i].x= lerp(rand1[i].x, rand1[i].x +random(5, 10) , (float) ani[i].position());
		pos[i].y= lerp( rand1[i].y,height, (float)ani[i].position());
		ani[i].resume();
     	   }  	  
           image(star1,pos[i].x, pos[i].y,sizeX[i], sizeY[i]);   
          }
         for(int i=(int)(StarCount/3); i<(int)(2*StarCount/3); i++) {
            if(HIT[i]==1) {
                sizeX[i] = 20; sizeY[i]=20;
     		pos[i].x= lerp(rand1[i].x,rand1[i].x +random(5, 10) , (float) ani[i].position());
		pos[i].y= lerp( rand1[i].y,height, (float)ani[i].position());
		ani[i].resume();
     	   } 
           if(HIT[i]==2) {
                sizeX[i] = 20; sizeY[i]=20;
     		pos[i].x= lerp(rand1[i].x, rand1[i].x +random(5, 10) , (float) ani[i].position());
		pos[i].y= lerp( rand1[i].y,height, (float)ani[i].position());
		ani[i].resume();
     	   }  	  
            image(star2,pos[i].x, pos[i].y, sizeX[i], sizeY[i]);   
          }
            for(int i=(int)(2*StarCount/3); i<StarCount; i++) {
                if(HIT[i]==1) {
                sizeX[i] = 20; sizeY[i]=20;
     		pos[i].x= lerp(rand1[i].x,rand1[i].x +random(5, 10) , (float) ani[i].position());
		pos[i].y= lerp( rand1[i].y,height, (float)ani[i].position());
		ani[i].resume();
     	       } 
                if(HIT[i]==2) {
                sizeX[i] = 20; sizeY[i]=20;
     		pos[i].x= lerp(rand1[i].x, rand1[i].x +random(5, 10), (float) ani[i].position());
		pos[i].y= lerp( rand1[i].y,height, (float)ani[i].position());
		ani[i].resume();
       	       }  	  
             image(star3,pos[i].x, pos[i].y,sizeX[i], sizeY[i]);     	
          }
      }
      imageMode(CORNER);
      fill(255);
      rect(30,500, 280, 410);
      image(story, 50, 500);  
      checkHit();
    
    
    if(CALIBRATED==false && NEWUSER==true && userCount<=1){
        newuserfound();
     }
     else if(CALIBRATED== true && NEWUSER==true) {
       calibstop();
       kinnect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_TORSO , jointCOMInitial);
       kinnect.convertRealWorldToProjective(jointCOMInitial, jointCOMInitialProjected); 
 
       CALIBRATED=false;
       NEWUSER = false;
       timer.start();
    }
 
   if(GAMESTART == true && GAMEOVER == false) {
       fill(255) ;
     
       rect(30,300, 280, 150);
       fill(0);
       textSize(18);
       text("Score: "+ Score, 100, 350);
       text("Stars Left:"+starsLeft, 100, 380);
       timer.isFinished();
       int tmp = timer.passedTime/1000;
       text("Time:"+ tmp, 100, 410);   
     }   
     
    if(frameCount%15 == 0 && GAMESTART==true) {
      
       kinnect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_TORSO , jointCOMInitial);
       kinnect.convertRealWorldToProjective(jointCOMInitial, jointCOMInitialProjected); 
        
      }
     
     if(GAMEOVER == true) {
       fill(255);
       textSize(36);
       text("GAMEOVER", 750, 160);
       text("Your Score: "+Score, 750, 260);
     }
     
   strokeWeight(5);
   fill(255);
   ellipse(jointLHandCompare.x, jointLHandCompare.y,30,30);
   ellipse(jointRHandCompare.x, jointRHandCompare.y,30,30);
 
     
 }
 
 void checkHit() {
 
   for(int i=0; i<StarCount; i++) {
     
     if(dist(jointRHandCompare.x,jointRHandCompare.y, rand1[i].x, rand1[i].y) <=32) 
     {
         HIT[i]=2;
            
         if(SCORE[i]==false) {
           Score+=100;
          song.close();
           rewind();
           song.play();

           SCORE[i] = true;
           starsLeft--;
          }
     
     }
     if(dist(jointLHandCompare.x,jointLHandCompare.y, rand1[i].x, rand1[i].y) <=32){
         HIT[i]=1;
            
         if(SCORE[i]==false) {
           Score+=100;
           song.close();
           rewind();
           song.play();
           SCORE[i] = true;
           starsLeft--;

          }
     
     }
   }
   
   if(starsLeft==0) {GAMEOVER=true;}
   
  
 }

 void rewind()

{
   song = minim.loadFile("stolen star.mp3");
   
}

void stop()
{
  song.close();
  input.close();
  minim.stop();
 

  super.stop();
}
 
 public void getSkeleton(int userId){
 
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND , jointLHand);
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND , jointRHand);

  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD , jointHead);
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE , jointLKnee);
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE  , jointRKnee);
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO , jointTorso);
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW , jointLElbow);
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW  , jointRElbow);


  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT , jointRFoot);
  kinnect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT , jointLFoot);
  
  
  kinnect.getCoM(userId,jointCom);

  
  kinnect.convertRealWorldToProjective(jointLHand, jointLHandProjected); 
  kinnect.convertRealWorldToProjective(jointRHand, jointRHandProjected); 
  kinnect.convertRealWorldToProjective(jointHead, jointHeadProjected); 
 
  kinnect.convertRealWorldToProjective(jointLKnee, jointLKneeProjected); 
  kinnect.convertRealWorldToProjective(jointRKnee, jointRKneeProjected); 
  kinnect.convertRealWorldToProjective(jointTorso, jointTorsoProjected); 
  kinnect.convertRealWorldToProjective(jointLElbow, jointLElbowProjected); 
  kinnect.convertRealWorldToProjective(jointRElbow, jointRElbowProjected); 

  kinnect.convertRealWorldToProjective(jointLFoot, jointLFootProjected); 
  kinnect.convertRealWorldToProjective(jointRFoot, jointRFootProjected); 
  kinnect.convertRealWorldToProjective(jointCom, jointComProjected); 

 
 if(!Float.isNaN(jointLHandProjected.x) &&  
 !Float.isNaN(jointLHandProjected.y) &&
 !Float.isNaN(jointRHandProjected.x) &&
 !Float.isNaN(jointRHandProjected.y) &&
 !Float.isNaN(jointRKneeProjected.x) &&
 !Float.isNaN(jointRKneeProjected.y) && 
 !Float.isNaN(jointLKneeProjected.x) &&
  !Float.isNaN(jointLKneeProjected.y) &&
  !Float.isNaN(jointRFootProjected.x) &&
  !Float.isNaN(jointRFootProjected.y) &&
  !Float.isNaN(jointLFootProjected.x) &&
  !Float.isNaN(jointLFootProjected.y) ){
 
  jointLHandPuppet.x = map(jointLHandProjected.x, jointTorsoProjected.x - 150, jointTorsoProjected.x + 150, 0,350 ); 
  jointLHandPuppet.y = map(jointLHandProjected.y ,jointTorsoProjected.y -150, jointTorsoProjected.y +150,-100,450); 
  
  jointLElbowPuppet.x = map(jointLElbowProjected.x, jointTorsoProjected.x - 75, jointTorsoProjected.x + 75, 100, 270); 
  jointLElbowPuppet.y = map(jointLElbowProjected.y, jointTorsoProjected.y - 75, jointTorsoProjected.y +75, 0,300); 
  
  jointRHandPuppet.x = map(jointRHandProjected.x, jointTorsoProjected.x - 150, jointTorsoProjected.x +150, 100,450 ); 
  jointRHandPuppet.y = map(jointRHandProjected.y ,jointTorsoProjected.y -150, jointTorsoProjected.y+ 150,-100,450); 
  
  jointRElbowPuppet.x = map(jointRElbowProjected.x, jointTorsoProjected.x -75, jointTorsoProjected.x +75, 150, 400); 
  jointRElbowPuppet.y = map(jointRElbowProjected.y, jointTorsoProjected.y -75, jointTorsoProjected.y +75,0,300); 
  
  
  jointHeadPuppet.x = map(jointHeadProjected.x, jointTorsoProjected.x -50, jointTorsoProjected.x + 50, 100, 300); 


  jointRKneePuppet.x = map(jointRKneeProjected.x, jointTorsoProjected.x -75, jointTorsoProjected.x +75, 223,380); 
  jointRKneePuppet.y = map(jointRKneeProjected.y ,jointTorsoProjected.y +100, jointTorsoProjected.y+ 150,251,405); 
  
  jointRFootPuppet.x = map(jointRFootProjected.x, jointTorsoProjected.x -200, jointTorsoProjected.x +200, 75, 416); 
  jointRFootPuppet.y = map(jointRFootProjected.y, jointTorsoProjected.y +100, jointTorsoProjected.y +200,300,431); 
  
  
  jointLKneePuppet.x = map(jointLKneeProjected.x, jointTorsoProjected.x - 75, jointTorsoProjected.x +75, 78,270); 
  jointLKneePuppet.y = map(jointLKneeProjected.y ,jointTorsoProjected.y +100, jointTorsoProjected.y+ 150,251,405); 
  
  jointLFootPuppet.x = map(jointLFootProjected.x, jointTorsoProjected.x -200, jointTorsoProjected.x +200, 42, 322); 
  jointLFootPuppet.y = map(jointLFootProjected.y, jointTorsoProjected.y +100, jointTorsoProjected.y +200,300,431); 
  
  jointLHandCompare.x = map(PersonXY.x +jointLHandPuppet.x  , 350, width, 350, width);
  jointLHandCompare.y = map(PersonXY.y +jointLHandPuppet.y ,0 , height, 0, height);
  
  jointRHandCompare.x = map(PersonXY.x +jointRHandPuppet.x , 350, width, 350, width);
  jointRHandCompare.y = map(PersonXY.y+jointRHandPuppet.y, 0, height, 0, height);  


 puppet.moveJointX("RIGHT_ELBOW",jointLElbowPuppet.x);
 puppet.moveJointY("RIGHT_ELBOW",jointLElbowPuppet.y); 
 
 puppet.moveJointX("RIGHT_HAND",jointLHandPuppet.x); 
 puppet.moveJointY("RIGHT_HAND",jointLHandPuppet.y);
 
 puppet.moveJointX("LEFT_ELBOW",jointRElbowPuppet.x);
 puppet.moveJointY("LEFT_ELBOW",jointRElbowPuppet.y); 
 
 puppet.moveJointX("LEFT_HAND",jointRHandPuppet.x); 
 puppet.moveJointY("LEFT_HAND",jointRHandPuppet.y); 
 
 puppet.moveJointX("LEFT_FOOT",jointRFootPuppet.x);
 puppet.moveJointY("LEFT_FOOT",jointRFootPuppet.y); 
 
 puppet.moveJointX("RIGHT_FOOT",jointLFootPuppet.x); 
 puppet.moveJointY("RIGHT_FOOT",jointLFootPuppet.y);
 
 puppet.moveJointX("LEFT_KNEE",jointRKneePuppet.x);
 puppet.moveJointY("LEFT_KNEE",jointRKneePuppet.y);
 
 puppet.moveJointX("RIGHT_KNEE",jointLKneePuppet.x);
 puppet.moveJointY("RIGHT_KNEE",jointLKneePuppet.y); 
 
 puppet.moveJointX("HEAD",jointHeadPuppet.x);
 
 PersonXY.x = map(jointTorsoProjected.x ,0, 640,350- 450/2, width - 450/2);


  if(abs(jointTorsoProjected.y-jointCOMInitialProjected.y)>60 ){
    
     PersonXY.y = map(jointTorsoProjected.y,480, 0,  height - 415/2, 0);
     
     
  }
  else {
      PersonXY.y =  height - 415;   
  }
 
  
  }
    println(jointTorsoProjected.y-jointCOMInitialProjected.y);
     puppet.draw(PersonXY.x ,PersonXY.y); 
     
      
 
        
 }
 
 
  void newuserfound() {
     
  
   image(calib, (width+350)/2 - calib.width/2 , height - calib.height);
    
 }
 
 void calibstop() {
   calib.delete();

 
 }

