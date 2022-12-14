/*
- *Student*: AlbertoNilya Salgado Harres
- *Programm*: Digital Media Master at Hfk Bremen
- *Semester*: SS2022
- *Matrikelnummer*: 33853
----------------
- *Student*: Nilufer Musaeva
- *Programm*: Digital Media Master at Hfk Bremen
- *Semester*: SS2022
- *Matrikelnummer*: 33861
----------------
- *Class*: Autonomous Agents
- *Lecturer*: Prof. Tim Laue 
- *Date*: 2.10.2022
*/

// ******************************************
// Search: State for searching what to do
// ******************************************

class AlbertoNilyaStateSearch extends AlbertoNilyaState {
  
  PVector nextGoal;
  
  int jumpDistance = 100; 
  
  AlbertoNilyaStateSearch(String name, SumoJumpPlayer player) {
    super(name, player);
  }
  
  public String transition() {
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    
    if (!proprio.onFloor) {
      // if its flying... wait
      return name;
    }
    
    // always know closest goal
    SumoJumpGoalMeasurement closestGoal = getClosestGoal();
    
    if (player.sensePlatforms().size() == 0) {
      float goalX = closestGoal.position.x;
      // if is far or near, if objective above or under -> Walk or Jump
      String action = (abs(goalX) > 150 || !isObjectiveAbove) ? "Walk" : "Jump";
      // if move right or left
      action += (goalX < 0) ? "Left" : "Right";
      return action;
    }
    
    // always calculate target plaform (closest on y axis)
    SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();
    
    PVector  playerPos = player.sensePositionInPixelWorld();
    float distLeft = playerPos.dist(targetPlatform.left); 
    float distRight = playerPos.dist(targetPlatform.right);
    boolean onThisPlatform = targetPlatform.standingOnThisPlatform;
    
    // if already standing on platform... go for the goal!!! (this is working fine)
    // also if there are no visible platforms... just do something as if the goal was right there!
    if (onThisPlatform) {
      // get X position of the next closest goal
      float goalX = getClosestGoal().position.x;
      // if is far or near, if objective above or under -> Walk or Jump
      String action = (abs(goalX) > 150 || !isObjectiveAbove) ? "Walk" : "Jump";
      // if move right or left
      action += (goalX < 0) ? "Left" : "Right";
      return action;
    } else {
      // check what side of the platform is closer
      if (targetPlatform.left.x < targetPlatform.right.x) {
        // left side is closer
        // approach jumping distance
        if (targetPlatform.left.x < - 300) {
          // run to jump!
          // println("run to jump!");
          return "WalkLeft";
        } else {
          // come back...
          // println("come back...");
          return "WalkRight";
        }
      } else {
        // approach jumping distance
        if (targetPlatform.left.x > 350) {
          //println("run to jump!");
          // run to jump!
          return "WalkRight";
        } else {
          // come back...
          return "WalkLeft";
        }
      }
    }
  }
  
  public void action() {
    // no need to do anything
  }
}

// ******************************************
// WalkRight: guess what... state for Walking Right
// ******************************************

class AlbertoNilyaStateWalkRight extends AlbertoNilyaState {
  
  AlbertoNilyaStateWalkRight(String name, SumoJumpPlayer player) {
    super(name, player);
  }
  
  public String transition() {
    if (player.sensePlatforms().size() == 0) {
      if (millis() - timeOfActivation > 1000) {
        // if no platform visible, just walk somewhere to see something...
        return randomDirection();
      } else {
        // else, just keep on walking, walking, walking, walking, walking, walking, walking, walking, walking
        return name;
      }
    }
    
    // State transition when having waited for 200 milliseconds
    if (millis() - timeOfActivation < 200) {
      return name;
    }
    
    if (isPlayerNear()) {
      // println("player near! JumpRight");
      return "JumpRight";
    }
    
    SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();
    
    // if under the platform...
    if (targetPlatform.right.x > 0 && targetPlatform.left.x < 0) {
      // just continue walking
      return name;
    }
    
    if (targetPlatform.left.x > 0 && targetPlatform.left.x < 150 && isObjectiveAbove) {
      return "JumpRight";
    }
    
    return "Search";
  };
  
  public void action() {
    player.moveSidewards(60);
  }
}


// ******************************************
// and.... surprise! State for walking Left
// ******************************************

class AlbertoNilyaStateWalkLeft extends AlbertoNilyaState {
    
  AlbertoNilyaStateWalkLeft(String name, SumoJumpPlayer player) {
    super(name, player);
  }
  
  public String transition() {
    if (player.sensePlatforms().size() == 0) {
      if (millis() - timeOfActivation > 1000) {
        return randomDirection(); 
      } else {
        return name;
      }
    }
    
    // only check what to do next every 0.2s while walking
    if (millis() - timeOfActivation < 200) {  // State transition when having waited for 200 milliseconds  
      return name;
    }
    
    if (isPlayerNear()) {
      println("player near! JumpLeft");
      return "JumpLeft";
    }
    
    SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();
    
    // if under the platform...
    if (targetPlatform.right.x > 0 && targetPlatform.right.y < 0) {
      // just continue walking
      println("under the platform!");
      return name;
    }
    println("targetPlatform.right.x", targetPlatform.right.x);
    if (targetPlatform.right.x < - 50 && targetPlatform.right.x > - 200 && isObjectiveAbove) {
      return "JumpLeft";
    }
    
    return "Search";
  }
  
  public void action() {
    player.moveSidewards( - 60);
  }
}

// ******************************************
// what is this little thing in my shoe, its 
// quite annoying, maybe i should... Jump Right!
// ******************************************


class AlbertoNilyaStateJumpRight extends AlbertoNilyaState {
    
  AlbertoNilyaStateJumpRight(String name, SumoJumpPlayer player) {
    super(name, player);
  }
  
  public String transition() {
    // after jumping, always search for what to do next
    return "Search";
  }
  
  public void action() {
    player.jumpUp(100);
    player.moveSidewards(50);
  }
}

// ******************************************
// once I met a farmer, he has this story to tell
// he has a collection of rabbits and rackoons
// and they were all friends and so on,
// but then one they a small capivara came to the party
// they felt an eerie vibration on their fur
// with the apporach of this capivara
// they said "I wonder what this capivara is doing here"
// the capivara said: "JumpLeft"
// ******************************************

class AlbertoNilyaStateJumpLeft extends AlbertoNilyaState {
  
  AlbertoNilyaStateJumpLeft(String name, SumoJumpPlayer player) {
    super(name, player);
    //this.player = player;
  }
  
  public String transition() {
    // after jumping, always search for what to do next
    return "Search";
  }
  
  public void action() {
    player.jumpUp(100);
    player.moveSidewards( - 50);
  }
}

// just little helper function to walk SOMEWHERE
String randomDirection() {
  if (random(0, 1) < 0.5) {
    return "WalkLeft";
  } else { 
    return "WalkRight";
  }
}