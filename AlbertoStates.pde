// ******************************************
// State for walking to the right side


class AlbertoStateSearch extends AlbertoState {

  //SumoJumpPlayer player;                    // Reference to player object

  PVector nextGoal;

  int jumpDistance = 100; 

  AlbertoStateSearch(String name, SumoJumpPlayer player) {
    super(name, player);
    //this.player = player;
  }

  public String transition() {
    //println("Search!");
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();

    if (!proprio.onFloor) {
      //println("flying!!!");
      return name;
    }

    //PVector nextTarget = getNextTarget();

    SumoJumpGoalMeasurement closestGoal = getClosestGoal();

    if (player.sensePlatforms().size() == 0) {
      println("noVisible platforms");
      return "WalkLeft";
    }

    SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();
    
    PVector  playerPos = player.sensePositionInPixelWorld();
    float distLeft = playerPos.dist(targetPlatform.left); 
    float distRight = playerPos.dist(targetPlatform.right);
    boolean onThisPlatform = targetPlatform.standingOnThisPlatform;

    println("onThisPlatform!", onThisPlatform);

    // if already standing on platform... go for the goal!!! (this is working fine)
    if (onThisPlatform) {
      float goalX = getClosestGoal().position.x;
      println("goalX", goalX);
      String action = "";

      if (abs(goalX) > 100 || !isObjectiveAbove) {
        action = "Walk";
      } else {
        action = "Jump";
      }
      if (goalX < 0) {
        action += "Left";
      } else {
        action += "Right";
      }
      return action;


    } else {

      if (abs(targetPlatform.left.x) > abs(targetPlatform.right.x)) {
        // platform is to the left
        
      } else {
        // platform is to the right

      }

      // check what side of the platform is closer
      if (targetPlatform.left.x < targetPlatform.right.x) {
        println("targetPlatform.left.x", targetPlatform.left.x);
        // left side is closer
        // approach jumping distance
        if (targetPlatform.left.x < -350) {
          // run to jump!
          println("run to jump!");
          return "WalkLeft";
        } else {
          // come back...
          println("come back...");
          return "WalkRight";
        }
      } else {
        println("targetPlatform.right.x", targetPlatform.right.x);
        // approach jumping distance
        if (targetPlatform.left.x > 350) {

          println("run to jump!");
          return "WalkRight";
          // run to jump!
        } else {
          // come back...
          return "WalkLeft";
        }
      }
    }

    // println("nextGoal", nextGoal);
    //return getNextAboveAction(nextTarget);

    // return name;
  }

  public void action() {
    
  }
 
}


class AlbertoStateWalkRight extends AlbertoState {


  AlbertoStateWalkRight(String name, SumoJumpPlayer player) {
    super(name, player);
    //this.player = player;
  }

  public String transition() {
    if (player.sensePlatforms().size() == 0) {
      if (millis() - timeOfActivation > 1000 ) {
      if (random(0, 1) < 0.5) {
        return "WalkLeft";
      } else { 
        return "WalkRight";
      }
      } else {
        return name;
      }
    }

    if (millis() - timeOfActivation < 200 ) {  // State transition when having waited for 200 milliseconds  
      return name;
    }

    if(isPlayerNear()) {
      println("player near! JumpRight");
      return "JumpRight";
    }

    SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();

    // if under the platform...
    if (targetPlatform.right.x > 0 && targetPlatform.left.x < 0) {
      println("under the platform!");
      // just continue walking
      return name;
    }

    println("isObjectiveAbove", isObjectiveAbove);
    
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
// State for walking to the left side

class AlbertoStateWalkLeft extends AlbertoState {

  //SumoJumpPlayer player;                    // Reference to player object

  AlbertoStateWalkLeft(String name, SumoJumpPlayer player) {
    super(name, player);
  }

  public String transition() {
     if (player.sensePlatforms().size() == 0) {
      if (millis() - timeOfActivation > 1000 ) {
      if (random(0, 1) < 0.5) {
        return "WalkLeft";
      } else { 
        return "WalkRight";
      }
      } else {
        return name;
      }
    }



    if (millis() - timeOfActivation < 200 ) {  // State transition when having waited for 200 milliseconds  
      return name;
    }

    if(isPlayerNear()) {
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

    if (targetPlatform.left.x > -450 && targetPlatform.left.x < -350 && isObjectiveAbove) {
      return "JumpLeft";
    }

    return "Search";
  }

  public void action() {
    player.moveSidewards(-60);
  }
}

class AlbertoStateJumpRight extends AlbertoState {

  //SumoJumpPlayer player;                    // Reference to player object

  AlbertoStateJumpRight(String name, SumoJumpPlayer player) {
    super(name, player);
  }

  public String transition() {
   return "Search";
  }

  public void action() {
    player.jumpUp(100);
    player.moveSidewards(30);
  }
}

class AlbertoStateJumpLeft extends AlbertoState {

  //SumoJumpPlayer player;                    // Reference to player object

  AlbertoStateJumpLeft(String name, SumoJumpPlayer player) {
    super(name, player);
    //this.player = player;
  }

  public String transition() {
   return "Search";
  }

  public void action() {
    player.jumpUp(100);
    player.moveSidewards(-30);
  }
}
