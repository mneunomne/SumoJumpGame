abstract class RandomDemoAgentState {
  protected boolean wasActiveLastCycle;  // Has this state just been entered?
  protected int timeOfActivation;        // When did we enter this state?
  protected String name;                 // State name

  // Each derived class needs to implement transitions
  abstract public String transition();

  // Each derived class needs to implement some kind of action
  abstract public void action();
  
  // Constructor (sets the state name)
  RandomDemoAgentState(String name) {
    this.name = name;
  }
  
  // Called by state machine in each cycle, calls action()
  void cycle(boolean isActivated) {
    if(isActivated) {
      wasActiveLastCycle = false;
      timeOfActivation = millis();
    } else {
      wasActiveLastCycle = true;
    }
    action();
  }
  
  // Return the state name
  String getName() {
    return name;
  }
}

class RandomDemoAgentStateMachine {
  private  HashMap<String, RandomDemoAgentState> states = new HashMap<String, RandomDemoAgentState>();
  private RandomDemoAgentState currentState = null;
  private RandomDemoAgentState lastState = null;

  public void addState(RandomDemoAgentState state) {
    if (states.containsKey(state.getName()))
      println("State " + state.getName() + " was alrady inserted!");
    else
      states.put(state.getName(), state);
  }

  public void setStartState(RandomDemoAgentState state) {
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
