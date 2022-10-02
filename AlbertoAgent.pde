class AlbertoAgent extends SumoJumpController {

  AlbertoStateMachine stateMachine;
  AlbertoStateSearch search;
  AlbertoStateWalkRight walkRight;
  AlbertoStateWalkLeft walkLeft;
  AlbertoStateJumpRight jumpRight;
  AlbertoStateJumpLeft jumpLeft;

  AlbertoAgent() {
    super();
  }

  void act() {
    if(stateMachine == null) {
      stateMachine = new AlbertoStateMachine();
      search = new AlbertoStateSearch("Search", player);
      walkRight = new AlbertoStateWalkRight("WalkRight", player);
      walkLeft  = new AlbertoStateWalkLeft("WalkLeft", player);
      jumpRight = new AlbertoStateJumpRight("JumpRight", player);
      jumpLeft = new AlbertoStateJumpLeft("JumpLeft", player);
      stateMachine.addState(search);
      stateMachine.addState(walkRight);
      stateMachine.addState(walkLeft);
      stateMachine.addState(jumpRight);
      stateMachine.addState(jumpLeft);
      stateMachine.setStartState(search);
    }
    stateMachine.step();
  }

  String getName() {;
    return "Alberto";
  }

  char getLetter() {
    return 'A';
  }

  color getColor() {
    return color(random(0,255), 0, 0);
  }

  void draw() {
    // Test drawing: sense the goals and draw lines to the goals:
    ArrayList<SumoJumpGoalMeasurement> goals = player.senseGoals();
    strokeWeight(5);
    stroke(255, 0, 0, 150);
    for (SumoJumpGoalMeasurement goal : goals) {
      line(0, 0, goal.position.x, goal.position.y);
    }

    // Test drawing visualize perception radius:
    SumoJumpProprioceptiveMeasurement proprio = player.senseProprioceptiveData();
    noStroke();
    fill(0, 0, 255, 50);
    ellipseMode(RADIUS);
    ellipse(0, 0, proprio.perceptionRadius, proprio.perceptionRadius);

    // Test drawing visualizing the perceived platforms:
    ArrayList<SumoJumpPlatformMeasurement> platforms = player.sensePlatforms();
    strokeWeight(10);
    for (SumoJumpPlatformMeasurement p : platforms) {
      if (p.standingOnThisPlatform)
        stroke(150, 255, 155, 200);
      else
        stroke(252, 60, 160, 200);
      line(p.left.x, p.left.y, p.right.x, p.right.y);
    }

    // Test drawing: Relative velocity
    stroke(0, 0, 0, 120);
    strokeWeight(6);
    line(0, 0, proprio.velocity.x, proprio.velocity.y);
  }
}