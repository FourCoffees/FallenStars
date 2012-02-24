

// SimpleOpenNI Events
// -----------------------------------------------------------------
public void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  kinnect.startPoseDetection("Psi",userId);
  NEWUSER=true;
}

// -----------------------------------------------------------------


// -----------------------------------------------------------------
public void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

// -----------------------------------------------------------------


// -----------------------------------------------------------------
public void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

// -----------------------------------------------------------------


// -----------------------------------------------------------------
public void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    kinnect.startTrackingSkeleton(userId); 
    CALIBRATED=true;
    NEWUSER=false;
     GAMESTART=true;

      
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    kinnect.startPoseDetection("Psi",userId);
    
   
  }
}

// -----------------------------------------------------------------


// -----------------------------------------------------------------
public void onStartPose(String pose,int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  kinnect.stopPoseDetection(userId); 
  kinnect.requestCalibrationSkeleton(userId, true);
 
}

// -----------------------------------------------------------------


// -----------------------------------------------------------------
public void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

// -----------------------------------------------------------------
