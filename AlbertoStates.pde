// ******************************************
// State for walking to the right side


class AlbertoStateSearch extends AlbertoState {

  //SumoJumpPlayer player;                    // Reference to player object

  PVector nextGoal;

  int jumpDistance = 100; 

  boolean isObjectiveAbove;

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

    // if already standing on platform... go for the goal
    if (onThisPlatform) {
      float goalX = getClosestGoal().position.x;
      println("goalX", goalX);
      String action = "";
      if (abs(goalX) > 100) {
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
      // if not, go for platform:
        
        /*
        if (targetPlatform.left.x > -450 && targetPlatform.left.x < -350) {
          return "JumpLeft";
        } else 

        if (targetPlatform.right.x < 450 && targetPlatform.right.x > 350) {
          return "JumpRight";
        } else
        */

      // check what side of the platform is closer
      if (targetPlatform.left.x < targetPlatform.right.x) {
        println("targetPlatform.left.x", targetPlatform.left.x);
        // left side is closer
        if (targetPlatform.left.x < -350) {
          return "WalkLeft";
        } else {
          return "WalkRight";
        }
      } else {
        println("targetPlatform.right.x", targetPlatform.right.x);
        if (targetPlatform.left.x > 350) {
          return "WalkRight";
        } else {
          return "WalkLeft";
        }
      }
    }

    // println("nextGoal", nextGoal);
    //return getNextAboveAction(nextTarget);

    // return name;
  }

  String getNextAction (PVector nextGoal, int platformSide) {
    boolean isAbove = nextGoal.y < 0;
    if (isAbove) {
      return getNextAboveAction(nextGoal);
    } else {
      return getNextBellowAction(nextGoal);
    }
  }

  String getNextAboveAction (PVector nextGoal) {
    String action = "";
    if (abs(nextGoal.x) > jumpDistance) {
      action = "Walk";
    } else {
      action = "Jump";
    }
    if (nextGoal.x > 0) {
      action += "Right";
    } else {
      action += "Left";
    }
    return action;
  }

  String getNextBellowAction (PVector nextGoal) {
    return "";
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
    SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();
    /*
    if (targetPlatform.left.x > -450 && targetPlatform.left.x < -350) {
        return "JumpLeft";
      } else 
    */

    println("WalkRight targetPlatform.right.x", targetPlatform.right.x);

    if (targetPlatform.right.x > 0 && targetPlatform.right.y < 0) {
      // under the platform
    }

    if (abs(targetPlatform.left.x) > abs(targetPlatform.right.x)) {
      // platform is to the left
      
    } else {
      // platform is to the right

    }
    
    if (targetPlatform.left.x > -450 && targetPlatform.left.x < -350) {
      return "JumpRight";
    }

   if (millis() - timeOfActivation > 200 ) {  // State transition when having waited for 200 milliseconds 
      return "Search";
    } else {
      return name;
    }
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
      SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();

    if (targetPlatform.left.x > -450 && targetPlatform.left.x < -350) {
      return "JumpLeft";
    }

     if (millis() - timeOfActivation > 200 ) {  // State transition when having waited for 200 milliseconds 
      return "Search";
    } else {
      return name;
    }
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
