;abstract class AlbertoState {
  protected boolean wasActiveLastCycle;  // Has this state just been entered?
  protected int timeOfActivation;        // When did we enter this state?
  protected String name;                 // State name
  PVector nextGoal;

  SumoJumpPlayer player;

  // Each derived class needs to implement transitions
  abstract public String transition();

  // Each derived class needs to implement some kind of action
  abstract public void action();

  boolean isObjectiveAbove = true;
  
  // Constructor (sets the state name)
  AlbertoState(String name, SumoJumpPlayer player) {
    this.name = name;
    this.player = player;
  }
  
  // Called by state machine in each cycle, calls action()
  void cycle(boolean isActivated) {
    if(isActivated) {
      wasActiveLastCycle = false;
      timeOfActivation = millis();
    } else {
      wasActiveLastCycle = true;
    }
    SumoJumpGoalMeasurement closestGoal = getClosestGoal();
    this.isObjectiveAbove = getClosestGoal().position.y < 0;
    //println("isObjectiveAbove", isObjectiveAbove, getClosestGoal().position.y);
    action();
  }
  
  // Return the state name
  String getName() {
    return name;
  }

  PVector getNextTarget () {
    SumoJumpGoalMeasurement closestGoal = getClosestGoal();

    if (player.sensePlatforms().size() == 0) {
      //println("noVisible platforms");
      return closestGoal.position;
    }

    SumoJumpPlatformMeasurement targetPlatform = getTargetPlatform();
    
    PVector  playerPos = player.sensePositionInPixelWorld();
    float distLeft = playerPos.dist(targetPlatform.left); 
    float distRight = playerPos.dist(targetPlatform.right);
    boolean onThisPlatform = targetPlatform.standingOnThisPlatform;

    //println("onThisPlatform!", targetPlatform.left.y);

    // if already standing on platform... go for the goal
    if (onThisPlatform) {
      return getClosestGoal().position;
    } else {
      if (targetPlatform.left.x > targetPlatform.right.x) {
        return targetPlatform.right;
      } else {
        return targetPlatform.left;
      }
    }
  }

  SumoJumpPlatformMeasurement getTargetPlatform () {
    ArrayList<SumoJumpPlatformMeasurement> platforms = player.sensePlatforms();
    SumoJumpGoalMeasurement nextGoal = getClosestGoal();
    int targetPlatformIndex = 0;
    float closestDist = 9999; 
    int i = 0;
    for (SumoJumpPlatformMeasurement platform : platforms) {
      float yDist = platform.left.y; 
      if (yDist < 0 && yDist < closestDist) {
        yDist = closestDist;
        targetPlatformIndex = i;
      }
      i++;
    }
    return platforms.get(targetPlatformIndex);
  }

  boolean isPlayerNear () {
    boolean isNear = false;
    ArrayList<SumoJumpOpponentMeasurement> opponents = player.senseOpponents();
    for (SumoJumpOpponentMeasurement opponent : opponents) {
      isNear = opponent.distance < 50 || isNear;
    }
    return isNear;
  }

  SumoJumpGoalMeasurement getClosestGoal () {
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    return goals.get(0);
  }
}

class AlbertoStateMachine {
  private  HashMap<String, AlbertoState> states = new HashMap<String, AlbertoState>();
  private AlbertoState currentState = null;
  private AlbertoState lastState = null;

  public void addState(AlbertoState state) {
    if (states.containsKey(state.getName()))
      println("State " + state.getName() + " was alrady inserted!");
    else
      states.put(state.getName(), state);
  }

  public void setStartState(AlbertoState state) {
    if (states.containsKey(state.getName())) {
      currentState = state;
    } else {
      println("State " + state.getName() + " does not exist in state machine and can not be set as start state!");
    }
  }

  public void step() {
    if (currentState == null) {
      println("No state is active. Maybe you did not set the start state?");
      return;
    }
    currentState.cycle(currentState != lastState);
    lastState = currentState;
    String nameOfNextState = currentState.transition();
    if (states.containsKey(nameOfNextState)) {
      currentState = states.get(nameOfNextState);
    } else {
      println("State " + nameOfNextState + " does not exist and transition is not made!");
    }
  }
}
