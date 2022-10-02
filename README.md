![](/image.png)

# SumoJumpGame - Assigment 2

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

## States

### Search

State when the agent is trying to understand what to do next, having the following possibilities

- if the player is flying, don't do anything (wait for landing)
- if the user doesn't have a platform to jump OR if the objective is not above, move/jump to the nearest objective
- if the player is within range, go walk on the direction to *get ready* to jump to the platform OR walk opposite direciton to get in position

### Walf-Right/Left

Walking is a state that is always activated from "search" state. The transition is checked every 0.2 seconds -> 

- if there are no platforms around, randomly walking to a direction and see if the situation changes
- if any player is too near, simply jump
- if player is under the target platform, walk nearest direction to get an angle to jump on it 
- if player is in position to jump on top of target platform AND objective is above -> Jump!

### Jump-Right/Left

Simply jump to a direction. After jumping the state always returns to "Search".