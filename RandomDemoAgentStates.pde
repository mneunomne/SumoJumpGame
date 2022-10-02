// ******************************************
// State for walking to the right side

class RandomDemoAgentStateWalkRight extends RandomDemoAgentState {

  SumoJumpPlayer player;                    // Reference to player object

  RandomDemoAgentStateWalkRight(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    if (random(0, 1) < 0.01)
      return "Jump";
    if (millis() - timeOfActivation > 2000)   // State transition when having waited for 2000 milliseconds
      return "WalkLeft";
    return name;
  };

  public void action() {
    player.moveSidewards(80);
  }
}


// ******************************************
// State for walking to the left side

class RandomDemoAgentStateWalkLeft extends RandomDemoAgentState {

  SumoJumpPlayer player;                    // Reference to player object

  RandomDemoAgentStateWalkLeft(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    if (random(0, 1) < 0.01)
      return "Jump";
    if (millis() - timeOfActivation > 2000)   // State transition when having waited for 2000 milliseconds
      return "WalkRight";
    return name;
  }

  public void action() {
    player.moveSidewards(-80);
  }
}


// ******************************************
// State for randomly jumping

class RandomDemoAgentStateJump extends RandomDemoAgentState {

  SumoJumpPlayer player;                    // Reference to player object

  RandomDemoAgentStateJump(String name, SumoJumpPlayer player) {
    super(name);
    this.player = player;
  }

  public String transition() {
    if (millis() - timeOfActivation > 200 ) {  // State transition when having waited for 200 milliseconds
      if (random(0, 1) < 0.5) {
        return "WalkLeft";
      } else { 
        return "WalkRight";
      }
    } else
      return name;
  }

  public void action() {
    player.jumpUp(100);
  }
}
